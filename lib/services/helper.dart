import 'dart:convert';
import 'package:flutter/services.dart'; // Untuk mengakses file asset

Future<Map<String, dynamic>> loadRegions() async {
  // Load JSON file dari assets
  String jsonString =
      await rootBundle.loadString('lib/models/regions/indonesia.json');
  Map<String, dynamic> regions = json.decode(jsonString);
  return regions;
}
