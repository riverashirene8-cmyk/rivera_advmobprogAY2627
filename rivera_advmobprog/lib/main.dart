
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/theme_provider.dart';
import 'screens/counter_screen.dart';


/// Main function of the Flutter application.
/// Starts the app and provides ThemeProvider globally.
void main() {

  runApp(

    ChangeNotifierProvider(

      // Creates the global theme state.
      create: (context) => ThemeProvider(),

      child: const MyApp(),

    ),

  );

}


/// Root widget of the application.
/// Controls the application theme.
class MyApp extends StatelessWidget {

  const MyApp({super.key});


  /// Builds the Material application.
  @override
  Widget build(BuildContext context) {


    // Gets the current theme state from Provider.
    final themeProvider =
        Provider.of<ThemeProvider>(context);


    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: "Ephemeral vs App State",


      // Normal light theme.
      theme: ThemeData(

        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

      ),


      // Dark theme.
      darkTheme: ThemeData(

        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,

          brightness: Brightness.dark,
        ),

      ),


      // Chooses which theme to display.
      themeMode: themeProvider.isDark
          ? ThemeMode.dark
          : ThemeMode.light,


      // First screen of the application.
      home: const CounterScreen(),

    );
  }
}   


