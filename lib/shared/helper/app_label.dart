import 'package:dream_baby/shared/helper/app_color.dart';
import 'package:flutter/material.dart';

class CustomLabels {
  static const double verySmallFontSize = 13;
  static const double smallFontSize = 16;
  static const double smallXFontSize = 18;
  static const double mediumFontSize = 23;
  static const double mediumXFontSize = 24;
  static const double largeFontSize = 26;
  static const double veryLargeFontSize = 28;
  static const double extraLargeFontSize = 32;

  static const verySmallFontWeight = FontWeight.w400;
  static const smallFontWeight = FontWeight.w500;
  static const mediumFontWeight = FontWeight.w600;
  static const largeFontWeight = FontWeight.w700;
  static const String primaryFont = "Comfortaa";
  static const String secondaryFont = "Work Sans";

  static TextStyle header1TextStyle({
    double fontSize = extraLargeFontSize,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryColor,
    String fontFamily = primaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pheader0TextStyle({
    double fontSize = extraLargeFontSize,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pheader1TextStyle({
    double fontSize = mediumFontSize,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pbody1TextStyle({
    double fontSize = mediumFontSize,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body2TextStyle({
    double fontSize = smallFontSize,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryColor,
    String fontFamily = secondaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pbody2TextStyle({
    double fontSize = 14,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pbody3TextStyle({
    double fontSize = 10,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: const Color(0xFF050505).withValues(alpha: .6),
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle pbodyTextStyle({
    double fontSize = 14,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.warningColor,
    String fontFamily = primaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body3TextStyle({
    double fontSize = verySmallFontSize,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.secondaryTextColor,
    String fontFamily = primaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle body3BlackTextStyle({
    double fontSize = verySmallFontSize,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = largeFontWeight,
    Color color = AppColors.primaryTextColor,
    String fontFamily = secondaryFont,
    double letterSpacing = .2,
    double height = 1.4,
  }) {
    return TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        decorationColor: Colors.transparent);
  }

  static TextStyle body3GreyTextStyle(
      {double fontSize = verySmallFontSize,
      FontWeight fontWeight = largeFontWeight,
      Color color = AppColors.warningColor,
      String fontFamily = secondaryFont,
      double letterSpacing = 0.2,
      double height = 1.4,
      TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle nextButtonTextStyle(
      {double fontSize = smallFontSize,
      FontWeight fontWeight = largeFontWeight,
      Color color = AppColors.warningColor,
      String fontFamily = secondaryFont,
      double letterSpacing = 0.2,
      double height = 1.4,
      TextDecoration decoration = TextDecoration.none}) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: TextDecoration.none,
    );
  }
}
