import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:relay_simulator/baby_names_page.dart';
import 'package:relay_simulator/global.dart';
import 'package:relay_simulator/home_page.dart';

void main() => runApp(RelaySim());

class RelaySim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Relay Simulator",
      routes: {
        '/': (_) => HomePage(),
        '/widget': (_) => WebviewScaffold(
              url: 'https://k163061-thesis2-node.azurewebsites.net/',
              appBar: AppBar(
                title: const Text('Upload to cloud server'),
              ),
              withZoom: true,
              withLocalStorage: true,
            )
      },
      theme: ThemeData(
          primaryColor: ThemeColors.primaryColor,
          accentColor: ThemeColors.accentColor,
          buttonColor: ThemeColors.primaryColor,
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
    );
  }
}
