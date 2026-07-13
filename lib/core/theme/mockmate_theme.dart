import 'package:flutter/material.dart';

abstract final class MockMateColors {
  static const background = Color(0xFF07090D);
  static const surface = Color(0xFF11151C);
  static const surfaceRaised = Color(0xFF171D27);
  static const primary = Color(0xFF7568FF);
  static const primaryStrong = Color(0xFF6254F4);
  static const cyan = Color(0xFF65D9E8);
  static const textPrimary = Color(0xFFF3F5FA);
  static const textSecondary = Color(0xFF929DB0);
  static const outline = Color(0xFF252C38);
  static const outlineStrong = Color(0xFF343D4D);
}

abstract final class MockMateSpacing {
  static const xSmall = 8.0;
  static const small = 12.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const xLarge = 32.0;
  static const xxLarge = 48.0;
}

abstract final class MockMateTheme {
  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: MockMateColors.primary,
      onPrimary: Colors.white,
      secondary: MockMateColors.cyan,
      onSecondary: MockMateColors.background,
      surface: MockMateColors.surface,
      onSurface: MockMateColors.textPrimary,
      error: Color(0xFFFF6B7D),
      onError: Colors.white,
      outline: MockMateColors.outline,
    );

    const textTheme = TextTheme(
      displaySmall: TextStyle(
        color: MockMateColors.textPrimary,
        fontSize: 42,
        fontWeight: FontWeight.w700,
        height: 1.07,
        letterSpacing: -1.5,
      ),
      headlineSmall: TextStyle(
        color: MockMateColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: MockMateColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.3,
      ),
      titleMedium: TextStyle(
        color: MockMateColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: MockMateColors.textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        color: MockMateColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
      ),
      labelLarge: TextStyle(
        color: MockMateColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
    );

    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: MockMateColors.background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: MockMateColors.primaryStrong,
          foregroundColor: Colors.white,
          disabledBackgroundColor: MockMateColors.primaryStrong.withValues(
            alpha: 0.42,
          ),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: roundedShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: MockMateColors.textPrimary,
          disabledForegroundColor: MockMateColors.textSecondary,
          side: const BorderSide(color: MockMateColors.outlineStrong),
          shape: roundedShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MockMateColors.surface,
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: MockMateColors.textSecondary.withValues(alpha: 0.62),
        ),
        prefixIconColor: MockMateColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: MockMateSpacing.medium,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MockMateColors.outlineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MockMateColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF6B7D)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF6B7D), width: 1.5),
        ),
      ),
    );
  }
}
