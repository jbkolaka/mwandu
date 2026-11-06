import './fonts.style.dart';
import './colors.style.dart';
import './typography.style.dart';
import '../enums/index.dart';

import 'package:flutter/material.dart';

class CThemes {
  static ThemeData getTheme(CTheme theme) {
    if (theme == CTheme.gray100) return _gray100;

    return _gray100;
  }

  static final _gray100 = ThemeData(
    primaryColor: CColors.blue60,
    canvasColor: CColors.gray100,
    scaffoldBackgroundColor: CColors.gray100,
    highlightColor: CColors.blue70,
    indicatorColor: CColors.blue70,
    hintColor: CColors.gray10,
    fontFamily: CFonts.primaryRegular,
    iconTheme: IconThemeData(color: CColors.gray10),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: CColors.gray10,
      selectionColor: CColors.blue70,
      selectionHandleColor: CColors.blue70,
    ),
    textTheme: CTypography.cTextTheme.apply(
      displayColor: CColors.gray10,
      bodyColor: CColors.gray10,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: CColors.gray70),
  );
}
