import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_provider.dart';


/// Settings screen controls the app-wide theme.
class SettingsScreen extends StatelessWidget {

  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {


    final themeProvider =
        Provider.of<ThemeProvider>(context);



    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Theme Settings",
        ),

      ),



      body: Center(

        child: SwitchListTile(

          title: const Text(
            "Dark Mode",
          ),


          value: themeProvider.isDark,


          // Changes the entire app theme.
          onChanged: (value) {

            themeProvider.toggleTheme();

          },


        ),

      ),

    );

  }

}