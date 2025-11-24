import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../constants.dart';

class AccelerometerDetailScreen extends StatefulWidget {
  const AccelerometerDetailScreen({super.key});

  @override
  State<AccelerometerDetailScreen> createState() =>
      _AccelerometerDetailScreenState();
}

class _AccelerometerDetailScreenState extends State<AccelerometerDetailScreen> {
  final List<Map<String, dynamic>> _log = [];

  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime? _lastAdded;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (_lastAdded == null ||
          now.difference(_lastAdded!).inMilliseconds >= 500) {
        _lastAdded = now;
        setState(() {
          _log.insert(0, {
            'time': now,
            'x': event.x,
            'y': event.y,
            'z': event.z,
          });
          if (_log.length > 50) {
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
                      Text('x: ${latest['x'].toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('y: ${latest['y'].toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('z: ${latest['z'].toStringAsFixed(2)} m/s²',style: baseTextStyle),
                    ],
                  ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historia (co ~0.5 s):',
                style: baseTextStyle,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, index) {
                final sample = _log[index];
                final time = sample['time'] as DateTime;
                final timeStr =
                    '${time.hour.toString().padLeft(2, '0')}:'
                    '${time.minute.toString().padLeft(2, '0')}:'
                    '${time.second.toString().padLeft(2, '0')}';

                return ListTile(
                  dense: true,
                  title: Text(
                    'x: ${sample['x'].toStringAsFixed(2)}, '
                    'y: ${sample['y'].toStringAsFixed(2)}, '
                    'z: ${sample['z'].toStringAsFixed(2)}',
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
