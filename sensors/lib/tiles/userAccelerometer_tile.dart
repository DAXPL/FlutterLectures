import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'userAccelerometer_detail_screen.dart';
import '../constants.dart';

class UserAccelerometerTile extends StatelessWidget {
  const UserAccelerometerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,  
          MaterialPageRoute(
            builder: (_) => const UserAccelerometerDetailScreen(),
          ),
        );
      },
    
    child: Card(
      color: kAccentColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<UserAccelerometerEvent>(
          stream: userAccelerometerEventStream(),
          initialData: UserAccelerometerEvent(0, 0, 0),
          builder: (context, snapshot) {
            final e = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'User Accelerometr\n(m/s)',
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
