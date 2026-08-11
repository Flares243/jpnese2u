import 'package:flutter/material.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.xFF1F108E,
      onPrimary: AppColor.white,
      primaryContainer: AppColor.xFF3B35A7,
      onPrimaryContainer: AppColor.xFFA9A7FF,
      secondary: AppColor.xFF4648D4,
      onSecondary: AppColor.white,
      secondaryContainer: AppColor.xFF6063EE,
      onSecondaryContainer: AppColor.white,
      tertiary: AppColor.xFF511C00,
      onTertiary: AppColor.white,
      tertiaryContainer: AppColor.xFF752C00,
      onTertiaryContainer: AppColor.xFFFE9562,
      error: AppColor.xFFBA1A1A,
      onError: AppColor.white,
      errorContainer: AppColor.xFFFFDAD6,
      onErrorContainer: AppColor.xFF93000A,
      surface: AppColor.xFFFCF8FF,
      surfaceDim: AppColor.xFFDCD8E3,
      surfaceBright: AppColor.xFFFCF8FF,
      surfaceContainerLowest: AppColor.white,
      surfaceContainerLow: AppColor.xFFF6F2FC,
      surfaceContainer: AppColor.xFFF0ECF6,
      surfaceContainerHigh: AppColor.xFFEAE6F1,
      surfaceContainerHighest: AppColor.xFFE4E1EB,
      onSurface: AppColor.xFF1B1B22,
      onSurfaceVariant: AppColor.xFF464553,
      outline: AppColor.xFF777584,
      outlineVariant: AppColor.xFFC8C4D5,
      inverseSurface: AppColor.xFF303037,
      onInverseSurface: AppColor.xFFF3EFF9,
      inversePrimary: AppColor.xFFC3C0FF,
      surfaceTint: AppColor.xFF544FC0,
      shadow: AppColor.x0D000000,
      scrim: AppColor.black,
    );

    const cardRadius = BorderRadius.all(Radius.circular(12));
    const buttonRadius = BorderRadius.all(Radius.circular(8));
    const inputRadius = BorderRadius.all(Radius.circular(8));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColor.xFFFCF8FF,
      fontFamily: AppFonts.sfProText.name,
      splashFactory: NoSplash.splashFactory,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 32 / 24,
          letterSpacing: -0.02 * 24,
          color: AppColor.xFF1B1B22,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 24 / 18,
          letterSpacing: -0.01 * 18,
          color: AppColor.xFF1B1B22,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: AppColor.xFF1B1B22,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColor.xFF1B1B22,
        ),
        labelMedium: TextStyle(
          fontFamily: AppFonts.jetbrainsMono.name,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          letterSpacing: 0.02 * 12,
          color: AppColor.xFF464553,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 14 / 11,
          color: AppColor.xFF464553,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.xFFFCF8FF,
        foregroundColor: AppColor.xFF1B1B22,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: const CardThemeData(
        color: AppColor.white,
        elevation: 0,
        shadowColor: AppColor.x0D000000,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.xFF1F108E,
          foregroundColor: AppColor.white,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: AppColor.xFFF3F4F6,
          foregroundColor: AppColor.xFF1F108E,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.xFF1F108E,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: AppColor.xFF3B35A7),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: const OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: AppColor.xFFE5E7EB),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: AppColor.xFFE5E7EB),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: AppColor.xFF1F108E),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: AppColor.xFFBA1A1A),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: AppColor.xFFBA1A1A, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 14,
          color: AppColor.xFF777584,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColor.xFFF3F4F6,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColor.xFFF0ECF6,
        selectedColor: AppColor.xFF1F108E,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColor.xFFEEF2FF,
        labelStyle: TextStyle(
          fontFamily: AppFonts.jetbrainsMono.name,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColor.xFF312E81,
        ),
        side: const BorderSide(color: AppColor.xFFB0BEFF),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColor.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: AppColor.x0D000000,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColor.xFF464553),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(4),
      ),
    );
  }
}
