import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:renmoney_test/core/exception/api_exception.dart';
import 'package:renmoney_test/core/services/api_response.dart';
import 'package:renmoney_test/core/services/endpoints.dart';
import 'package:renmoney_test/core/services/network_service/network_service.dart';
import 'package:renmoney_test/core/services/network_service/network_service_impl.dart';
import 'package:renmoney_test/features/weather/data/weather_report_model.dart';

final weatherRepoProvider = Provider<WeatherReportRepository>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return WeatherReportRepositoryImpl(networkService);
});

abstract class WeatherReportRepository {
  Future<ApiResponse<WeatherReportModel>> fetchWeatherByCity(String city);
  Future<ApiResponse<WeatherReportModel>> fetchWeatherByLocation(
      double lat, double lon);
}

class WeatherReportRepositoryImpl implements WeatherReportRepository {
  WeatherReportRepositoryImpl(this.networkService);

  final NetworkService networkService;

  final String? apiKey = dotenv.env['API_KEY'];

  @override
  Future<ApiResponse<WeatherReportModel>> fetchWeatherByCity(
      String city) async {
    try {
      final response = await networkService.get(
        Endpoints.fetchWeatherByCity(city, apiKey ?? ''),
      );

      return Successful(
        data: WeatherReportModel.fromJson(response.data),
      );
    } catch (e) {
      return Error(error: ApiException.getException(e));
    }
  }

  @override
  Future<ApiResponse<WeatherReportModel>> fetchWeatherByLocation(
      double lat, double lon) async {
    try {
      final response = await networkService.get(
        Endpoints.fetchWeatherByLocation(apiKey ?? '', lat: lat, lon: lon),
      );

      return Successful(
        data: WeatherReportModel.fromJson(response.data),
      );
    } catch (e) {
      return Error(error: ApiException.getException(e));
    }
  }
}
