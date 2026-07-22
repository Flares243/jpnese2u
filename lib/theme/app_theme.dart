import 'package:flutter/material.dart';

import 'package:jpnese2u/theme/app_color.dart';
import 'package:jpnese2u/theme/app_font.dart';

class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.xff1f108e,
      onPrimary: AppColor.white,
      primaryContainer: AppColor.xff3b35a7,
      onPrimaryContainer: AppColor.xffa9a7ff,
      secondary: AppColor.xff4648d4,
      onSecondary: AppColor.white,
      secondaryContainer: AppColor.xff6063ee,
      onSecondaryContainer: AppColor.white,
      tertiary: AppColor.xff511c00,
      onTertiary: AppColor.white,
      tertiaryContainer: AppColor.xff752c00,
      onTertiaryContainer: AppColor.xfffe9562,
      error: AppColor.xffba1a1a,
      onError: AppColor.white,
      errorContainer: AppColor.xffffdad6,
      onErrorContainer: AppColor.xff93000a,
      surface: AppColor.xfffcf8ff,
      surfaceDim: AppColor.xffdcd8e3,
      surfaceBright: AppColor.xfffcf8ff,
      surfaceContainerLowest: AppColor.white,
      surfaceContainerLow: AppColor.xfff6f2fc,
      surfaceContainer: AppColor.xfff0ecf6,
      surfaceContainerHigh: AppColor.xffeae6f1,
      surfaceContainerHighest: AppColor.xffe4e1eb,
      onSurface: AppColor.xff1b1b22,
      onSurfaceVariant: AppColor.xff464553,
      outline: AppColor.xff777584,
      outlineVariant: AppColor.xffc8c4d5,
      inverseSurface: AppColor.xff303037,
      onInverseSurface: AppColor.xfff3eff9,
      inversePrimary: AppColor.xffc3c0ff,
      surfaceTint: AppColor.xff544fc0,
      shadow: AppColor.x0d000000,
      scrim: AppColor.black,
    );

    const cardRadius = BorderRadius.all(Radius.circular(12));
    const buttonRadius = BorderRadius.all(Radius.circular(8));
    const inputRadius = BorderRadius.all(Radius.circular(8));

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColor.xfffcf8ff,
      fontFamily: AppFonts.sfProText.name,
      splashFactory: NoSplash.splashFactory,
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 32 / 24,
          letterSpacing: -0.02 * 24,
          color: AppColor.xff1b1b22,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 24 / 18,
          letterSpacing: -0.01 * 18,
          color: AppColor.xff1b1b22,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
          color: AppColor.xff1b1b22,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
          color: AppColor.xff1b1b22,
        ),
        labelMedium: TextStyle(
          fontFamily: AppFonts.jetbrainsMono.name,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 16 / 12,
          letterSpacing: 0.02 * 12,
          color: AppColor.xff464553,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 14 / 11,
          color: AppColor.xff464553,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.xfffcf8ff,
        foregroundColor: AppColor.xff1b1b22,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColor.white,
        elevation: 0,
        shadowColor: AppColor.x0d000000,
        shape: const RoundedRectangleBorder(borderRadius: cardRadius),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.xff1f108e,
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
          backgroundColor: AppColor.xfff3f4f6,
          foregroundColor: AppColor.xff1f108e,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.xff1f108e,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: const BorderSide(color: AppColor.xff3b35a7),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: const BorderSide(color: AppColor.xffe5e7eb),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: const BorderSide(color: AppColor.xffe5e7eb),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: const BorderSide(color: AppColor.xff1f108e),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: const BorderSide(color: AppColor.xffba1a1a),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: const BorderSide(color: AppColor.xffba1a1a, width: 1.5),
        ),
        hintStyle: TextStyle(
          fontFamily: AppFonts.sfProText.name,
          fontSize: 14,
          color: AppColor.xff777584,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColor.xfff3f4f6,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColor.xfff0ecf6,
        selectedColor: AppColor.xff1f108e,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColor.xffeef2ff,
        labelStyle: TextStyle(
          fontFamily: AppFonts.jetbrainsMono.name,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColor.xff312e81,
        ),
        side: const BorderSide(color: AppColor.xffc7d2fe),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColor.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: AppColor.x0d000000,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColor.xff464553),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(4),
      ),
    );
  }
}
