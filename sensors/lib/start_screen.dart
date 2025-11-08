import 'package:flutter/material.dart';
import 'constants.dart';

class StartScreen extends StatelessWidget {
  final Function(BuildContext) onStart;
  const StartScreen({super.key, required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cabin,
              size: 70,
              color: AccentColor,
            ),
            const SizedBox(height: 30),
            Text(
              'IoT Sensors Dashboard',
              style: TextStyle(
fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AccentColor,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
            width: 300,  // Narzuca stałą szerokość
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                print("Klik");
                onStart(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AccentColor,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
