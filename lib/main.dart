import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  DigitalPetAppState createState() => DigitalPetAppState();
}

class DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController nameController = TextEditingController();
  Timer? hungerTimer;
  Timer? winTimer;
  bool isGameOver = false;
  bool hasWon = false;

  @override
  void initState() {
    super.initState();
    hungerTimer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      if (!isGameOver && !hasWon) {
        _increaseHungerOverTime();
      }
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      _checkWinCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      if (hungerLevel < 30) {
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
      } else {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
      }
      _checkWinCondition();
    });
  }

  String _getMood() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  void _increaseHungerOverTime() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      if (hungerLevel >= 100) {
        hungerLevel = 100;
        happinessLevel = (happinessLevel - 10).clamp(0, 100);
      }
      _checkLossCondition();
    });
  }

  void _checkWinCondition() {
    if (happinessLevel > 80) {
      winTimer?.cancel();
      winTimer = Timer(const Duration(minutes: 3), () {
        if (happinessLevel > 80) {
          setState(() {
            hasWon = true;
          });
        }
      });
    } else {
      winTimer?.cancel(); // Reset win timer if happiness drops below 80
    }
  }

  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel < 10) {
      setState(() {
        isGameOver = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Center(
        child: isGameOver
            ? const Text('Game Over 😢', style: TextStyle(fontSize: 30))
            : hasWon
                ? const Text('You Win! 🎉', style: TextStyle(fontSize: 30))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (petName == "Your Pet") ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(labelText: "Enter pet's name"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              petName = nameController.text;
                            });
                          },
                          child: const Text('Set Pet Name'),
                        ),
                      ],
                      if (petName != "Your Pet") ...[
                        Text('Name: $petName', style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 10),
                        Text('Mood: ${_getMood()}', style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 10),
                        Text('Happiness Level: $happinessLevel', style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 10),
                        Text('Hunger Level: $hungerLevel', style: const TextStyle(fontSize: 20.0)),
                        const SizedBox(height: 30),
                        Container(
                          width: 100,
                          height: 100,
                          color: _getPetColor(),
                          child: const Center(child: Text('🐶')),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _playWithPet,
                          child: const Text('Play with Pet'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _feedPet,
                          child: const Text('Feed Pet'),
                        ),
                      ],
                    ],
                  ),
      ),
    );
  }
}
