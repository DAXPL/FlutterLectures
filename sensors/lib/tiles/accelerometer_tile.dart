import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../constants.dart';

class AccelerometerTile extends StatelessWidget {
  const AccelerometerTile({super.key});

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
                  'Accelerometr\n(m/s)',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: BackgroundColor),
                ),
                SizedBox(height: 12,),
                Text(
                  'X: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)}',
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
