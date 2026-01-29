import 'package:flutter_test/flutter_test.dart';
import 'package:rw_ble/rw_ble.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RwBle Plugin Tests', () {
    test('Start and stop scan', () async {
      print('Starting scan...');
      await RwBle.startScan();
      await Future.delayed(const Duration(seconds: 2));
      await RwBle.stopScan();
      print('Scan stopped.');
    });

    test('Connect and login', () async {
      const testMac = "AA:BB:CC:DD:EE:FF"; // Replace with real test device MAC
      const testUserId = "user123";

      await RwBle.connect(testMac);
      await RwBle.login(testUserId);

      print('Connected and logged in.');
    });

    test('Get battery', () async {
      final battery = await RwBle.getBattery();
      print('Battery level: $battery%');
      expect(battery, isNonNegative);
      expect(battery, lessThanOrEqualTo(100));
    });

    test('Start and stop real-time health tests', () async {
      await RwBleHealthControl.startHRTest();
      await Future.delayed(const Duration(seconds: 1));
      await RwBleHealthControl.stopHRTest();

      await RwBleHealthControl.startSpO2Test();
      await Future.delayed(const Duration(seconds: 1));
      await RwBleHealthControl.stopSpO2Test();

      await RwBleHealthControl.startHRVTest();
      await Future.delayed(const Duration(seconds: 1));
      await RwBleHealthControl.stopHRVTest();

      await RwBleHealthControl.startStressTest();
      await Future.delayed(const Duration(seconds: 1));
      await RwBleHealthControl.stopStressTest();

      await RwBleHealthControl.startBloodSugarTest();
      await Future.delayed(const Duration(seconds: 1));
      await RwBleHealthControl.stopBloodSugarTest();
    });

    test('Set monitoring intervals and on/off', () async {
      await RwBleHealthControl.setHeartRateInterval(30);
      await RwBleHealthControl.setBloodOxygenMonitoring(true);
      await RwBleHealthControl.setHRVMonitoring(true);
      await RwBleHealthControl.setStressMonitoring(true);
      await RwBleHealthControl.setBloodSugarMonitoring(true);
    });

    test('Listen to real-time health data', () async {
      final hrStream = RwBle.hrStream().take(3).toList();
      final spo2Stream = RwBle.spo2Stream().take(3).toList();

      print('Waiting for HR and SpO2 events...');
      final hrValues = await hrStream;
      final spo2Values = await spo2Stream;

      print('HR events: $hrValues');
      print('SpO2 events: $spo2Values');

      expect(hrValues.length, greaterThan(0));
      expect(spo2Values.length, greaterThan(0));
    });

    test('Sync history data', () async {
      await RwBle.syncHistory(stress: true, bloodSugar: true, muslimPraise: true);

      final steps = await RwBle.stepStream().take(1).toList();
      final sleep = await RwBle.sleepStream().take(1).toList();

      print('Step history: $steps');
      print('Sleep history: $sleep');

      expect(steps.isNotEmpty, true);
      expect(sleep.isNotEmpty, true);
    });
  });
}
