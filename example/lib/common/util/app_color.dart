import 'package:flutter/material.dart';

Color iconColor =
    // WidgetsBinding.instance?.window.platformBrightness == Brightness.dark
    //     ?
    Colors.white;
// : Colors.black;
ThemeMode currentMode = ThemeMode.dark;

void updateColor(ThemeMode mode) {
  iconColor = mode == ThemeMode.dark ? Colors.white : Colors.black;
  currentMode = mode;
  themeDefaultColor = mode == ThemeMode.dark
      ? Color.fromRGBO(245, 249, 255, 0.95)
      : Color.fromRGBO(29, 34, 41, 1);
  themeBottomSheetColor = mode == ThemeMode.dark
      ? Color.fromRGBO(20, 23, 28, 1)
      : Color.fromRGBO(245, 249, 255, 0.95);
  themeSurfaceColor = mode == ThemeMode.dark
      ? Color.fromRGBO(29, 34, 41, 1)
      : Color.fromRGBO(245, 249, 255, 0.95);
  themeSubHeadingColor =
      mode == ThemeMode.dark ? Color.fromRGBO(224, 236, 255, 0.8) : borderColor;

  themeScreenBackgroundColor =
      mode == ThemeMode.dark ? Color.fromRGBO(11, 13, 15, 1) : hmsWhiteColor;

  themeHintColor = mode == ThemeMode.dark
      ? Color.fromRGBO(195, 208, 229, 0.5)
      : hmsWhiteColor;

  themeHMSBorderColor =
      mode == ThemeMode.dark ? Color.fromRGBO(45, 52, 64, 1) : hmsWhiteColor;

  themeTileNameColor =
      mode == ThemeMode.dark ? Color.fromRGBO(0, 0, 0, 0.9) : hmsHintColor;

  themeDisabledTextColor = mode == ThemeMode.dark
      ? Color.fromRGBO(255, 255, 255, 0.48)
      : themeDefaultColor;
}

Color themeTileNameColor = Color.fromRGBO(0, 0, 0, 0.9);
Color themeHMSBorderColor = Color.fromRGBO(45, 52, 64, 1);
Color hmsHintColor = Color.fromRGBO(195, 208, 229, 0.5);
Color hmsWhiteColor = Color.fromRGBO(245, 249, 255, 0.95);
Color themeDefaultColor = Color.fromRGBO(245, 249, 255, 0.95);
Color themeSubHeadingColor = Color.fromRGBO(224, 236, 255, 0.8);
Color themeHintColor = Color.fromRGBO(195, 208, 229, 0.5);
Color themeSurfaceColor = Color.fromRGBO(29, 34, 41, 1);
Color themeDisabledTextColor = Color.fromRGBO(255, 255, 255, 0.48);
Color enabledTextColor = Color.fromRGBO(255, 255, 255, 0.98);
Color borderColor = Color.fromRGBO(45, 52, 64, 1);
Color dividerColor = Color.fromRGBO(27, 31, 38, 1);
Color buttonColor = Color.fromRGBO(71, 83, 102, 1);
Color defaultAvatarColor = Color.fromRGBO(101, 85, 193, 1);
Color buttonBackgroundColor = Color.fromRGBO(1, 13, 15, 1);
Color themeScreenBackgroundColor = Color.fromRGBO(11, 13, 15, 1);
Color errorColor = Color.fromRGBO(204, 82, 95, 1);
Color themeBottomSheetColor = Color.fromRGBO(20, 23, 28, 1);
Color hmsdefaultColor = Color.fromRGBO(36, 113, 237, 1);
Color popupButtonBorderColor = Color.fromRGBO(107, 125, 153, 1);
Color dialogcontentColor = Color.fromRGBO(145, 127, 129, 1);
