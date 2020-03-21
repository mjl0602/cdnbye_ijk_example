import 'package:cdnbye_ijk_example/style/color.dart';
import 'package:cdnbye_ijk_example/style/size.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData standard = ThemeData(
    brightness: Brightness.light,
    hintColor: ColorPlate.red,
    accentColor: ColorPlate.mainColor,
    accentColorBrightness: Brightness.dark,
    fontFamily: 'MyraidPro',
    textTheme: TextTheme(
      //设置Material的默认字体样式
      body1: TextStyle(
        color: ColorPlate.darkGray,
        fontSize: SysSize.normal,
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: ColorPlate.mainColor,
    ),
    primaryColor: ColorPlate.mainColor,
    primaryColorBrightness: Brightness.dark,
    scaffoldBackgroundColor: ColorPlate.lightGray,
  );
}
