import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[900]!,
    primary: const Color.fromARGB(230, 254, 131, 1),
    secondary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade300,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.grey[300]!,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      color: Colors.grey[300]!,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 96.0,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.grey.shade700,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade300,
      textStyle: TextStyle(
        color: Colors.orange,
      ),
    ),
  ),
);
