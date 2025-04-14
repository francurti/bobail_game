import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF00796B), // Teal
    brightness: Brightness.light,
    surface: const Color(0xFF00695C),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 19, 144, 130),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF00796B),
    foregroundColor: Color(0xFFFAFAFA),
    elevation: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF00796B),
    foregroundColor: Color(0xFFFAFAFA),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Color(0xFF00796B),
      side: BorderSide(color: Color(0xFF00796B), width: 1.5),
      textStyle: TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);
