import 'package:flutter/material.dart';

/// ThemeProvider manages the application's global theme state.
/// This is an example of App State because it affects the entire app.
class ThemeProvider extends ChangeNotifier {

  // Stores the current theme status.
  bool _isDark = false;


  /// Returns true if dark mode is enabled.
  bool get isDark => _isDark;


  /// Switches between light mode and dark mode.
  void toggleTheme() {

    _isDark = !_isDark;

    // Updates all widgets listening to this provider.
    notifyListeners();
  }
}

