import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'throw_tile_detail_screen.dart';
import '../constants.dart';

class ThrowTile extends StatelessWidget {
  const ThrowTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ThrowDetailScreen()),
        );
      },

      child: Card(
        color: kAccentColor,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              StreamBuilder<AccelerometerEvent>(
                stream: accelerometerEventStream(),
                initialData: AccelerometerEvent(0, 0, 0),
                builder: (context, snapshot) {
                  final e = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'X: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)} [m/s]',
                        style: headerTextStyle,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              StreamBuilder<GyroscopeEvent>(
                stream: gyroscopeEventStream(),
                initialData: GyroscopeEvent(0, 0, 0),
                builder: (context, snapshot) {
                  final e = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'X: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)} (rad/s)',
                        style: headerTextStyle,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
