import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/theme_provider.dart';
import 'screens/counter_screen.dart';

// Main function that starts the Flutter application.
void main() {
  runApp(
    // Provides ThemeProvider to the entire application.
    // This allows different screens to access the same theme state.
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

// MyApp is the root widget of the application.
// It contains the main app configuration and themes.
class MyApp extends StatelessWidget {
  // Constructor for MyApp.
  const MyApp({super.key});

  // Builds the main application interface.
  @override
  Widget build(BuildContext context) {
    // Gets the shared theme state from ThemeProvider.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ephemeral vs App State",

      // Light theme configuration.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      // Dark theme configuration.
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),

      // Uses the theme selected by the user.
      // Provider manages the app-wide theme state.
      themeMode:
          themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      // Opens the Counter Screen when the app starts.
      home: const CounterScreen(),
    );
  }
}