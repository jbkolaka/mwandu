import 'package:flutter/material.dart';
import './fonts.style.dart';

abstract class CTypography {
  static const cTextTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: CFonts.primaryLight),
    displayMedium: TextStyle(fontFamily: CFonts.primaryLight),
    displaySmall: TextStyle(fontFamily: CFonts.primaryRegular),
    headlineLarge: TextStyle(fontFamily: CFonts.primaryRegular),
    headlineMedium: TextStyle(fontFamily: CFonts.primaryRegular),
    headlineSmall: TextStyle(fontFamily: CFonts.primaryMedium),
    titleLarge: TextStyle(fontFamily: CFonts.primaryRegular),
    titleMedium: TextStyle(fontFamily: CFonts.primaryMedium),
    bodyLarge: TextStyle(fontFamily: CFonts.primaryRegular),
    bodyMedium: TextStyle(fontFamily: CFonts.primaryRegular),
    labelLarge: TextStyle(fontFamily: CFonts.primaryMedium),
    bodySmall: TextStyle(fontFamily: CFonts.primaryRegular),
    labelSmall: TextStyle(fontFamily: CFonts.primaryRegular),
  );
}
