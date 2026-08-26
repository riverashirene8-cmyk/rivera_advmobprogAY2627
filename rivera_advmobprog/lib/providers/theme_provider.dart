import 'package:flutter/material.dart';

class ThemeProvider
    extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark =>
      _isDark;

  ThemeData get lightTheme {
    return ThemeData(
      brightness:
          Brightness.light,

      scaffoldBackgroundColor:
          const Color(
        0xFFFFF8FF,
      ),

      appBarTheme:
          const AppBarTheme(
        backgroundColor:
            Color(
          0xFF3949AB,
        ),
        foregroundColor:
            Colors.white,
      ),

      colorScheme:
          ColorScheme.fromSeed(
        seedColor:
            const Color(
          0xFF3949AB,
        ),
        brightness:
            Brightness.light,
      ),

      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness:
          Brightness.dark,

      colorScheme:
          ColorScheme.fromSeed(
        seedColor:
            const Color(
          0xFF3949AB,
        ),
        brightness:
            Brightness.dark,
      ),

      useMaterial3: true,
    );
  }

  void toggleTheme(
    bool value,
  ) {
    _isDark = value;

    notifyListeners();
  }
}