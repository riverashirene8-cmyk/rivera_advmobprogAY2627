import 'package:flutter/material.dart';

// ThemeProvider manages the app-wide theme state.
// It allows the app to switch between light and dark mode.
class ThemeProvider extends ChangeNotifier {
  // Stores the current theme state.
  bool _isDark = false;

  // Returns the current dark mode value.
  bool get isDark => _isDark;

  // Toggles between light mode and dark mode.
  // notifyListeners() updates the widgets using this provider.
  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}