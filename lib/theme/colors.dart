import 'package:flutter/material.dart';

var korangeColor = Color(0xFFFF6B00);
var kdarkgraycolor = Color(0xFF1C1C1C);
var kwhitecolors = Colors.white;
var kblackcolor = Color(0xFF0D0D0D);
var kgraycolor = Colors.grey.shade600;
var ktransparentcolor = Colors.transparent;
var kbuttonGraycolor = const Color.fromARGB(255, 147, 147, 147);
var kredcolor = Colors.red;
var kgreencolor = Colors.green;

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kwhitecolors,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.black,
      brightness: Brightness.light,
      background: kwhitecolors,
      onBackground: Colors.black,
      primary: kwhitecolors,
      surface: kwhitecolors,
      onSurface: Colors.black,
      tertiary: const Color.fromARGB(255, 225, 225, 225),
      primaryContainer: Colors.black,
      secondary: korangeColor,
      surfaceBright: korangeColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: kwhitecolors,
      filled: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kblackcolor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kblackcolor,
      onSurface: kblackcolor,
      brightness: Brightness.dark,
      background: kblackcolor,
      onBackground: kblackcolor,
      primary: kblackcolor,
      primaryContainer: Colors.white,
      secondary: Colors.white,
      surface: const Color.fromARGB(255, 202, 198, 198),
      surfaceBright: korangeColor,
      tertiary: const Color.fromARGB(255, 73, 73, 73),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: kblackcolor, // or kBackground
      filled: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
  );
}
