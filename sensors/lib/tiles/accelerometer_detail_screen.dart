import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../constants.dart';
import '../charts/chart_screen.dart';
import 'dart:math';

class AccelerometerDetailScreen extends StatefulWidget {
  const AccelerometerDetailScreen({super.key});

  @override
  State<AccelerometerDetailScreen> createState() =>
      _AccelerometerDetailScreenState();
}

class _AccelerometerDetailScreenState extends State<AccelerometerDetailScreen> {
  final List<Vector3Readings> _log = [];

  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime? _lastAdded;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (_lastAdded == null ||
          now.difference(_lastAdded!).inMilliseconds >= aquireTime) {
        _lastAdded = now;
        setState(() {
          _log.insert( 0,
            Vector3Readings(
              time: now,
              x: event.x,
              y: event.y,
              z: event.z,
            ),
          );
          if (_log.length > maximumSensorsReadings) {
            _log.removeLast();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latest = _log.isNotEmpty ? _log.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Akcelerometr – szczegóły'),backgroundColor: kBackgroundColor,foregroundColor: kAccentColor,),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: latest == null
                ? const Text('Oczekiwanie na pierwszy odczyt...')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aktualny odczyt:',
                        style: baseTextStyle
                      ),

                      const SizedBox(height: 8),
                      Text('x: ${latest.x.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('y: ${latest.y.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('z: ${latest.z.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                    ],
                  ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                await exportToFile("accel.txt", "ACCEL LOG", _log, context); 
              },
              child: const Text(
                "EKSPORTUJ DANE DO PLIKU",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () async {
                final List<double> magnitudes = _log.reversed.map((reading) {
                  return sqrt(pow(reading.x, 2) + pow(reading.y, 2) + pow(reading.z, 2));
                }).toList();
                Navigator.push(
                  context,  
                  MaterialPageRoute(
                    builder: (_) => ChartScreen(
                      readings: magnitudes,
                      title: "Accelerometer snapshot",),
                  ),
                );
              },
              child: const Text(
                "WYKRES SNAPSHOT",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historia:',
                style: baseTextStyle,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: min(_log.length, 10),
              itemBuilder: (context, index) {
                final sample = _log[index];
                final time = sample.time;
                final timeStr =
                    '${time.hour.toString().padLeft(2, '0')}:'
                    '${time.minute.toString().padLeft(2, '0')}:'
                    '${time.second.toString().padLeft(2, '0')}';

                return ListTile(
                  dense: true,
                  title: Text(
                    'x: ${sample.x.toStringAsFixed(2)}, '
                    'y: ${sample.y.toStringAsFixed(2)}, '
                    'z: ${sample.z.toStringAsFixed(2)}',
                    style: baseTextStyle,
                  ),
                  subtitle: Text('Czas: $timeStr'),
                  textColor: kAccentColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
