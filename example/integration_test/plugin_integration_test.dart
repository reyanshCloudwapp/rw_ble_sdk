import 'package:flutter_test/flutter_test.dart';
import 'package:rw_ble/rw_ble.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RwBle Plugin Integration Test', () {
    test('Start and stop BLE scan', () async {
      // Start scan
      await RwBle.startScan();
      await Future.delayed(const Duration(seconds: 2)); // give it time
      // Stop scan
      await RwBle.stopScan();
    });

    test('Connect to device (mock MAC)', () async {
      const testMac = '00:11:22:33:44:55';
      await RwBle.connect(testMac);
    });

    test('Login with userId', () async {
      const testUserId = 'user123';
      await RwBle.login(testUserId);
    });

    test('Get battery level', () async {
      final battery = await RwBle.getBattery();
      print('Battery level: $battery');
      expect(battery >= 0 && battery <= 100, true);
    });

    test('Subscribe to real-time health streams', () async {
      final hrStream = RwBle.hrStream();
      final spo2Stream = RwBle.spo2Stream();
      final stressStream = RwBle.stressStream();
      final bloodSugarStream = RwBle.bloodSugarStream();

      final hrFuture = hrStream.first;
      final spo2Future = spo2Stream.first;
      final stressFuture = stressStream.first;
      final sugarFuture = bloodSugarStream.first;

      final hr = await hrFuture;
      final spo2 = await spo2Future;
      final stress = await stressFuture;
      final sugar = await sugarFuture;

      print('HR: $hr, SpO2: $spo2, Stress: $stress, Blood Sugar: $sugar');

      expect(hr >= 0, true);
      expect(spo2 >= 0, true);
      expect(stress >= 0, true);
      expect(sugar >= 0, true);
    });

    test('Sync history data', () async {
      await RwBle.syncHistory(stress: true, bloodSugar: true, muslimPraise: true);

      // Listen to step history for test
      final steps = await RwBle.stepStream().first;
      final sleep = await RwBle.sleepStream().first;

      print('First step entry: ${steps.isNotEmpty ? steps.first.step : 'No data'}');
      print('First sleep entry: ${sleep.isNotEmpty ? sleep.first.duration : 'No data'}');

      expect(steps, isA<List<StepData>>());
      expect(sleep, isA<List<SleepData>>());
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
  });
}
