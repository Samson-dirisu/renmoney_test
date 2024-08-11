// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class WeatherProvider extends ChangeNotifier {
//   List<String> _selectedCities = ['Lagos', 'Abuja', 'Ibadan'];
//   Map<String, Map<String, dynamic>> _weatherData = {};

//   WeatherService _weatherService = WeatherService();

//   WeatherProvider() {
//     _loadSelectedCities();
//     _fetchWeatherForSelectedCities();
//   }

//   List<String> get selectedCities => _selectedCities;
//   Map<String, Map<String, dynamic>> get weatherData => _weatherData;

//   Future<void> _loadSelectedCities() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _selectedCities = prefs.getStringList('selectedCities') ?? ['Lagos', 'Abuja', 'Ibadan'];
//     notifyListeners();
//   }

//   Future<void> _fetchWeatherForSelectedCities() async {
//     for (String city in _selectedCities) {
//       _weatherData[city] = await _weatherService.fetchWeatherByCity(city);
//     }
//     notifyListeners();
//   }

//   Future<void> addCity(String city) async {
//     if (!_selectedCities.contains(city)) {
//       _selectedCities.add(city);
//       _weatherData[city] = await _weatherService.fetchWeatherByCity(city);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setStringList('selectedCities', _selectedCities);
//       notifyListeners();
//     }
//   }

//   void removeCity(String city) async {
//     _selectedCities.remove(city);
//     _weatherData.remove(city);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setStringList('selectedCities', _selectedCities);
//     notifyListeners();
//   }

//   Future<void> fetchWeatherByLocation(double lat, double lon) async {
//     Map<String, dynamic> data =
//         await _weatherService.fetchWeatherByLocation(lat, lon);
//     _weatherData['Current Location'] = data;
//     notifyListeners();
//   }
// }