import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.light(
          primary: AppColors.coral,
          onPrimary: Colors.white,
          primaryContainer: AppColors.coralLight,
          secondary: AppColors.sage,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.sageLight,
          surface: AppColors.cardBackground,
          onSurface: AppColors.textPrimary,
          error: AppColors.error,
          outline: AppColors.divider,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider, width: 0.5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.coral,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: CircleBorder(),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.cream,
          selectedColor: AppColors.coralLight,
          labelStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: AppColors.divider),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.bottomNavBackground,
          selectedItemColor: AppColors.coral,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.warmWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.coral, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 0.5,
          space: 0,
        ),
      );
}
