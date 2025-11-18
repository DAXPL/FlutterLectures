import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'gyroscope_detail_screen.dart';
import '../constants.dart';

class GyroscopeTile extends StatelessWidget {
  const GyroscopeTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,  
          MaterialPageRoute(
            builder: (_) => const GyroscopeDetailScreen(),
          ),
        );
      },
    
    child: Card(
      color: AccentColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<GyroscopeEvent>(
          stream: gyroscopeEventStream(),
          initialData: GyroscopeEvent(0, 0, 0),
          builder: (context, snapshot) {
            final e = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'User Gyroscope\n(rad/s))',
                    style: headerTextStyle,
                ),
                SizedBox(height: 12,),
                Text(
                  'X: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)}',
                    style: headerTextStyle,
                ),
              ],
            );
          },
        ),
      ),
    ),
    );
  }
}
