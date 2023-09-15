import 'package:flutter/material.dart';

/// [updateColor] is used to update the colors of the app based on the theme
/// [mode] is the current theme mode
void updateColor(ThemeMode mode) {
  iconColor = mode == ThemeMode.dark ? Colors.white : Colors.black;

  /// [themeDefaultColor] is the default color of the app
  themeDefaultColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(245, 249, 255, 0.95)
      : const Color.fromRGBO(29, 34, 41, 1);

  /// [themeBottomSheetColor] is the color of the bottom sheet
  themeBottomSheetColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(20, 23, 28, 1)
      : const Color.fromRGBO(245, 249, 255, 0.95);

  /// [themeSurfaceColor] is the color of the surface of the app
  themeSurfaceColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(29, 34, 41, 1)
      : const Color.fromRGBO(245, 249, 255, 0.95);

  /// [themeSubHeadingColor] is the color of the subheading
  themeSubHeadingColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(224, 236, 255, 0.8)
      : borderColor;

  /// [themeScreenBackgroundColor] is the color of the background of the app
  themeScreenBackgroundColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(11, 13, 15, 1)
      : hmsWhiteColor;

  /// [themeHintColor] is the color of the hint text
  themeHintColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(195, 208, 229, 0.5)
      : hmsWhiteColor;

  /// [themeHMSBorderColor] is the color of the border of the app
  themeHMSBorderColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(45, 52, 64, 1)
      : hmsWhiteColor;

  /// [themeTileNameColor] is the color of the name of the tile
  themeTileNameColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(0, 0, 0, 0.9)
      : hmsHintColor;

  /// [themeDisabledTextColor] is the color of the disabled text
  themeDisabledTextColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(255, 255, 255, 0.48)
      : themeDefaultColor;
}

/// [iconColor] should be set to white when the theme is dark and black when the theme is light
/// By default it is set to white since the default theme is dark.
Color iconColor = Colors.white;

/// [themeTileNameColor] is the color of the name of the tile
Color themeTileNameColor = const Color.fromRGBO(0, 0, 0, 0.9);

/// [themeHMSBorderColor] is the color of the border of the app
Color themeHMSBorderColor = const Color.fromRGBO(45, 52, 64, 1);

/// [hmsHintColor] is the color of the hint text
Color hmsHintColor = const Color.fromRGBO(195, 208, 229, 0.5);

/// [hmsWhiteColor] is the color of the white text
Color hmsWhiteColor = const Color.fromRGBO(245, 249, 255, 0.95);

/// [themeDefaultColor] is the default color of the app
Color themeDefaultColor = const Color.fromRGBO(245, 249, 255, 0.95);

/// [themeSubHeadingColor] is the color of the subheading
Color themeSubHeadingColor = const Color.fromRGBO(224, 236, 255, 0.8);

/// [themeHintColor] is the color of the hint text
Color themeHintColor = const Color.fromRGBO(195, 208, 229, 0.5);

/// [themeSurfaceColor] is the color of the surface of the app
Color themeSurfaceColor = const Color.fromRGBO(29, 34, 41, 1);

/// [themeDisabledTextColor] is the color of the disabled text
Color themeDisabledTextColor = const Color.fromRGBO(255, 255, 255, 0.48);

/// [enabledTextColor] is the color of the enabled text
Color enabledTextColor = const Color.fromRGBO(255, 255, 255, 0.98);

/// [borderColor] is the color of the border of the app
Color borderColor = const Color.fromRGBO(45, 52, 64, 1);

/// [dividerColor] is the color of the divider
Color dividerColor = const Color.fromRGBO(27, 31, 38, 1);

/// [defaultAvatarColor] is the color of the default avatar
Color defaultAvatarColor = const Color.fromRGBO(101, 85, 193, 1);

/// [themeScreenBackgroundColor] is the color of the background of the app
Color themeScreenBackgroundColor = const Color.fromRGBO(11, 13, 15, 1);

/// [themeButtonColor] is the color of the button
Color errorColor = const Color.fromRGBO(204, 82, 95, 1);

/// [themeBottomSheetColor] is the color of the bottom sheet
Color themeBottomSheetColor = const Color.fromRGBO(20, 23, 28, 1);

/// [hmsdefaultColor] is the default color of the app
Color hmsdefaultColor = const Color.fromRGBO(36, 113, 237, 1);

/// [popupButtonBorderColor] is the color of the border of the popup button
Color popupButtonBorderColor = const Color.fromRGBO(107, 125, 153, 1);

/// [dialogcontentColor] is the color of the content of the dialog
Color dialogcontentColor = const Color.fromRGBO(145, 127, 129, 1);

/// [moreSettingsButtonColor] is the color of the more settings button
Color moreSettingsButtonColor = const Color.fromRGBO(30, 35, 42, 1);

///This list contains colors for the avatar
///A random color gets picked based on the first alphabet of the name
List<Color> avatarColors = [
  Colors.purple,
  Colors.orange,
  Colors.teal,
  Colors.pink,
  Colors.blue,
  Colors.blueGrey,
  Colors.brown,
  Colors.indigo,
];
