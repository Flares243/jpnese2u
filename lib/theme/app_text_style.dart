import 'package:flutter/material.dart';

enum AppFonts {
  jetbrainsMono('JetBrainsMono'),
  ;

  const AppFonts(this.name);

  final String name;
}

class AppTextStyle {
  static const sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static const headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
    height: 1.33,
  );

  static const tokenWord = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.48,
    height: 1.33,
  );

  static TextStyle get tokenBadge => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.24,
    fontFamily: AppFonts.jetbrainsMono.name,
  );

  static const tokenReading = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const tokenMeaning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );
}
