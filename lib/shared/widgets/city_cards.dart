import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:renmoney_test/features/weather/data/weather_report_model.dart';
import 'package:renmoney_test/features/weather/viewmodels/fetch_weather_by_city_viewmodel.dart';
import 'package:renmoney_test/shared/app_colors.dart';
import 'package:renmoney_test/shared/app_typography.dart';

class CityCards extends ConsumerWidget {
  const CityCards({
    super.key,
    required this.model,
    required this.selected,
  });
  final WeatherReportModel? model;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final convertedDegree = (model?.main?.temp ?? 0) - 274.15;
    return InkWell(
      onTap: () {
        HapticFeedback.mediumImpact();
        ref.read(selectedCityReport.notifier).state = model;
      },
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              30,
            ),
            color: selected ? appColors.yellow : appColors.white,
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Text(
                model?.name ?? '',
                style: AppTypography.outfitSemibold18.copyWith(fontSize: 30.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                model?.weather?.first.description ?? '',
                style: AppTypography.outfitNormal38.copyWith(
                  color: appColors.black.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                model?.weather?.first.main ?? '',
                style: AppTypography.outfitNormal38.copyWith(
                  color: appColors.black.withOpacity(.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    convertedDegree.round().toString(),
                    style: AppTypography.outfitSemibold18.copyWith(
                      fontSize: 40.sp,
                    ),
                  ),
                  Icon(
                    Icons.device_thermostat_outlined,
                    color: appColors.black,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
