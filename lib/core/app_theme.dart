import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme({required bool isDark}) {
  final base = isDark ? ThemeData.dark() : ThemeData.light();

  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F1F1F),
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    textTheme: GoogleFonts.loraTextTheme(base.textTheme).copyWith(
      bodyMedium: GoogleFonts.lora(
        fontWeight: FontWeight.w300,
        fontSize: 16,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
  );
}
