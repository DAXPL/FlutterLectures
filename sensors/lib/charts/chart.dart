import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class Chart extends StatelessWidget {
  final List<double> readings;
  final String title;
  const Chart({required this.readings, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kAccentColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBackgroundColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          Text(title, style: headerTextStyle),
          SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: Sparkline(
              data: readings,
              lineWidth: 3.0,
              lineGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.cyan],
              ),
              fillMode: FillMode.below,
              fillGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.blue],
              ),
              useCubicSmoothing: true,
              cubicSmoothingFactor: 0.2,
              pointsMode: PointsMode.all,
              pointSize: 5.0,
              pointColor: kAcceptColor,
            ),
          ),
        ],
      ),
    );
  }
}
