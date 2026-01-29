package com.cwt.rw_ble

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import com.dh.ble.DHBleSdk
import com.dh.ble.callback.HealthSyncCallback
import com.dh.ble.model.HealthDataSyncBean
import com.dh.ble.constants.CmdConstants
import com.dh.ble.model.DHHeartRateModeSetModel

class RwBlePlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var channel: MethodChannel
    private lateinit var healthChannel: EventChannel
    private lateinit var healthSink: EventChannel.EventSink

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "rw_ble/methods")
        healthChannel = EventChannel(binding.binaryMessenger, "rw_ble/health")
        channel.setMethodCallHandler(this)
        healthChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        healthChannel.setStreamHandler(null)
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        events?.let { healthSink = it }
        subscribeHealthData()
    }

    override fun onCancel(arguments: Any?) {}

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method){
            "startScan" -> {
                DHBleSdk.startScan()
                result.success(null)
            }
            "stopScan" -> {
                DHBleSdk.stopScan()
                result.success(null)
            }
            "connect" -> {
                val mac = call.argument<String>("mac") ?: ""
                DHBleSdk.connect(mac)
                result.success(null)
            }
            "login" -> {
                val userId = call.argument<String>("userId") ?: ""
                DHBleSdk.login(userId)
                result.success(null)
            }
            "getBattery" -> {
                result.success(DHBleSdk.getBattery())
            }
            "startHealthTest" -> {
                val type = call.argument<String>("type")
                DHBleSdk.startHealthTest(type)
                result.success(null)
            }
            "stopHealthTest" -> {
                val type = call.argument<String>("type")
                DHBleSdk.stopHealthTest(type)
                result.success(null)
            }
            "syncHistory" -> {
                val stress = call.argument<Boolean>("stress") ?: false
                val bloodSugar = call.argument<Boolean>("bloodSugar") ?: false
                DHBleSdk.syncHistory(stress, bloodSugar, object : HealthSyncCallback {
                    override fun onData(data: HealthData) {
                        healthSink.success(mapOf("type" to "history", "data" to data))
                    }
                })
                result.success(null)
            }
            "setHeartRateInterval" -> {
                val interval = call.argument<Int>("interval") ?: 30
                setHeartRateInterval(interval)
                result.success(null)
            }
            "setBoMonitoring" -> {
                val isOpen = call.argument<Boolean>("isOpen") ?: true
                setBoMonitoring(isOpen)
                result.success(null)
            }
            "setHrvMonitoring" -> {
                val isOpen = call.argument<Boolean>("isOpen") ?: true
                setHrvMonitoring(isOpen)
                result.success(null)
            }
            "setStressMonitoring" -> {
                val isOpen = call.argument<Boolean>("isOpen") ?: true
                setStressMonitoring(isOpen)
                result.success(null)
            }
            "setBloodSugarMonitoring" -> {
                val isOpen = call.argument<Boolean>("isOpen") ?: true
                setBloodSugarMonitoring(isOpen)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }


    private fun subscribeHealthData() {
        // Heart Rate
        DHBleSdk.subscribeData(CmdConstants.JL_HR_DATA_TRANSFER_KEY, object : HealthDataBroCallback {
            override fun onResult(data: HealthDataSyncBean?) {
                data?.hrPartData?.lastOrNull()?.let { hr ->
                    healthSink.success(mapOf("type" to "hr", "value" to hr.hr, "timestamp" to System.currentTimeMillis()))
                }
            }
            override fun onFail(errorCode: Int) {}
            override fun onSuccess() {}
        })

        // SpO2
        DHBleSdk.subscribeData(CmdConstants.JL_BO_DATA_TRANSFER_KEY, object : HealthDataBroCallback {
            override fun onResult(data: HealthDataSyncBean?) {
                data?.boPartData?.lastOrNull()?.let { bo ->
                    healthSink.success(mapOf("type" to "spo2", "value" to bo.bo, "timestamp" to System.currentTimeMillis()))
                }
            }
            override fun onFail(errorCode: Int) {}
            override fun onSuccess() {}
        })

        // HRV
        DHBleSdk.subscribeData(CmdConstants.JL_HRV_DATA_TRANSFER_KEY, object : HealthDataBroCallback {
            override fun onResult(data: HealthDataSyncBean?) {
                data?.hrvPartData?.lastOrNull()?.let { hrv ->
                    healthSink.success(mapOf("type" to "hrv", "value" to hrv.hrv, "timestamp" to System.currentTimeMillis()))
                }
            }
            override fun onFail(errorCode: Int) {}
            override fun onSuccess() {}
        })

        // Stress
        DHBleSdk.subscribeData(CmdConstants.JL_PRESSURE_DATA_TRANSFER_KEY, object : HealthDataBroCallback {
            override fun onResult(data: HealthDataSyncBean?) {
                data?.pressurePartData?.lastOrNull()?.let { stress ->
                    healthSink.success(mapOf("type" to "stress", "value" to stress.pressure, "timestamp" to System.currentTimeMillis()))
                }
            }
            override fun onFail(errorCode: Int) {}
            override fun onSuccess() {}
        })

        // Blood Sugar
        DHBleSdk.subscribeData(CmdConstants.JL_BLOODSUGAR_DATA_TRANSFER_KEY, object : HealthDataBroCallback {
            override fun onResult(data: HealthDataSyncBean?) {
                data?.bloodSugarPartData?.lastOrNull()?.let { sugar ->
                    healthSink.success(mapOf("type" to "bloodSugar", "value" to sugar.value, "timestamp" to System.currentTimeMillis()))
                }
            }
            override fun onFail(errorCode: Int) {}
            override fun onSuccess() {}
        })
    }


    // SET MONITORING INTERVALS / ON-OFF
    private fun setHeartRateInterval(minutes: Int) {
        val model = DHHeartRateModeSetModel()
        model.isOpen = true
        model.startHour = 0
        model.startMinute = 0
        model.endHour = 23
        model.endMinute = 59
        model.interval = minutes
        DHBleSdk.setHeartRateMode(model) // SDK method
    }

    private fun setBoMonitoring(isOpen: Boolean) {
        val model = DHBoModeSetModel()
        model.isOpen = isOpen
        model.startHour = 0
        model.startMinute = 0
        model.endHour = 23
        model.endMinute = 59
        model.interval = 60
        DHBleSdk.setBoMode(model)
    }

    private fun setHrvMonitoring(isOpen: Boolean) {
        val model = DHHrvModeSetModel()
        model.isOpen = isOpen
        model.startHour = 0
        model.startMinute = 0
        model.endHour = 23
        model.endMinute = 59
        model.interval = 60
        DHBleSdk.setHrvMode(model)
    }

    private fun setStressMonitoring(isOpen: Boolean) {
        val model = DHStressModeSetModel()
        model.isOpen = isOpen
        model.startHour = 0
        model.startMinute = 0
        model.endHour = 23
        model.endMinute = 59
        model.interval = 60
        DHBleSdk.setStressMode(model)
    }

    private fun setBloodSugarMonitoring(isOpen: Boolean) {
        val model = DHBloodSugarModeSetModel()
        model.isOpen = isOpen
        model.startHour = 0
        model.startMinute = 0
        model.endHour = 23
        model.endMinute = 59
        model.interval = 60
        DHBleSdk.setBloodSugarMode(model)
    }



}

