import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle heading1(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 64 : 42,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.2,
      letterSpacing: -1,
    );
  }

  static TextStyle heading2(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 48 : 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      height: 1.3,
      letterSpacing: -0.5,
    );
  }

  static TextStyle heading3(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 32 : 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  static TextStyle heading4(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 24 : 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  // Body Text
  static TextStyle bodyLarge(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 18 : 16,
      color: AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 10 : 10,
      color: AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(fontSize: 14, color: AppColors.textTertiary, height: 1.5);
  }

  // Special Styles
  static TextStyle quote(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 22 : 18,
      fontStyle: FontStyle.italic,
      color: AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 14 : 12,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryLight,
      letterSpacing: 2,
    );
  }

  static TextStyle buttonText(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return TextStyle(
      fontSize: size > 768 ? 16 : 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }
}
