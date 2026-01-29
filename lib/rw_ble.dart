import 'dart:async';
import 'package:flutter/services.dart';

class RwBle {
  static const MethodChannel _method = MethodChannel('rw_ble/methods');
  static const EventChannel _scanEvents = EventChannel('rw_ble/scan');
  static const EventChannel _healthEvents = EventChannel('rw_ble/health');

  /// --------------------
  /// SCAN
  /// --------------------
  static Stream<Map<String, dynamic>> scanStream() {
    return _scanEvents
        .receiveBroadcastStream()
        .map((e) => Map<String, dynamic>.from(e));
  }

  static Future<void> startScan() => _method.invokeMethod('startScan');
  static Future<void> stopScan() => _method.invokeMethod('stopScan');

  /// --------------------
  /// CONNECTION
  /// --------------------
  static Future<void> connect(String mac) =>
      _method.invokeMethod('connect', {'mac': mac});

  static Future<void> login(String userId) =>
      _method.invokeMethod('login', {'userId': userId});

  /// --------------------
  /// BATTERY
  /// --------------------
  static Future<int> getBattery() async =>
      await _method.invokeMethod('getBattery');

  /// --------------------
  /// HEALTH STREAMS (REAL-TIME)
  /// --------------------
  static Stream<Map<String, dynamic>> healthStream() {
    return _healthEvents
        .receiveBroadcastStream()
        .map((e) => Map<String, dynamic>.from(e));
  }

  static Stream<int> hrStream() =>
      healthStream().where((e) => e['type'] == 'hr').map((e) => e['value'] as int);

  static Stream<int> spo2Stream() =>
      healthStream().where((e) => e['type'] == 'spo2').map((e) => e['value'] as int);

  static Stream<int> hrvStream() =>
      healthStream().where((e) => e['type'] == 'hrv').map((e) => e['value'] as int);

  static Stream<int> stressStream() =>
      healthStream().where((e) => e['type'] == 'stress').map((e) => e['value'] as int);

  static Stream<int> bloodSugarStream() =>
      healthStream().where((e) => e['type'] == 'bloodSugar').map((e) => e['value'] as int);

  static Stream<List<StepData>> stepStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'step')
          .map((e) => (e['data'] as List)
          .map((item) => StepData.fromMap(item))
          .toList());

  static Stream<List<SleepData>> sleepStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'sleep')
          .map((e) => (e['data'] as List)
          .map((item) => SleepData.fromMap(item))
          .toList());

  static Stream<List<HRData>> hrHistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'hr')
          .map((e) => (e['data'] as List)
          .map((item) => HRData.fromMap(item))
          .toList());

  static Stream<List<HRVData>> hrvHistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'hrv')
          .map((e) => (e['data'] as List)
          .map((item) => HRVData.fromMap(item))
          .toList());

  static Stream<List<StressData>> stressHistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'stress')
          .map((e) => (e['data'] as List)
          .map((item) => StressData.fromMap(item))
          .toList());

  static Stream<List<SpO2Data>> spo2HistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'spo2')
          .map((e) => (e['data'] as List)
          .map((item) => SpO2Data.fromMap(item))
          .toList());

  static Stream<List<BloodSugarData>> bloodSugarHistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'bloodSugar')
          .map((e) => (e['data'] as List)
          .map((item) => BloodSugarData.fromMap(item))
          .toList());

  static Stream<List<MuslimPraiseData>> muslimPraiseHistoryStream() =>
      healthStream()
          .where((e) => e['type'] == 'history' && e['subType'] == 'muslimPraise')
          .map((e) => (e['data'] as List)
          .map((item) => MuslimPraiseData.fromMap(item))
          .toList());

  /// --------------------
  /// START / STOP TEST
  /// --------------------
  static Future<void> startHealthTest(String type) =>
      _method.invokeMethod('startHealthTest', {'type': type});

  static Future<void> stopHealthTest(String type) =>
      _method.invokeMethod('stopHealthTest', {'type': type});

  /// --------------------
  /// HISTORY SYNC
  /// --------------------
  static Future<void> syncHistory({
    bool stress = false,
    bool bloodSugar = false,
    bool muslimPraise = false,
  }) =>
      _method.invokeMethod('syncHistory', {
        'stress': stress,
        'bloodSugar': bloodSugar,
        'muslimPraise': muslimPraise,
      });
}

/// --------------------
/// DATA MODELS
/// --------------------
class StepData {
  final String timestamp;
  final int step;
  final int calorie;
  final int distance;

  StepData({required this.timestamp, required this.step, required this.calorie, required this.distance});

  factory StepData.fromMap(Map map) {
    return StepData(
      timestamp: map['timestamp'].toString(),
      step: map['step'] ?? 0,
      calorie: map['calorie'] ?? 0,
      distance: map['distance'] ?? 0,
    );
  }
}

class SleepData {
  final String timestamp;
  final int duration;
  final int sleepType;

  SleepData({required this.timestamp, required this.duration, required this.sleepType});

  factory SleepData.fromMap(Map map) {
    return SleepData(
      timestamp: map['timestamp'].toString(),
      duration: map['duration'] ?? 0,
      sleepType: map['status'] ?? 0,
    );
  }
}

class HRData {
  final String timestamp;
  final int value;

  HRData({required this.timestamp, required this.value});

  factory HRData.fromMap(Map map) {
    return HRData(
      timestamp: map['timestamp'].toString(),
      value: map['value'] ?? 0,
    );
  }
}

class HRVData extends HRData {
  HRVData({required super.timestamp, required super.value});

  factory HRVData.fromMap(Map map) => HRVData(timestamp: map['timestamp'].toString(), value: map['value'] ?? 0);
}

class StressData extends HRData {
  StressData({required super.timestamp, required super.value});

  factory StressData.fromMap(Map map) => StressData(timestamp: map['timestamp'].toString(), value: map['value'] ?? 0);
}

class SpO2Data extends HRData {
  SpO2Data({required super.timestamp, required super.value});

  factory SpO2Data.fromMap(Map map) => SpO2Data(timestamp: map['timestamp'].toString(), value: map['value'] ?? 0);
}

class BloodSugarData extends HRData {
  BloodSugarData({required super.timestamp, required super.value});

  factory BloodSugarData.fromMap(Map map) => BloodSugarData(timestamp: map['timestamp'].toString(), value: map['value'] ?? 0);
}

class MuslimPraiseData {
  final String timestamp;
  final int value;

  MuslimPraiseData({required this.timestamp, required this.value});

  factory MuslimPraiseData.fromMap(Map map) => MuslimPraiseData(
      timestamp: map['timestamp'].toString(),
      value: map['value'] ?? 0
  );
}


/// --------------------
/// MONITORING CONTROLS
/// --------------------
extension RwBleHealthControl on RwBle {
  /// --------------------
  /// SET MONITOR INTERVALS (minutes)
  /// --------------------
  /// Heart Rate: 30 or 60 minutes
  static Future<void> setHeartRateInterval(int minutes) async {
    assert(minutes == 30 || minutes == 60, 'Heart rate interval must be 30 or 60 min');
    await RwBle._method.invokeMethod('setHeartRateInterval', {'interval': minutes});
  }

  /// Blood Oxygen / HRV / Stress / Blood Sugar: on/off only
  static Future<void> setBloodOxygenMonitoring(bool isOpen) async {
    await RwBle._method.invokeMethod('setBoMonitoring', {'isOpen': isOpen});
  }

  static Future<void> setHRVMonitoring(bool isOpen) async {
    await RwBle._method.invokeMethod('setHrvMonitoring', {'isOpen': isOpen});
  }

  static Future<void> setStressMonitoring(bool isOpen) async {
    await RwBle._method.invokeMethod('setStressMonitoring', {'isOpen': isOpen});
  }

  static Future<void> setBloodSugarMonitoring(bool isOpen) async {
    await RwBle._method.invokeMethod('setBloodSugarMonitoring', {'isOpen': isOpen});
  }

  /// --------------------
  /// START / STOP REAL-TIME TESTS
  /// --------------------
  static Future<void> startHRTest() async => RwBle.startHealthTest('hr');
  static Future<void> stopHRTest() async => RwBle.stopHealthTest('hr');

  static Future<void> startSpO2Test() async => RwBle.startHealthTest('spo2');
  static Future<void> stopSpO2Test() async => RwBle.stopHealthTest('spo2');

  static Future<void> startHRVTest() async => RwBle.startHealthTest('hrv');
  static Future<void> stopHRVTest() async => RwBle.stopHealthTest('hrv');

  static Future<void> startStressTest() async => RwBle.startHealthTest('stress');
  static Future<void> stopStressTest() async => RwBle.stopHealthTest('stress');

  static Future<void> startBloodSugarTest() async => RwBle.startHealthTest('bloodSugar');
  static Future<void> stopBloodSugarTest() async => RwBle.stopHealthTest('bloodSugar');
}
