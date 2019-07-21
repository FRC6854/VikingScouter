import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: AppBarTheme(
      elevation: 1,
      textTheme: TextTheme(
        title: TextStyle(
          color: lightBG,
          fontSize: 25,
          fontWeight: FontWeight.w500,
          fontFamily: 'Aileron',
        ),
      ),
    ),
  );
}