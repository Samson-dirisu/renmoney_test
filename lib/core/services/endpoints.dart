class Endpoints {
  static String fetchWeatherByCity(String city, String apiKey) =>
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey";

  static String fetchWeatherByLocation(String apiKey,
          {required double lat, required double lon}) =>
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey";
}
