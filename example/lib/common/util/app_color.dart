import 'package:flutter/material.dart';

Color iconColor =
    WidgetsBinding.instance?.window.platformBrightness == Brightness.dark
        ? Colors.white
        : Colors.black;

void updateColor(ThemeMode mode) {
  iconColor = mode == ThemeMode.dark ? Colors.white : Colors.black;
}
