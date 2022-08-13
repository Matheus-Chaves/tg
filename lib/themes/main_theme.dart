import 'package:flutter/material.dart';

const bgGreen = Color.fromRGBO(7, 141, 109, 1);

ThemeData mainTheme = ThemeData(
  primaryColor: bgGreen,
  fontFamily: 'Roboto',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: bgGreen,
    secondary: bgGreen,
  ),
);
