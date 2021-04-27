import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// source:
// https://stackoverflow.com/questions/49757953/how-to-load-json-assets-into-flutter-app
Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle.loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr));
}