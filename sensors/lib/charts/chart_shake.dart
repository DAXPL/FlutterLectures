import 'package:flutter/material.dart';
import 'chart.dart';
import '../constants.dart';
import 'dart:async';

class ChartShake extends StatefulWidget {
  final List<List<double> Function()> readingFunctions;
  final String title;
  const ChartShake({
    required this.readingFunctions,
    required this.title,
    super.key,
  });

  @override
  State<ChartShake> createState() => _ChartShakeScreen();
}

class _ChartShakeScreen extends State<ChartShake> {
  int gyroShakeCount = 0;
  int linearShakeCount = 0;
  double gTreshold = 1.2;
  double wTreshold = 5.0;

  bool wasUnderG = false;
  bool wasUnderW = false;
  int shakeWTimestamp = 0;
  int shakeGTimestamp = 0;

  int shakeDelayMilis = 750;

  bool inFreeFall = false;
  int tStartTimestamp = 0;
  double latstHeight = 0;
  double gStartTreshold = 0.3;
  double gEndTreshold = 0.7;
  int minDt = 1500; //ms
  double g = 9.81;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: aquireTime), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void calculateShakes() {
    double curG = widget.readingFunctions[0]().last / 9.81;
    double curW = widget.readingFunctions[1]().last;
    int millis = DateTime.now().millisecondsSinceEpoch;

    if ((wasUnderW && curW >= wTreshold) &&
        millis > (shakeWTimestamp + shakeDelayMilis)) {
      gyroShakeCount++;
      shakeWTimestamp = millis;
    }

    if ((wasUnderG && curG >= gTreshold) &&
        millis > (shakeGTimestamp + shakeDelayMilis)) {
      linearShakeCount++;
      shakeGTimestamp = millis;
    }

    wasUnderG = curG < gTreshold;
    wasUnderW = curW < wTreshold;
  }

  void calculateFreeFall() {
    int millis = DateTime.now().millisecondsSinceEpoch;
    double curG = widget.readingFunctions[0]().last / 9.81;

    if (!inFreeFall && curG < gStartTreshold) {
      inFreeFall = true;
      tStartTimestamp = millis;
    }

    if (inFreeFall && curG > gEndTreshold) {
      inFreeFall = false;
      int fallTimeMs = millis - tStartTimestamp;

      if (fallTimeMs >= minDt) {
        double tSec = fallTimeMs / 1000.0;
        latstHeight = 0.5 * 9.81 * (tSec * tSec);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateShakes();
    calculateFreeFall();

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
            flex: 2,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: widget.readingFunctions.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: Colors.grey),
              itemBuilder: (context, index) {
                return Chart(
                  readings: widget.readingFunctions[index](),
                  title: index == 0 ? 'Acc (g)' : 'Gyro (rad/s)',
                );
              },
            ),
          ),

          Container(
            color: kBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildSliderRow(
                  label: "Czułość startu (g)",
                  value: gStartTreshold,
                  min: 0.05,
                  max: 0.5,
                  onChanged: (v) => setState(() => gStartTreshold = v),
                ),
                _buildSliderRow(
                  label: "Min. czas (ms)",
                  value: minDt.toDouble(),
                  min: 100,
                  max: 2000,
                  onChanged: (v) => setState(() => minDt = v.toInt()),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 20,
            ), // Podnosi cały kontener o 20px nad dół ekranu
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Shakes", style: headerTextStyle),
                      Text("$gyroShakeCount", style: headerTextStyle),
                      Text("High - g", style: headerTextStyle),
                      Text("$linearShakeCount", style: headerTextStyle),
                      Text("Ostatni upadek", style: headerTextStyle),
                      Text("${latstHeight.toStringAsFixed(2)}", style: headerTextStyle),
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        Expanded(
          flex: 5,
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: kAccentColor,
            onChanged: onChanged,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            color: kAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
