import 'package:flutter/material.dart';
import '../constants.dart';
import 'chart.dart';

class ChartScreen extends StatelessWidget {
  final List<double> readings;
  final String title;

  const ChartScreen({
    required this.readings,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kBackgroundColor,
        foregroundColor: kAccentColor,
      ),
      backgroundColor: kBackgroundColor,
      body:Chart(readings: readings, title: title)
      );
  }
}