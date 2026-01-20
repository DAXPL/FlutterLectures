import 'package:flutter/material.dart';
import 'chart.dart';
import '../constants.dart';
import 'dart:async';

class ChartSteps extends StatefulWidget{
  final List<List<double> Function()> readingFunctions;
  final String title;
  const ChartSteps({
    required this.readingFunctions,
    required this.title,
    super.key,
  });

  @override
  State<ChartSteps> createState() => _ChartStepsScreen();
}

class _ChartStepsScreen extends State<ChartSteps>{
  int steps = 0;
  double treshold = 1.2;
  bool wasUnder= false;
  int stepTimestamp = 0;
  int stepDelayMilis = 250;

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

  void calculateSteps() {
  final data = widget.readingFunctions[0]();
  int len = data.length;
  if (len <= 10) return;
  double sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += data[len - 1 - i]; 
  }
  double curG = sum / 10;
  int millis = DateTime.now().millisecondsSinceEpoch;
  bool isAbove = curG >= treshold;
  bool isTime = millis > (stepTimestamp + stepDelayMilis);

  if (wasUnder && isAbove && isTime) {
    steps++;
    stepTimestamp = millis;
  }
  wasUnder = curG < treshold;
}

  @override
  Widget build(BuildContext context) {
    calculateSteps();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kBackgroundColor,
        foregroundColor: kAccentColor,
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
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
                  title: "a_dyn",
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Text( "Steps",style: headerTextStyle,),
                Text("$steps", style: headerTextStyle ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}