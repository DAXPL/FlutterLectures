import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(
        onStart: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DashboardScreen()),
          );
        },
      ),
    ),
  );
}
