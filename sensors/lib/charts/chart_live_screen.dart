import 'package:flutter/material.dart';
import 'chart.dart';
import '../constants.dart';
import 'dart:async';
class ChartLiveScreen extends StatefulWidget{
  final List<List<double> Function()> readingFunctions;
  final String title;

  const ChartLiveScreen({
    required this.readingFunctions,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kBackgroundColor,
        foregroundColor: kAccentColor,
      ),
      backgroundColor: kBackgroundColor,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: widget.readingFunctions.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          indent: 20,
          endIndent: 20,
        ),
        itemBuilder: (context, index) {
          return Chart(
            readings: widget.readingFunctions[index](),
            title: "${widget.title} #${index + 1}", 
          );
        },
      ),
    );
  }
}