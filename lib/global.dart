import 'package:flutter/material.dart';

abstract class Paths {
  static const String root = 'https://firestore.googleapis.com/v1beta1/';
  static const String projectName = 'blood-test-report-relay';
  static const String databaseType = '(default)';
  static const String collectionName = 'reports';
  static const String baseUrl =
      '$root/projects/$projectName/databases/$databaseType/documents/$collectionName';
}

abstract class ThemeColors {
  static const Color primaryColor = Color.fromARGB(255, 198, 40, 40);
  static const Color accentColor = Color.fromARGB(255, 142, 0, 0);
}
