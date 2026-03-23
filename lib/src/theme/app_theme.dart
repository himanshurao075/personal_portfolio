import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFFEE3A3A);
  const secondary = Color(0xFF176BFF);
  const base = Color(0xFF061120);
  const surface = Color(0xFFF7F8FC);

  final textTheme = GoogleFonts.spaceGroteskTextTheme().copyWith(
    bodyMedium: GoogleFonts.dmSans(fontSize: 16, height: 1.6),
    bodyLarge: GoogleFonts.dmSans(fontSize: 18, height: 1.6),
  );

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: surface,
    ),
    textTheme: textTheme.apply(bodyColor: base, displayColor: base),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white.withValues(alpha: 0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: secondary.withValues(alpha: 0.16)),
      labelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: base),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
  );
}
