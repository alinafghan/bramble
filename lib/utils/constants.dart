import 'package:flutter/material.dart';

class AppThemes {
  static const fontFamily = 'Dovemayo';

  static const palette1 = Color.fromRGBO(0, 193, 162, 1.0);
  static const palette2 = Color.fromRGBO(0, 125, 124, 1.0);
  static const palette3 = Color.fromRGBO(1, 66, 66, 1.0);
  static const palette4 = Color.fromRGBO(217, 38, 0, 1.0);
  static const palette5 = Color.fromRGBO(175, 20, 0, 1.0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 242, 244, 250),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    brightness: Brightness.light,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: const Color.fromARGB(255, 242, 244, 250),
    primaryColor: palette3,
    cardColor: const Color.fromARGB(255, 242, 244, 250),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromRGBO(1, 66, 66, 1.0),
      secondary: Color.fromRGBO(0, 125, 124, 1.0),
      tertiary: Color.fromRGBO(0, 193, 162, 1.0),
      onSurface: Colors.black,
      onSurfaceVariant: Colors.grey,
      error: Color.fromRGBO(175, 20, 0, 1.0),
    ).copyWith(
      surface: const Color.fromARGB(255, 242, 244, 250),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color.fromARGB(255, 41, 41, 136),
    cardColor: const Color(0xFF1E1E2C),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromRGBO(1, 66, 66, 1.0),
      secondary: Color.fromRGBO(8, 53, 53, 1),
      tertiary: Color.fromRGBO(79, 135, 126, 1),
      onSurface: Colors.white,
    ).copyWith(
      surface: const Color(0xFF121212),
    ),
  );
}
