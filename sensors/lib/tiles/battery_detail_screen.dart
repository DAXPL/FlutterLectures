import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../constants.dart';

class BatteryDetailScreen extends StatefulWidget {
  const BatteryDetailScreen({super.key});

  @override
  State<BatteryDetailScreen> createState() =>
      _BatteryDetailScreenState();
}

class _BatteryDetailScreenState extends State<BatteryDetailScreen> {
  final Battery _battery = Battery();
  int batteryLevel = 0;
  BatteryState? batteryState;
  List<String> history = [];
  StreamSubscription<BatteryState>? _batteryStateSub;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadBattery();

    _batteryStateSub = _battery.onBatteryStateChanged.listen((state) {
      batteryState = state;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      batteryLevel = await _battery.batteryLevel;

      if (!mounted) return;

      setState(() {
        history.add(
          "$batteryLevel% — ${_getBatteryStatusText()}",
        );

        if (history.length > 15) {
          history.removeAt(0);
        }
      });
    });
  }
  
  Future<void> _loadBattery() async {
      batteryLevel = await _battery.batteryLevel;
      batteryState = await _battery.batteryState;
      setState(() {});
    }
  
  String _getBatteryStatusText() {
    switch (batteryState) {
      case BatteryState.charging:
        return "Ładowanie";
      case BatteryState.discharging:
        return "Rozładowywanie";
      case BatteryState.full:
        return "Naładowana";
      default:
        return "Brak danych";
    }
  }
  
  IconData _getBatteryIcon() {
    if (batteryState == BatteryState.charging) return Icons.battery_charging_full;
    if (batteryLevel > 80) return Icons.battery_full;
    if (batteryLevel > 60) return Icons.battery_6_bar;
    if (batteryLevel > 40) return Icons.battery_4_bar;
    if (batteryLevel > 20) return Icons.battery_2_bar;
    return Icons.battery_alert;
  }

  @override
  void dispose() {
    _batteryStateSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latest = history.isNotEmpty ? history.first : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Bateria – szczegóły'),backgroundColor: kBackgroundColor,foregroundColor: kAccentColor,),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: latest == null
                ? const Text('Oczekiwanie na pierwszy odczyt...')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktualny poziom: $batteryLevel%',
                        style: baseTextStyle
                      ),
                      Text('Stan: ${_getBatteryStatusText()}',style: baseTextStyle),
                      const SizedBox(height: 8),
                    ],
                  ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Historia:',
                style: baseTextStyle,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: Icon(_getBatteryIcon(), color: kAccentColor,),
                  title: Text(
                    history[index],
                    style: baseTextStyle,
                  ),
                  textColor: kAccentColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
