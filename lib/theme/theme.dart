import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.indigo,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade800,
    ));

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
        background: Color(0xff191C1B),
        primary: Color(0xff53DBC9),
        primaryContainer: Color(0xff005048),
        onPrimaryContainer: Color(0xff92F4E5),
        onPrimary: Color(0xff003731),
        secondary: Color(0xffB1CCC6),
        secondaryContainer: Color(0xff334B47),
        onSecondary: Color(0xff1C3531),
        onSecondaryContainer: Color(0xffCCE8E2),
        tertiary: Color(0xffADCAE6),
        inversePrimary: Color(0xff006A60),
        shadow: Colors.white));
