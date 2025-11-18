import 'package:flutter/material.dart';
import 'constants.dart';

import 'tiles/accelerometer_tile.dart';
import 'tiles/userAccelerometer_tile.dart';
import 'tiles/battery_tile.dart';
import 'tiles/magnetometer_tile.dart';
import 'tiles/gyroscope_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensors Dashboard'),
      backgroundColor: BackgroundColor,
      foregroundColor: AccentColor,),

      backgroundColor: BackgroundColor,
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: EdgeInsets.all(15),
        children: [
          AccelerometerTile(),
          UserAccelerometerTile(),
          MagnetometerTile(),
          GyroscopeTile(),
          Card(color: AccentColor)
        ],
      ),
    );
  }
}
