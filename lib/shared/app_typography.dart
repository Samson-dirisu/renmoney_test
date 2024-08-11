import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:renmoney_test/shared/app_colors.dart';

class AppTypography {

  static final _instance = AppTypography._internal();

  AppTypography._internal();

  factory AppTypography() => _instance;


// Bold
static final outfitbold18 = GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: appColors.black,
      height: 1.1,
    ),
  );
  static final outfitbold30= GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.w600,
      color: appColors.black,
      height: 1.1,
    ),
  );
  static final outfitbold100= GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 100.sp,
      fontWeight: FontWeight.w600,
      color: appColors.black,
      height: 1.1,
    ),
  );
 

  // Normal
  static final outfitNormal14 = GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: appColors.black,
      height: 1.1,
    ),
  );
   static final outfitNormal38 = GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 38.sp,
      fontWeight: FontWeight.w400,
      color: appColors.black,
      height: 1.1,
    ),
  );

  // Semi bold
   static final outfitSemibold18 = GoogleFonts.outfit(
    textStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      color: appColors.black,
      height: 1.1,
    ),
  );
}