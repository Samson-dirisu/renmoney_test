import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renmoney_test/core/storage/exports.dart';
import 'package:renmoney_test/features/weather/data/weather_report_model.dart';
import 'package:renmoney_test/features/weather/repo/weather_report.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:renmoney_test/shared/strings.dart';

final fetchWeatherByCityProvider = StateNotifierProvider<
    FetchWeatherByCityNotifier, AsyncValue<List<WeatherReportModel>?>>((ref) {
  return FetchWeatherByCityNotifier(ref);
});

final citiesFromJsonProvider = FutureProvider<List<String>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/ng.json');
  final jsonData = jsonDecode(jsonString);
  return List<String>.from(jsonData['cities']);
});

final selectedCities = StateProvider<List<String>>(
  (ref) => ['Lagos', 'Abuja', 'Ibadan'],
);

final selectedCityReport = StateProvider<WeatherReportModel?>((ref) => null);

class FetchWeatherByCityNotifier
    extends StateNotifier<AsyncValue<List<WeatherReportModel>?>> {
  FetchWeatherByCityNotifier(this.ref)
      : repository = ref.read(weatherRepoProvider),
        storage = ref.read(storageProvider),
        super(const AsyncData(null)) {
    fetchReportFromStorage();
  }

  final Ref ref;
  final WeatherReportRepository repository;
  final Storage storage;

  List<WeatherReportModel> tempList = [];

  Future<void> fetchMultipleCities() async {
    
    final cities = ref.read(selectedCities);

    try {
      final responses = await Future.wait(
        cities.map((city) => repository.fetchWeatherByCity(city)),
      );

      for (var response in responses) {
        response.when(
          successful: (result) {
            if (result.data != null) {
              tempList.add(result.data!);
            }
          },
          error: (error) {
            state = AsyncError(error, StackTrace.current);
          },
        );
      }

      if (tempList.isNotEmpty) {
        ref.read(selectedCityReport.notifier).state = tempList.first;
        state = AsyncData(tempList);
        await storage.saveList(kWeatherReport, tempList);
      }
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
    }
  }

  Future<void> fetchWeatherByCity(String city, {bool showIndicator = false}) async {
    if (showIndicator) {
      state = const AsyncLoading();
    }

    final response = await repository.fetchWeatherByCity(city);

    response.when(
      successful: (result) {
        if (result.data != null) {
          tempList.add(result.data!);
          _updateState();
        }
      },
      error: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  void addOrRemoveCity(String city) async {
    final cityExists =
        tempList.any((e) => e.name?.toLowerCase() == city.toLowerCase());

    if (!cityExists) {
      await fetchWeatherByCity(city);
    } else {
      tempList.removeWhere((e) => e.name?.toLowerCase() == city.toLowerCase());
      _updateState();
    }
  }

  Future<void> fetchReportFromStorage() async {
    final reports = await storage.getList<WeatherReportModel>(kWeatherReport);

    if (reports != null && reports.isNotEmpty) {
      tempList = reports;
      state = AsyncData(reports);
      ref.read(selectedCityReport.notifier).state = reports.first;
      _updateSelectedCities(reports);
    } else {
      fetchMultipleCities();
    }
  }

  void _updateState() {
    state = AsyncData(
        List.from(tempList)); // Creating a new list to trigger state update
    storage.saveList(kWeatherReport, tempList);
  }

  void _updateSelectedCities(List<WeatherReportModel> reports) {
    ref.read(selectedCities.notifier).state =
        reports.map((e) => e.name ?? '').toList();
  }
}
