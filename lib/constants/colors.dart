import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (فیروزه‌ای)
  static const Color primary = Color(0xFF0BDCF4);
  static const Color primaryDark = Color(0xFF09B5C8);
  static const Color primaryLight = Color(0xFF8FEFFA);

  // Background Colors (مشکی بسیار شیک و عمیق)
  static const Color background = Color(0xFF070B11);
  static const Color backgroundLight = Color(0xFF0D141F);
  static const Color surface = Color.fromARGB(255, 11, 25, 28);
  static const Color surfaceLight = Color(0xFF172336);

  // Text Colors (خوانا و ملایم)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Accent & Luxury Colors (طلایی لوکس و سبز زنگاری)
  static const Color accentGold = Color(0xFFEAB308); // طلایی
  static const Color accentGoldLight = Color(
    0xFAFDE047,
  ); // طلایی روشن تر (برای افکت‌ها)
  static const Color accentJade = Color(0xFF059669); // سبز زنگاری (Jade Green)
  static const Color accentAlert = Color(0xFFEF4444); // قرمز (برای خطاها)

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0BDCF4), Color(0xFF059669)], // فیروزه‌ای به سبز زنگاری
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF070B11), Color(0xFF0D141F)], // مشکی به آبی بسیار تیره
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD97706),
      Color(0xFFFBBF24),
    ], // گرادیان طلایی برای المان‌های لاکچری
  );
}
