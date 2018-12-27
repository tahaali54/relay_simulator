import 'package:flutter/material.dart';
import 'package:relay_simulator/baby_names_page.dart';

void main() => runApp(RelaySim());

class RelaySim extends StatelessWidget {
  final Color _primaryColor = Color.fromARGB(255, 198, 40, 40);
  final Color _accentColor = Color.fromARGB(255, 142, 0, 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Relay Simulator",
      home: BabyNamesPage(),
      routes: {
        //Routes.qr: (context) => new QrScanPage(),
      },
      theme: ThemeData(
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          buttonColor: _primaryColor,
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
    );
  }
}
