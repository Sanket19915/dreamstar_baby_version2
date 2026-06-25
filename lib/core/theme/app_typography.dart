import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography with Devanagari (Hindi) fallbacks for API-driven content.
class AppTypography {
  AppTypography._();

  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return GoogleFonts.notoSansDevanagari(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    ).merge(GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    ));
  }

  static TextTheme get textTheme => TextTheme(
        bodyLarge: poppins(fontSize: 16),
        bodyMedium: poppins(fontSize: 14),
        bodySmall: poppins(fontSize: 12),
        titleLarge: poppins(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium: poppins(fontSize: 16, fontWeight: FontWeight.w600),
        labelLarge: poppins(fontSize: 14, fontWeight: FontWeight.w500),
      );
}
