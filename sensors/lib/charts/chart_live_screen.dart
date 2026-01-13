import 'package:flutter/material.dart';
import 'chart.dart';
import '../constants.dart';
import 'dart:async';
class ChartLiveScreen extends StatefulWidget{
  final List<double> Function() getReadings;
  final String title;

  const ChartLiveScreen({
    required this.getReadings,
    required this.title,
    super.key,
  });

  @override
  State<ChartLiveScreen> createState() => _ChartLiveScreen();
}

class _ChartLiveScreen extends State<ChartLiveScreen>{
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: aquireTime), (timer){if (mounted) setState(() {});});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chart(readings: widget.getReadings(), title: widget.title);
  }
}