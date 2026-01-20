import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
const Color kBackgroundColor = Color.fromARGB(255, 75, 75, 75);
const Color kAccentColor = Colors.white;
const Color kAcceptColor = Colors.green;
const Color kDeclineColor = Colors.red;
const baseTextStyle = TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kAccentColor
                        );
const headerTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: kBackgroundColor);
const int aquireTime = 50;//maks 20
const int maximumSensorsReadings = 10000;

class Vector3Readings {
  final DateTime time;
  final double x;
  final double y;
  final double z;
  Vector3Readings({required this.time, required this.x, required this.y, required this.z});
}

class Vector3MultiReadings {
  final DateTime time;
  final List<Vector3Readings> readings;
  Vector3MultiReadings({required this.time, required this.readings});
}

Future<void> exportToFile(String filename,String logName, List<Vector3Readings> _log, BuildContext context) async{
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      final buffer = StringBuffer();
    buffer.writeln('=== $logName ===');
    for(final sample in _log){
      final t = sample.time.toIso8601String();
      buffer.writeln('$t; ${sample.x.toStringAsFixed(3)}; ${sample.y.toStringAsFixed(3)}; ${sample.z.toStringAsFixed(3)}');
    }
    await file.writeAsString(buffer.toString());

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wyeksportowano do:\n${file.path}'),
          duration: const Duration(seconds: 10),
        ),
      );
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd zapisu: ${e.toString()}'),
              duration: const Duration(seconds: 10),
            ),
        );
    }
      
  }

Future<void> exportMultireadToFile(String filename,String logName, List<Vector3MultiReadings> _log, BuildContext context) async{
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');
      final buffer = StringBuffer();
    buffer.writeln('=== $logName ===');
    for(final reading in _log)
    {
      final t = reading.time.toIso8601String();
      buffer.write('$t');
      for(final s in reading.readings)
      {
        buffer.write('; ');
        buffer.write('${s.x.toStringAsFixed(3)}; ${s.y.toStringAsFixed(3)}; ${s.z.toStringAsFixed(3)}');
      }
      buffer.writeln('');
    }
    await file.writeAsString(buffer.toString());

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wyeksportowano do:\n${file.path}'),
          duration: const Duration(seconds: 10),
        ),
      );
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd zapisu: ${e.toString()}'),
              duration: const Duration(seconds: 10),
            ),
        );
    }
      
  }