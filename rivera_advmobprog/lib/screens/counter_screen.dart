import 'package:flutter/material.dart';

import 'settings_screen.dart';


/// CounterScreen demonstrates Ephemeral State.
/// The counter value only belongs to this widget.
class CounterScreen extends StatefulWidget {

  const CounterScreen({super.key});


  @override
  State<CounterScreen> createState() =>
      _CounterScreenState();

}


/// State class that manages the counter value.
class _CounterScreenState extends State<CounterScreen> {


  // Local state variable.
  int counter = 0;



  /// Adds one to the counter value.
  void increaseCounter() {

    setState(() {

      counter++;

    });

  }



  /// Builds the counter screen interface.
  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
          "Counter - Ephemeral State",
        ),


        actions: [


          // Opens the theme settings screen.
          IconButton(

            icon: const Icon(
              Icons.settings,
            ),


            onPressed: () {


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                      const SettingsScreen(),

                ),

              );


            },

          ),


        ],

      ),



      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,


          children: [


            const Text(

              "Counter Value",

              style: TextStyle(

                fontSize: 22,

              ),

            ),



            Text(

              "$counter",

              style: const TextStyle(

                fontSize: 50,

                fontWeight: FontWeight.bold,

              ),

            ),


          ],

        ),

      ),



      floatingActionButton: FloatingActionButton(

        onPressed: increaseCounter,

        child: const Icon(
          Icons.add,
        ),

      ),


    );

  }

}
