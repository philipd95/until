import 'package:flutter/material.dart';
import 'package:until/src/util/until_colors.dart';

const fontFamily = "helvetica";

ThemeData appTheme = ThemeData(
  fontFamily: fontFamily,
  scaffoldBackgroundColor: UntilColors.white,
  backgroundColor: UntilColors.white,
  appBarTheme: AppBarTheme(
      backgroundColor: UntilColors.white,
      elevation: 0,
      shadowColor: UntilColors.white,
      foregroundColor: UntilColors.black),
  iconTheme: IconThemeData(color: UntilColors.black),
  colorScheme: ColorScheme.light(
    primary: UntilColors.black,
    background: UntilColors.white,
  ),
  textTheme: TextTheme(
    button: TextStyle(
      color: UntilColors.black,
      fontSize: 14,
    ),
    headline1: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: UntilColors.black,
    ),
    headline5: TextStyle(
      fontSize: 16,
      color: UntilColors.black,
    ),
    headline6: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: UntilColors.black,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      color: UntilColors.black,
    ),
  ),
);
