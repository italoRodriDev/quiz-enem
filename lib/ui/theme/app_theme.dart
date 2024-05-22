import 'package:batevolta/core/colors.dart';
import 'package:batevolta/core/fonts/fonts.dart';
import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primary,
    secondaryHeaderColor: AppColor.secondary,
    scaffoldBackgroundColor: AppColor.background,
    fontFamily: AppFont.Poppins,
    textTheme: const TextTheme(
      headline1: TextStyle(
          fontSize: 72.0, fontFamily: AppFont.Poppins, fontWeight: FontWeight.bold),
      headline6: TextStyle(
          fontSize: 36.0, fontFamily: AppFont.Poppins, fontStyle: FontStyle.normal),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: AppFont.Poppins),
    ),
    // -> Tema do checkbox
    checkboxTheme:
        CheckboxThemeData(fillColor: MaterialStateColor.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return AppColor.secondary;
      } else {
        return Colors.black;
      }
    })));
