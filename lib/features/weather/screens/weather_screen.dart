import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_city_viewmodel.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_location_viewmodel.dart';
import 'package:renmoney_test/shared/exports.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColors.yellow,
        onPressed: () {
          ref
              .read(fetchWeatherByLocationProvider.notifier)
              .fetchWeatherByLocation();
        },
        child: const Icon(
          Icons.pin_drop,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Renmoney Weather App',
          style: AppTypography.outfitbold18.copyWith(
            color: appColors.white,
          ),
        ),
        actions: [
          Consumer(builder: (_, ref, __) {
            return MultiSelectDropdown(
                cities: ref.watch(citiesFromJsonProvider).valueOrNull ?? []);
          }),
        ],
      ),
      body: Column(
        children: [
          // SizedBox(height: 30.h),
          Expanded(
            child: Consumer(builder: (_, ref, __) {
              final selectedCity = ref.watch(selectedCityReport);
              final convertedDegree = (selectedCity?.main?.temp ?? 0) - 274.15;
              return WeatherMainCard(
                nameOfCity: selectedCity?.name ?? '',
                description: selectedCity?.weather?.first.description ?? '',
                forecast: selectedCity?.weather?.first.main ?? '',
                mainValue: selectedCity?.main?.temp != null
                    ? convertedDegree.round().toString()
                    : '',
                humidityValue: selectedCity?.main?.humidity.toString() ?? '',
                pressureValue: selectedCity?.main?.pressure.toString() ?? '',
                windValue: selectedCity?.wind?.speed.toString() ?? '',
              );
            }),
          ),
          SizedBox(height: 10.h),
          Consumer(builder: (_, ref, __) {
            final fetchWeatherProvider =
                ref.watch(fetchWeatherByCityProvider).valueOrNull;

            final selectedCity = ref.watch(selectedCityReport);
            return CarouselSlider(
              items: List.generate(fetchWeatherProvider?.length ?? 0, (index) {
                final cityReport = fetchWeatherProvider?[index];
                return CityCards(
                  model: cityReport,
                  selected: cityReport?.name?.toLowerCase() ==
                      selectedCity?.name?.toLowerCase(),
                );
              }),
              options: CarouselOptions(
                  height: 200.h,
                  viewportFraction: .5,
                  enableInfiniteScroll: false),
            );
          }),
        ],
      ),
    );
  }
}
