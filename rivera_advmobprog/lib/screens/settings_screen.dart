import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/theme_provider.dart';

// SettingsScreen allows the user to change
// the application's theme.
class SettingsScreen extends StatelessWidget {
  // Constructor for SettingsScreen.
  const SettingsScreen({super.key});

  // Builds the user interface of the Settings Screen.
  @override
  Widget build(BuildContext context) {
    // Gets the ThemeProvider to access the shared app state.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme Settings"),
      ),

      body: Center(
        child: SwitchListTile(
          // Label for the theme switch.
          title: const Text("Dark Mode"),

          // Gets the current theme value from ThemeProvider.
          value: themeProvider.isDark,

          // Changes the theme when the switch is toggled.
          onChanged: (_) {
            themeProvider.toggleTheme();
          },
        ),
      ),
    );
  }
}