import 'package:flutter/material.dart';

const green = Color.fromRGBO(7, 141, 109, 1);

ThemeData mainTheme = ThemeData(
  primaryColor: green,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.black87,
    secondary: green,
    background: green,
  ),
  textTheme: const TextTheme().copyWith(
      //titleLarge: const TextStyle(color: Colors.white),
      //bodyMedium: const TextStyle(color: Colors.white),
      ),
);
