import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: COLOR_PRIMARY,
    scaffoldBackgroundColor: SCAFFOLD_BG,
    appBarTheme: const AppBarTheme(
        centerTitle: false,
        foregroundColor: COLOR_DARKER,
        color: Colors.transparent),
    textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: COLOR_DARKER, fontSize: 16)));

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: COLOR_PRIMARY,
  scaffoldBackgroundColor: DARK_SCAFFOLD_BG,
  appBarTheme: const AppBarTheme(
        centerTitle: false,
        foregroundColor: COLOR_DARKER,
        color: Colors.transparent),
    textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: COLOR_DARKER, fontSize: 16))
);
