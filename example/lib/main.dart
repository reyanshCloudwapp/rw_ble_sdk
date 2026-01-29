import 'package:flutter/material.dart';
import 'package:rw_ble/rw_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RW BLE Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int hr = 0;
  int spo2 = 0;
  int stress = 0;
  int steps = 0;

  List<StepData> stepHistory = [];

  @override
  void initState() {
    super.initState();
    // Subscribe to real-time data
    RwBle.hrStream().listen((v) => setState(() => hr = v));
    RwBle.spo2Stream().listen((v) => setState(() => spo2 = v));
    RwBle.stressStream().listen((v) => setState(() => stress = v));

    // Subscribe to step history
    RwBle.stepStream().listen((list) {
      setState(() {
        stepHistory = list;
        if (list.isNotEmpty) steps = list.last.step;
      });
    });
  }

  Future<void> startScan() async {
    await RwBle.startScan();
  }

  Future<void> stopScan() async => await RwBle.stopScan();

  Future<void> connectDevice(String mac) async => await RwBle.connect(mac);

  Future<void> loginUser(String userId) async => await RwBle.login(userId);

  Future<void> syncHistory() async => await RwBle.syncHistory(stress: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RW BLE Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Real-Time Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DataTile(label: 'Heart Rate', value: '$hr bpm'),
            DataTile(label: 'SpO₂', value: '$spo2 %'),
            DataTile(label: 'Stress', value: '$stress'),
            DataTile(label: 'Steps', value: '$steps'),
            const Divider(height: 40),
            const Text(
              'History Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stepHistory.length,
                itemBuilder: (context, index) {
                  final step = stepHistory[index];
                  return ListTile(
                    title: Text('Steps: ${step.step}'),
                    subtitle: Text(
                      'Time: ${step.timestamp} | Distance: ${step.distance} m | Calorie: ${step.calorie} kcal',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: startScan,
            tooltip: 'Start Scan',
            child: const Icon(Icons.search),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'stopScan',
            onPressed: stopScan,
            tooltip: 'Stop Scan',
            child: const Icon(Icons.stop),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'Add',
            onPressed: (){
              connectDevice('1');
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'login',
            onPressed: (){
              loginUser('1');
            },
            tooltip: 'login',
            child: const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}

class DataTile extends StatelessWidget {
  final String label;
  final String value;

  const DataTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
