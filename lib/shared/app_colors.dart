import 'package:flutter/material.dart';

class _AppColors {
  const _AppColors({
    required this.black,
    required this.white,
    required this.yellow,
  });
  final Color black;
  final Color white;
  final Color yellow;
}

const appColors = _AppColors(
  black: Color(0xff111111),
  white: Colors.white,
  yellow: Color(0xffFDD648),
);
