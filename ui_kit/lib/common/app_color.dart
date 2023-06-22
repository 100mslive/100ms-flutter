import 'package:flutter/material.dart';

Color iconColor =
    // WidgetsBinding.instance?.window.platformBrightness == Brightness.dark
    //     ?
    Colors.white;
// : Colors.black;

void updateColor(ThemeMode mode) {
  iconColor = mode == ThemeMode.dark ? Colors.white : Colors.black;

  themeDefaultColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(245, 249, 255, 0.95)
      : const Color.fromRGBO(29, 34, 41, 1);
  themeBottomSheetColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(20, 23, 28, 1)
      : const Color.fromRGBO(245, 249, 255, 0.95);
  themeSurfaceColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(29, 34, 41, 1)
      : const Color.fromRGBO(245, 249, 255, 0.95);
  themeSubHeadingColor =
      mode == ThemeMode.dark ? const Color.fromRGBO(224, 236, 255, 0.8) : borderColor;

  themeScreenBackgroundColor =
      mode == ThemeMode.dark ? const Color.fromRGBO(11, 13, 15, 1) : hmsWhiteColor;

  themeHintColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(195, 208, 229, 0.5)
      : hmsWhiteColor;

  themeHMSBorderColor =
      mode == ThemeMode.dark ? const Color.fromRGBO(45, 52, 64, 1) : hmsWhiteColor;

  themeTileNameColor =
      mode == ThemeMode.dark ? const Color.fromRGBO(0, 0, 0, 0.9) : hmsHintColor;

  themeDisabledTextColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(255, 255, 255, 0.48)
      : themeDefaultColor;
}

Color themeTileNameColor = const Color.fromRGBO(0, 0, 0, 0.9);
Color themeHMSBorderColor = const Color.fromRGBO(45, 52, 64, 1);
Color hmsHintColor = const Color.fromRGBO(195, 208, 229, 0.5);
Color hmsWhiteColor = const Color.fromRGBO(245, 249, 255, 0.95);
Color themeDefaultColor = const Color.fromRGBO(245, 249, 255, 0.95);
Color themeSubHeadingColor = const Color.fromRGBO(224, 236, 255, 0.8);
Color themeHintColor = const Color.fromRGBO(195, 208, 229, 0.5);
Color themeSurfaceColor = const Color.fromRGBO(29, 34, 41, 1);
Color themeDisabledTextColor = const Color.fromRGBO(255, 255, 255, 0.48);
Color enabledTextColor = const Color.fromRGBO(255, 255, 255, 0.98);
Color borderColor = const Color.fromRGBO(45, 52, 64, 1);
Color dividerColor = const Color.fromRGBO(27, 31, 38, 1);
Color defaultAvatarColor = const Color.fromRGBO(101, 85, 193, 1);
Color themeScreenBackgroundColor = const Color.fromRGBO(11, 13, 15, 1);
Color errorColor = const Color.fromRGBO(204, 82, 95, 1);
Color themeBottomSheetColor = const Color.fromRGBO(20, 23, 28, 1);
Color hmsdefaultColor = const Color.fromRGBO(36, 113, 237, 1);
Color popupButtonBorderColor = const Color.fromRGBO(107, 125, 153, 1);
Color dialogcontentColor = const Color.fromRGBO(145, 127, 129, 1);
Color moreSettingsButtonColor = const Color.fromRGBO(30, 35, 42, 1);
