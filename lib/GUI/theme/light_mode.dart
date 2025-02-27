import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey[50]!,
    primary: const Color.fromARGB(230, 254, 131, 1),
    secondary: Colors.grey.shade900,

    inversePrimary: Colors.grey.shade900,
  ),

    textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.grey[800]!,
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      ),

    bodyMedium: TextStyle(
      color: Colors.grey[800]!,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      ),

      labelMedium: TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
      ),

      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.normal,
      ),

    displayLarge: TextStyle(
      color: Colors.black,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      ),

    displayMedium: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),

    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),

    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 96.0,
      fontWeight: FontWeight.bold,
    ),

    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    ),

    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    ),

),

  buttonTheme: ButtonThemeData(
    buttonColor: Colors.grey.shade400, // Button color
    textTheme: ButtonTextTheme.primary, // Button text color
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade900,
      textStyle: TextStyle(
        color: Colors.orange,
      ),
    )
  )

);
