import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'magnetometer_detail_screen.dart';
import '../constants.dart'; 
import 'dart:math';

class MagnetometerTile extends StatelessWidget {
  const MagnetometerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MagnetometerEvent>(
      stream: magnetometerEventStream(),
      initialData: MagnetometerEvent(0, 0, 0),
      builder: (context, snapshot) {
        final e = snapshot.data!;
        final strength = sqrt(e.x*e.x + e.y*e.y + e.z*e.z); 
        final maxVal = strength/3000;
      return InkWell(
      onTap: () {
        Navigator.push(
          context,  
          MaterialPageRoute(
            builder: (_) => const MagnetometerDetailScreen(),
          ),
        );
      },
    
    child: Card(
          color: Color.lerp(AcceptColor, DeclineColor, maxVal), 
          elevation: 4, 
          
          child: Padding(
            padding: const EdgeInsets.all(15),
            
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Magnetometer\n(µT)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BackgroundColor,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  'X: ${e.x.toStringAsFixed(2)}\n'
                  'Y: ${e.y.toStringAsFixed(2)}\n'
                  'Z: ${e.z.toStringAsFixed(2)}\n'
                  'Siła: ${strength.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
      },
    );
  }
}