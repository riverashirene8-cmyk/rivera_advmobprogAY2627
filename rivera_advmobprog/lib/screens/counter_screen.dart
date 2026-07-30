import 'package:flutter/material.dart';

import 'settings_screen.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int counter = 0;

  void increaseCounter() {
    setState(() {
      counter++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Counter increased to $counter"),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Counter has been reset."),
        duration: Duration(milliseconds: 700),
      ),
    );
  }

  Color getCounterColor() {
    if (counter >= 20) {
      return Colors.red;
    } else if (counter >= 10) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counter ($counter)",
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Counter Value",
              style: TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "$counter",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: getCounterColor(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              counter >= 20
                  ? "Excellent!"
                  : counter >= 10
                      ? "Great!"
                      : "Keep Going!",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            onPressed: increaseCounter,
            child: const Icon(Icons.add),
          ),

          const SizedBox(height: 12),

          FloatingActionButton(
            heroTag: "reset",
            backgroundColor: Colors.red,
            onPressed: counter == 0 ? null : resetCounter,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}