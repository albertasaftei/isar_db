import 'package:flutter/material.dart';
import 'package:isar_db/utils/constants/colors.dart';
import 'package:isar_db/utils/constants/sizes.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    titleLarge: const TextStyle().copyWith(
        fontSize: TSizes.titleLarge,
        fontWeight: FontWeight.bold,
        color: TColors.textPrimary),
    titleMedium: const TextStyle().copyWith(
        fontSize: TSizes.titleMedium,
        fontWeight: FontWeight.bold,
        color: TColors.textPrimary),
    titleSmall: const TextStyle().copyWith(
        fontSize: TSizes.titleSmall,
        fontWeight: FontWeight.bold,
        color: TColors.textPrimary),
    bodyLarge: const TextStyle()
        .copyWith(fontSize: TSizes.bodyLarge, color: TColors.textPrimary),
    bodyMedium: const TextStyle()
        .copyWith(fontSize: TSizes.bodyMedium, color: TColors.textPrimary),
    bodySmall: const TextStyle()
        .copyWith(fontSize: TSizes.bodySmall, color: TColors.textPrimary),
  ),
  colorScheme: const ColorScheme.light(
    background: TColors.backgroundPrimary,
    primary: TColors.primary,
    secondary: TColors.secondary,
    inversePrimary: TColors.inversePrimary,
    error: TColors.error,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: TColors.buttonPrimary,
      foregroundColor: TColors.textWhite,
      textStyle: const TextStyle().copyWith(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 1,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    titleLarge: const TextStyle().copyWith(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    titleMedium: const TextStyle().copyWith(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: const TextStyle().copyWith(fontSize: 18, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: 16, color: Colors.white),
    bodySmall: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
  ),
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
      shadow: Colors.white),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: const Color(0xff006A60),
      foregroundColor: Colors.white,
      textStyle: const TextStyle().copyWith(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xff006A60),
    foregroundColor: Colors.white,
  ),
);
