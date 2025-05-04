import 'package:flutter/material.dart';
import 'tire_data.dart'; // tire_data.dart dosyasını import et

void main() {
  runApp(AutoStrategistApp());
}

class AutoStrategistApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGP Auto Strategist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AutoStrategistPage(), // Anasayfa için AutoStrategistPage
    );
  }
}

class AutoStrategistPage extends StatefulWidget {
  @override
  _AutoStrategistPageState createState() => _AutoStrategistPageState();
}

class _AutoStrategistPageState extends State<AutoStrategistPage> {
  final TextEditingController _raceLengthController = TextEditingController();
  final TextEditingController _pitLossController = TextEditingController();

  final List<TireData> _tires = [
    TireData(type: "Soft", lapTime: 0, durability: 0),
    TireData(type: "Medium", lapTime: 0, durability: 0),
    TireData(type: "Hard", lapTime: 0, durability: 0),
    TireData(type: "SuperSoft", lapTime: 0, durability: 0),
  ];

  void _calculateStrategy() {
    final double raceLength = double.tryParse(_raceLengthController.text) ?? 0;
    final double pitLoss = double.tryParse(_pitLossController.text) ?? 0;

    final List<TireData> tireData = [
      TireData(
        type: "Soft",
        lapTime: double.tryParse(_tires[0].lapTime.toString()) ?? 0,
        durability: int.tryParse(_tires[0].durability.toString()) ?? 0,
      ),
      TireData(
        type: "Medium",
        lapTime: double.tryParse(_tires[1].lapTime.toString()) ?? 0,
        durability: int.tryParse(_tires[1].durability.toString()) ?? 0,
      ),
      TireData(
        type: "Hard",
        lapTime: double.tryParse(_tires[2].lapTime.toString()) ?? 0,
        durability: int.tryParse(_tires[2].durability.toString()) ?? 0,
      ),
      TireData(
        type: "SuperSoft",
        lapTime: double.tryParse(_tires[3].lapTime.toString()) ?? 0,
        durability: int.tryParse(_tires[3].durability.toString()) ?? 0,
      ),
    ];

    double bestTime = double.infinity;
    String bestTireType = "";
    for (var tire in tireData) {
      int pitStops = (raceLength / tire.durability).ceil();
      double totalTime = pitStops * pitLoss + raceLength * tire.lapTime;

      if (totalTime < bestTime) {
        bestTime = totalTime;
        bestTireType = tire.type;
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Optimal Strategy"),
            content: Text(
              "Best Tire: $bestTireType\nTotal Time: ${bestTime.toStringAsFixed(2)} sec",
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("iGP Auto Strategist")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _raceLengthController,
              decoration: InputDecoration(labelText: "Race Length (km)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pitLossController,
              decoration: InputDecoration(
                labelText: "Pit Stop Time Loss (sec)",
              ),
              keyboardType: TextInputType.number,
            ),
            // Soft tire lapTime and durability input
            TextField(
              decoration: InputDecoration(
                labelText: "Soft Tire Lap Time (sec)",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _tires[0] = TireData(
                  type: "Soft",
                  lapTime: double.tryParse(value) ?? 0,
                  durability: _tires[0].durability,
                );
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Soft Tire Durability (laps)",
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _tires[0] = TireData(
                  type: "Soft",
                  lapTime: _tires[0].lapTime,
                  durability: int.tryParse(value) ?? 0,
                );
              },
            ),
            // Repeat for other tires (Medium, Hard, SuperSoft)
            ElevatedButton(
              onPressed: _calculateStrategy,
              child: Text("Calculate Strategy"),
            ),
          ],
        ),
      ),
    );
  }
}
