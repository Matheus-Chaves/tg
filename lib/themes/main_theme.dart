import 'package:flutter/material.dart';
import 'color_schemes.g.dart';

const green = Color(0xFF078D6D);

ThemeData mainTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  // colorScheme: ColorScheme.fromSeed(
  //   seedColor: green,
  //   brightness: Brightness.light,
  //   primary: Colors.black87,
  //   secondary: green,
  //   background: green,
  // ),
  fontFamily: 'Roboto',
  textTheme: const TextTheme().copyWith(
      //titleLarge: const TextStyle(color: Colors.white),
      //bodyMedium: const TextStyle(color: Colors.white),
      ),
);
