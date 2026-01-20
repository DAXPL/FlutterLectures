import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors/charts/chart_shake.dart';
import 'package:sensors/tiles/navButton.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../constants.dart';
import 'dart:math';

class ThrowDetailScreen extends StatefulWidget {
  const ThrowDetailScreen({super.key});

  @override
  State<ThrowDetailScreen> createState() =>
      _AccelerometerDetailScreenState();
}

class _AccelerometerDetailScreenState extends State<ThrowDetailScreen> {
  final List<Vector3Readings> _logAcc = [];
  final List<Vector3Readings> _logGyro = [];
  final List<Vector3MultiReadings> _log = [];

  StreamSubscription<AccelerometerEvent>? _subAcc;
  StreamSubscription<GyroscopeEvent>? _subGyro;
  DateTime? _lastAdded;

  @override
  void initState() {
    super.initState();
    _subAcc = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      if (_lastAdded == null ||
          now.difference(_lastAdded!).inMilliseconds >= aquireTime) {
        _lastAdded = now;
        setState(() {
          _logAcc.insert( 0,
            Vector3Readings(
              time: now,
              x: event.x,
              y: event.y,
              z: event.z,
            ),
          );
          if (_logAcc.length > maximumSensorsReadings) {
            _logAcc.removeLast();
          }
          tryAddToLog();
        });
      }
    });
    _subGyro = gyroscopeEventStream().listen((event) {
      final now = DateTime.now();
      if (_lastAdded == null ||
          now.difference(_lastAdded!).inMilliseconds >= aquireTime) {
        _lastAdded = now;
        setState(() {
          _logGyro.insert(0, Vector3Readings(
              time: now,
              x: event.x,
              y: event.y,
              z: event.z,
            ),);
          if (_logGyro.length > maximumSensorsReadings) {
            _logGyro.removeLast();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _subAcc?.cancel();
    _subGyro?.cancel();
    super.dispose();
  }

  @override
  void tryAddToLog() {
    var latestAcc = _logAcc.isNotEmpty ? _logAcc.first : null;
    var latestGyro = _logGyro.isNotEmpty ? _logGyro.first : null;
    var now = DateTime.now();
    
    if(latestAcc == null || latestGyro == null) return;
    final List<Vector3Readings> buff = [];
    buff.add(latestAcc);
    buff.add(latestGyro);
    _log.insert(0, Vector3MultiReadings(time: now, readings: buff));

    if (_log.length > maximumSensorsReadings) {
            _log.removeLast();
          }
  }

List<double> getAccMagnitudes() {
  return _log.reversed.map((multi) {
    final acc = multi.readings[0];
    return sqrt(pow(acc.x, 2) + pow(acc.y, 2) + pow(acc.z, 2));
  }).toList();
}

List<double> getGyroMagnitudes() {
  return _log.reversed.map((multi) {
    final gyro = multi.readings[1];
    return sqrt(pow(gyro.x, 2) + pow(gyro.y, 2) + pow(gyro.z, 2));
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    final latestAcc = _logAcc.isNotEmpty ? _logAcc.first : null;
    final latestGyro = _logGyro.isNotEmpty ? _logGyro.first : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Rzut - szczegóły'),backgroundColor: kBackgroundColor,foregroundColor: kAccentColor,),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: (latestAcc == null || latestGyro == null)
                ? const Text('Oczekiwanie na pierwszy odczyt...')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aktualny odczyt:',
                        style: baseTextStyle
                      ),

                      const SizedBox(height: 8),
                      Text('ACC',style: baseTextStyle),
                      Text('x: ${latestAcc.x.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('y: ${latestAcc.y.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('z: ${latestAcc.z.toStringAsFixed(2)} m/s²',style: baseTextStyle),
                      Text('GYRO',style: baseTextStyle),
                      Text('x: ${latestGyro.x.toStringAsFixed(2)} rad/s²',style: baseTextStyle),
                      Text('y: ${latestGyro.y.toStringAsFixed(2)} rad/s²',style: baseTextStyle),
                      Text('z: ${latestGyro.z.toStringAsFixed(2)} rad/s²',style: baseTextStyle),
                    ],
                  ),
          ),
          const Divider(),
          NavButton(label: "EKSPORTUJ DANE DO PLIKU", action: () async {
                await exportMultireadToFile("throw.txt", "THROW LOG", _log, context);  
              }),
          NavButton(label: "WYKRES LIVE", action: () async {
                Navigator.push(
                  context,  
                  MaterialPageRoute(
                    builder: (_) => ChartShake(
                      readingFunctions: [
                        getAccMagnitudes,
                        getGyroMagnitudes
                      ],
                      title: "Shake charts",),
                  ),
                );
              })
        ],
      ),
    );
  }
}
