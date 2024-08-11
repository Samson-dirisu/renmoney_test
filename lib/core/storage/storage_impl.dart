import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renmoney_test/core/storage/exports.dart';
import 'package:renmoney_test/features/weather/data/weather_report_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// app storage instance provider
final storageProvider = Provider<Storage>((ref) {
  return StorageImpl();
});

class StorageImpl implements Storage {
  // Obtain shared preferences.
  late SharedPreferences prefs;

  @override
  Future<void> clear() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<void> saveList<T>(String key, List<T> value) async {
    prefs = await SharedPreferences.getInstance();

    // Convert the list of objects to a list of JSON strings
    List<String> jsonList =
        value.map((item) => jsonEncode(_encode(item))).toList();

    // Save the list of JSON strings to SharedPreferences
    await prefs.setStringList(key, jsonList);
  }

  @override
  Future<List<T>?> getList<T>(String key) async {
    prefs = await SharedPreferences.getInstance();

    // Retrieve the list of JSON strings from SharedPreferences
    List<String>? jsonList = prefs.getStringList(key);

    if (jsonList != null) {
      // Convert each JSON string back into an object of type T
      return jsonList
          .map((jsonStr) => _decode<T>(jsonDecode(jsonStr)))
          .toList();
    }
    return null;
  }

  // Method to encode an object of type T to JSON
  Map<String, dynamic> _encode<T>(T item) {
    if (item is WeatherReportModel) {
      return item.toJson();
    }
    throw Exception('Type not supported for encoding');
  }

  // Method to decode a JSON object to type T
  T _decode<T>(Map<String, dynamic> json) {
    if (T == WeatherReportModel) {
      return WeatherReportModel.fromJson(json) as T;
    }
    throw Exception('Type not supported for decoding');
  }
}
