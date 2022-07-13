import 'package:flutter/material.dart';

Color iconColor =
    // WidgetsBinding.instance?.window.platformBrightness == Brightness.dark
    //     ?
    Colors.white;
// : Colors.black;

void updateColor(ThemeMode mode) {
  iconColor = mode == ThemeMode.dark ? Colors.white : Colors.black;
}

Color defaultColor = Color.fromRGBO(245, 249, 255, 0.95);
Color subHeadingColor = Color.fromRGBO(224, 236, 255, 0.8);
Color hintColor = Color.fromRGBO(195, 208, 229, 0.5);
Color surfaceColor = Color.fromRGBO(29, 34, 41, 1);
Color disabledTextColor = Color.fromRGBO(255, 255, 255, 0.48);
Color enabledTextColor = Color.fromRGBO(255, 255, 255, 0.98);
Color borderColor = Color.fromRGBO(45, 52, 64, 1);
Color dividerColor = Color.fromRGBO(27, 31, 38, 1);
