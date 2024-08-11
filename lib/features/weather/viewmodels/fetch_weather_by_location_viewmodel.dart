import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renmoney_test/features/weather/data/weather_report_model.dart';
import 'package:renmoney_test/features/weather/repo/weather_report.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_city_viewmodel.dart';
import 'package:renmoney_test/shared/exports.dart';

final fetchWeatherByLocationProvider = StateNotifierProvider<
    FetchWeatherByLocationNotifier, AsyncValue<WeatherReportModel?>>((ref) {
  return FetchWeatherByLocationNotifier(ref);
});

class FetchWeatherByLocationNotifier
    extends StateNotifier<AsyncValue<WeatherReportModel?>> {
  FetchWeatherByLocationNotifier(this.ref)
      : repository = ref.read(weatherRepoProvider),
        super(const AsyncData(null));

  final Ref ref;
  final WeatherReportRepository repository;

  Future<void> fetchWeatherByLocation() async {
    state = const AsyncLoading();
    final coordinate = await LocationUtil().getCurrentLocation();

    final response = await repository.fetchWeatherByLocation(
      coordinate['lat'],
      coordinate['lon'],
    );

    response.when(
      successful: (result) {
        state = AsyncData(result.data);

        ref.read(selectedCityReport.notifier).state = result.data;
      },
      error: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }
}
