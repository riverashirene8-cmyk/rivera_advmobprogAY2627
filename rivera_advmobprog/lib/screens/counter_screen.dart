import 'package:flutter/material.dart';

import 'settings_screen.dart';

// CounterScreen displays the counter and allows the user
// to increase or reset the counter.
class CounterScreen extends StatefulWidget {
  // Constructor for CounterScreen.
  const CounterScreen({super.key});

  // Creates the state of the CounterScreen.
  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

// Contains the local/ephemeral state of the counter screen.
class _CounterScreenState extends State<CounterScreen> {
  // Stores the current counter value.
  // This is an example of ephemeral/local state.
  int counter = 0;

  // Increases the counter by 1.
  // setState() updates the UI when the value changes.
  void increaseCounter() {
    setState(() {
      counter++;
    });

    // Shows a message after increasing the counter.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Counter increased to $counter"),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  // Resets the counter value back to 0.
  void resetCounter() {
    setState(() {
      counter = 0;
    });

    // Shows a message after resetting the counter.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Counter has been reset."),
        duration: Duration(milliseconds: 700),
      ),
    );
  }

  // Determines the color of the counter
  // depending on its current value.
  Color getCounterColor() {
    if (counter >= 20) {
      return Colors.red;
    } else if (counter >= 10) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  // Builds the user interface of the counter screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Counter ($counter)",
        ),

        actions: [
          // Opens the Settings Screen.
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

            // Displays the current counter value.
            Text(
              "$counter",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: getCounterColor(),
              ),
            ),

            const SizedBox(height: 20),

            // Displays a message depending on the counter value.
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

      // Contains the buttons for increasing and resetting the counter.
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Increases the counter.
          FloatingActionButton(
            heroTag: "add",
            onPressed: increaseCounter,
            child: const Icon(Icons.add),
          ),

          const SizedBox(height: 12),

          // Resets the counter.
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