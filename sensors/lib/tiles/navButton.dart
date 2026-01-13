import 'package:flutter/material.dart';
import '../constants.dart';

class NavButton extends StatelessWidget {
  final String label;
  final Future<void> Function() action;
  const NavButton({
    required this.label,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
     ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      textStyle: const TextStyle(fontSize: 16),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child:OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.white, width: 2), // Używamy Twoich kolorów
                foregroundColor: Colors.white,
              ),
              onPressed: () async => await action(),
              child: Text(
                label,
                style: TextStyle(fontSize: 16),
              ),
            )
    );
  }
}