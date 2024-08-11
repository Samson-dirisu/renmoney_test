import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_location_viewmodel.dart';
import 'package:renmoney_test/shared/exports.dart';

class WeatherMainCard extends ConsumerWidget {
  const WeatherMainCard({
    super.key,
    required this.nameOfCity,
    required this.description,
    required this.forecast,
    required this.humidityValue,
    required this.mainValue,
    required this.pressureValue,
    required this.windValue,
  });

  final String nameOfCity;
  final String description;
  final String forecast;
  final String mainValue;
  final String pressureValue;
  final String windValue;
  final String humidityValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: appColors.yellow,
      ),
      child: ref.watch(fetchWeatherByLocationProvider).isLoading
          ? Transform.scale(
              scale: .1,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 30.w,
              ),
            )
          : Column(
              children: [
                SizedBox(height: 40.h),
                Text(
                  nameOfCity,
                  style: AppTypography.outfitbold30,
                ),
                SizedBox(height: 10.h),
                Text(
                  description,
                  style: AppTypography.outfitNormal38.copyWith(
                    color: appColors.black.withOpacity(.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 80.h),
                Text(
                  forecast,
                  style: AppTypography.outfitNormal38.copyWith(
                    color: appColors.black.withOpacity(.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  mainValue,
                  style: AppTypography.outfitbold100.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 150.sp,
                  ),
                ),

                // more datas
                SizedBox(height: 100.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SubContainer(
                      backgroundColors: appColors.white,
                      textColor: appColors.black,
                      title: 'Pressure',
                      subTitle: pressureValue,
                      icon: Icons.device_thermostat_outlined,
                    ),
                    _SubContainer(
                      backgroundColors: appColors.black,
                      textColor: appColors.white,
                      title: 'Wind',
                      subTitle: windValue,
                      icon: Icons.wind_power_outlined,
                    ),
                    _SubContainer(
                      backgroundColors: appColors.white,
                      textColor: appColors.black,
                      title: 'Humidity',
                      subTitle: humidityValue,
                      icon: Icons.water_drop_outlined,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _SubContainer extends StatelessWidget {
  const _SubContainer({
    this.backgroundColors = Colors.black,
    required this.textColor,
    required this.title,
    required this.subTitle,
    required this.icon,
  });
  final Color backgroundColors;
  final Color textColor;
  final String title;
  final String subTitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: backgroundColors,
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Icon(icon, color: textColor),
          SizedBox(height: 20.h),
          Text(
            title,
            style: AppTypography.outfitNormal14.copyWith(
              color: textColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            subTitle,
            style: AppTypography.outfitNormal14.copyWith(
              color: textColor,
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
