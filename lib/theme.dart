// lib/theme.dart
import 'package:flutter/material.dart';

final ThemeData pedidosTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF45068e),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  colorScheme:
      ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
        backgroundColor: const Color(0xFFF5F5F5),
      ).copyWith(
        secondary: const Color(0xFFFFCA28),
        error: const Color(0xFFE53935),
      ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF212121),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF212121)),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF757575)),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF673AB7),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF673AB7),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF673AB7)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFF673AB7), width: 2),
    ),
  ),
);
