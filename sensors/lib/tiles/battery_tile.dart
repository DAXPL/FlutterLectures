import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'battery_detail_screen.dart';
import 'dart:async';
import '../constants.dart';

class BatteryTile extends StatefulWidget {
  const BatteryTile({super.key});

  @override
  State<BatteryTile> createState() => _BatteryTileState();
}

class _BatteryTileState extends State<BatteryTile> {
  final Battery _battery = Battery();

  int batteryLevel = 0;
  BatteryState? batteryState;

  StreamSubscription<BatteryState>? _batteryStateSub;

  @override
  void initState() {
    super.initState();
    _loadBattery();

    _batteryStateSub = _battery.onBatteryStateChanged.listen((state) {
      setState(() {
        batteryState = state;
      });
    });
  }
  
  @override
  void dispose() {
    _batteryStateSub?.cancel();
    super.dispose();
  }

  Future<void> _loadBattery() async {
    final level = await _battery.batteryLevel;
    final state = await _battery.batteryState;

    setState(() {
      batteryLevel = level;
      batteryState = state;
    });
  }

  String getBatteryStatusText() {
    switch (batteryState) {
      case BatteryState.charging:
        return "Ładowanie";
      case BatteryState.discharging:
        return "Rozładowanie";
      case BatteryState.full:
        return "Naładowana";
      default:
        return "Brak danych";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,  
          MaterialPageRoute(
            builder: (_) => const BatteryDetailScreen(),
          ),
        );
      },
    
    child: Card(
  color: kAccentColor,
  child: Padding(
    padding: const EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bateria", style: headerTextStyle), 
        const SizedBox(height: 4),
        Text("$batteryLevel%", style: headerTextStyle), 
        Text(getBatteryStatusText(), style: headerTextStyle),
      ],
    ),
  ),
),
    );
  }
}