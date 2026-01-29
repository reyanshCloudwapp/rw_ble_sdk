import Flutter
import UIKit
import DHBleSDK

public class SwiftRwBlePlugin: NSObject, FlutterPlugin {

    // Store scanned peripherals
    private var scannedDevices: [String: DHPeripheralModel] = [:]

    private var healthSink: FlutterEventSink?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "rw_ble/methods", binaryMessenger: registrar.messenger())
        let eventScan = FlutterEventChannel(name: "rw_ble/scan", binaryMessenger: registrar.messenger())
        let eventHealth = FlutterEventChannel(name: "rw_ble/health", binaryMessenger: registrar.messenger())

        let instance = SwiftRwBlePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventHealth.setStreamHandler(instance)
        eventScan.setStreamHandler(instance)
    }

    private var methodChannel: FlutterMethodCall?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startScan":
            DHBleCentralManager.startScan()
            result(nil)

        case "stopScan":
            DHBleCentralManager.stopScan()
            result(nil)

        case "connect":
              if let args = call.arguments as? [String: Any],
                    let mac = args["mac"] as? String,
                    let peripheral = scannedDevices[mac] {
                     DHBleCentralManager.connectDevice(with: peripheral)
                     result(nil)
                 } else {
                     result(FlutterError(code: "404", message: "Device not found", details: nil))
                 }
        case "login":
            if let args = call.arguments as? [String: Any],
               let userId = args["userId"] as? String {
                DHBleCommand.getJLBindInfoLogin { code, data in
                    result(nil)
                }
            }

        case "getBattery":
            DHBleCommand.getBattery { code, data in
                if let battery = data as? DHBatteryInfoModel {
                    result(battery.battery)
                } else {
                    result(0)
                }
            }

        case "startHealthTest":
            if let args = call.arguments as? [String: Any],
               let type = args["type"] as? String {
                startTest(type)
            }
            result(nil)

        case "stopHealthTest":
            if let args = call.arguments as? [String: Any],
               let type = args["type"] as? String {
                stopTest(type)
            }
            result(nil)

        case "syncHistory":
            if let args = call.arguments as? [String: Any] {
                let stress = args["stress"] as? Bool ?? false
                let bloodSugar = args["bloodSugar"] as? Bool ?? false
                let muslimPraise = args["muslimPraise"] as? Bool ?? false

                DHBleCommand.startDataSyncing(
                    _: stress,
                    supportBloodSugar: bloodSugar,
                    supportMuslimPraise: muslimPraise
                ) { code, progress, data in
                    guard code == 0 else { return }

                    if let array = data as? [Any] {
                        for model in array {
                            var event: [String: Any] = [
                                "type": "history",
                                "timestamp": Int(Date().timeIntervalSince1970)
                            ]

                            switch model {
                            case let step as DHDailyStepModel:
                                event["subType"] = "step"
                                event["step"] = step.step
                                event["calorie"] = step.calorie
                                event["distance"] = step.distance
                                event["items"] = step.items
                            case let sleep as DHDailySleepModel:
                                event["subType"] = "sleep"
                                event["duration"] = sleep.duration
                                event["beginTime"] = sleep.beginTime
                                event["endTime"] = sleep.endTime
                                event["items"] = sleep.items
                            case let hr as DHDailyHrModel:
                                event["subType"] = "hr"
                                event["items"] = hr.items
                            case let bo as DHDailyBoModel:
                                event["subType"] = "spo2"
                                event["items"] = bo.items
                            case let hrv as DHDailyHrvModel:
                                event["subType"] = "hrv"
                                event["items"] = hrv.items
                            case let stressModel as DHDailyPressureModel:
                                event["subType"] = "stress"
                                event["items"] = stressModel.items
                            case let bs as DHDailyBloodSugarModel:
                                event["subType"] = "bloodSugar"
                                event["items"] = bs.items
                            case let muslim as DHDailyMuslimCountModel:
                                event["subType"] = "muslimPraise"
                                event["muslimCount"] = muslim.muslimcount
                                event["items"] = muslim.items
                            default:
                                continue
                            }

                            self.healthSink?(event)
                        }
                    }
                }
            }
            result(nil)   // <--- close the "syncHistory" case properly

        case "setHeartRateInterval":
            if let args = call.arguments as? [String: Any],
               let interval = args["interval"] as? Int {
                setHeartRateInterval(interval)
            }
            result(nil)

        case "setBoMonitoring":
            if let args = call.arguments as? [String: Any],
               let isOpen = args["isOpen"] as? Bool {
                setBoMonitoring(isOpen)
            }
            result(nil)

        case "setHrvMonitoring":
            if let args = call.arguments as? [String: Any],
               let isOpen = args["isOpen"] as? Bool {
                setHRVMonitoring(isOpen)
            }
            result(nil)

        case "setStressMonitoring":
            if let args = call.arguments as? [String: Any],
               let isOpen = args["isOpen"] as? Bool {
                setStressMonitoring(isOpen)
            }
            result(nil)

        case "setBloodSugarMonitoring":
            if let args = call.arguments as? [String: Any],
               let isOpen = args["isOpen"] as? Bool {
                setBloodSugarMonitoring(isOpen)
            }
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        } // <--- closes the switch
    }


private func startTest(_ type: String) {
    let key: Int
    switch type {
    case "hr": key = 1
    case "spo2": key = 2
    case "hrv": key = 3
    case "stress": key = 4
    case "bloodSugar": key = 5
    default: return
    }
    DHBleCommand.controlOpen(1, dataType: key) { _, _ in }
}

private func stopTest(_ type: String) {
    let key: Int
    switch type {
    case "hr": key = 1
    case "spo2": key = 2
    case "hrv": key = 3
    case "stress": key = 4
    case "bloodSugar": key = 5
    default: return
    }
    DHBleCommand.controlOpen(0, dataType: key) { _, _ in }
}

    // MARK: - Monitoring Settings
    private func setHeartRateInterval(_ minutes: Int) {
              let model = DHHeartRateModeSetModel()
              model.isOpen = true
              model.startHour = 0
              model.startMinute = 0
              model.endHour = 23
              model.endMinute = 59
              model.interval = minutes
              DHBleCommand.setHeartRateMode(model) { code, data in
                  if code == 0 { print("Heart rate interval set to \(minutes) min") }
              }
          }

          private func setBoMonitoring(_ isOpen: Bool) {
              let model = DHBoModeSetModel()
              model.isOpen = isOpen
              model.startHour = 0
              model.startMinute = 0
              model.endHour = 23
              model.endMinute = 59
              model.interval = 60 // fixed 1 hour
              DHBleCommand.setBoMode(model) { code, data in
                  if code == 0 { print("Blood oxygen monitoring set: \(isOpen)") }
              }
          }

          private func setHRVMonitoring(_ isOpen: Bool) {
              let model = DHHrvModeSetModel()
              model.isOpen = isOpen
              model.startHour = 0
              model.startMinute = 0
              model.endHour = 23
              model.endMinute = 59
              model.interval = 60
              DHBleCommand.setHrvMode(model) { code, data in
                  if code == 0 { print("HRV monitoring set: \(isOpen)") }
              }
          }

          private func setStressMonitoring(_ isOpen: Bool) {
              let model = DHStressModeSetModel()
              model.isOpen = isOpen
              model.startHour = 0
              model.startMinute = 0
              model.endHour = 23
              model.endMinute = 59
              model.interval = 60
              DHBleCommand.setStressMode(model) { code, data in
                  if code == 0 { print("Stress monitoring set: \(isOpen)") }
              }
          }

          private func setBloodSugarMonitoring(_ isOpen: Bool) {
              let model = DHBloodSugarModeSetModel()
              model.isOpen = isOpen
              model.startHour = 0
              model.startMinute = 0
              model.endHour = 23
              model.endMinute = 59
              model.interval = 60
              DHBleCommand.setBloodSugarMode(model) { code, data in
                  if code == 0 { print("Blood sugar monitoring set: \(isOpen)") }
              }
          }

}

// MARK: Event Channel StreamHandler
extension SwiftRwBlePlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.healthSink = events
        setupHealthCallbacks()
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.healthSink = nil
        return nil
    }

    func setupHealthCallbacks() {
        NotificationCenter.default.addObserver(self, selector: #selector(healthDataChanged(_:)),
                                               name: NSNotification.Name(BluetoothNotificationHealthRingMeasureValueChange), object: nil)
    }

    @objc
    func healthDataChanged(_ ntf: Notification) {
      guard let info = ntf.userInfo,
            let type = info["dataType"] as? Int,
            let value = info["dataValue"] as? Int else { return }

      var event: [String: Any] = [
          "timestamp": Int(Date().timeIntervalSince1970)
      ]

      switch type {
        case 1: event["type"] = "hr"
        case 2: event["type"] = "spo2"
        case 3: event["type"] = "hrv"
        case 4: event["type"] = "stress"
        case 5: event["type"] = "bloodSugar"
        default: return
      }

      event["value"] = value
      healthSink?(event)
    }
}
