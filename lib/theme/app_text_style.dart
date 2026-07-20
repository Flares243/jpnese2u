import 'package:flutter/material.dart';

enum AppFonts {
  jetbrainsMono('JetBrainsMono'),
  sfProText('SF Pro Text'),
  ;

  const AppFonts(this.name);

  final String name;
}

class AppTextStyle {
  static final sectionLabel = TextStyle(
    fontSize: 11,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.sfProText.name,
  );

  static final headline = TextStyle(
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.48,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.sfProText.name,
  );

  static final tokenWord = TextStyle(
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.48,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.sfProText.name,
  );

  static final tokenBadge = TextStyle(
    fontSize: 11,
    letterSpacing: 0.24,
    fontWeight: FontWeight.w500,
    fontFamily: AppFonts.jetbrainsMono.name,
  );

  static final tokenReading = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.sfProText.name,
  );

  static final tokenMeaning = TextStyle(
    fontSize: 14,
    height: 1.43,
    fontWeight: FontWeight.w400,
    fontFamily: AppFonts.sfProText.name,
  );
}
