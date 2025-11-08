import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../constants.dart';

class BatteryTile extends StatelessWidget{
  const BatteryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AccentColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<AccelerometerEvent>(
          stream: accelerometerEventStream(),
          initialData: AccelerometerEvent(0, 0, 0),
          builder: (context, snapshot) {
            final e = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Battery(%)',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: BackgroundColor),
                ),
                SizedBox(height: 12,),
                Text(
                  'X: ${e.x.toStringAsFixed(2)}\n}',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: BackgroundColor),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}