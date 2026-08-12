import 'package:flutter/material.dart';
import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';

class AppTextStyle {
  static const f9h11 = TextStyle(
    fontSize: 9,
    height: 11 / 9,
    fontFamily: AppFonts.sfProText,
  );

  static const f10h15 = TextStyle(
    fontSize: 10,
    height: 15 / 10,
    fontFamily: AppFonts.sfProText,
  );

  static const f11h14 = TextStyle(
    fontSize: 11,
    height: 14.3 / 11,
    fontFamily: AppFonts.sfProText,
  );

  static const f12h16 = TextStyle(
    fontSize: 12,
    height: 15.6 / 12,
    fontFamily: AppFonts.sfProText,
  );

  static const f13h19 = TextStyle(
    fontSize: 13,
    height: 19.5 / 13,
    fontFamily: AppFonts.sfProText,
  );

  static const f14h21 = TextStyle(
    fontSize: 14,
    height: 21 / 14,
    fontFamily: AppFonts.sfProText,
  );

  static const f15h15 = TextStyle(
    fontSize: 15,
    height: 15 / 15,
    fontFamily: AppFonts.sfProText,
  );

  static const f15h22 = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontFamily: AppFonts.sfProText,
  );

  static const f16h20 = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontFamily: AppFonts.sfProText,
  );

  static const f16h24 = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontFamily: AppFonts.sfProText,
  );

  static const f18h27 = TextStyle(
    fontSize: 18,
    height: 27 / 18,
    fontFamily: AppFonts.sfProText,
  );

  static const f20h30 = TextStyle(
    fontSize: 20,
    height: 30 / 20,
    fontFamily: AppFonts.sfProText,
  );

  static const f22h33 = TextStyle(
    fontSize: 22,
    height: 33 / 22,
    fontFamily: AppFonts.sfProText,
  );

  static const f23h23 = TextStyle(
    fontSize: 23,
    height: 23 / 23,
    fontFamily: AppFonts.sfProText,
  );

  static const f24h32 = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontFamily: AppFonts.sfProText,
  );

  static const f24h36 = TextStyle(
    fontSize: 24,
    height: 36 / 24,
    fontFamily: AppFonts.sfProText,
  );

  static const f28h42 = TextStyle(
    fontSize: 28,
    height: 42 / 28,
    fontFamily: AppFonts.sfProText,
  );

  static const f34h41 = TextStyle(
    fontSize: 34,
    height: 41 / 34,
    fontFamily: AppFonts.sfProText,
  );

  // Usage sample: AppTextStyle.body2.merge(AppTextStyle.link)
  static const link = TextStyle(
    shadows: [
      Shadow(
        color: AppColor.xFF5167A5,
        offset: Offset(0, -1.5),
      ),
    ],
    color: Colors.transparent,
    decoration: TextDecoration.underline,
    decorationColor: AppColor.xFF5167A5,
  );
}
