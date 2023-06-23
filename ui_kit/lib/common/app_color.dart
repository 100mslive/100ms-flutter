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
  themeSubHeadingColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(224, 236, 255, 0.8)
      : borderColor;

  themeScreenBackgroundColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(11, 13, 15, 1)
      : hmsWhiteColor;

  themeHintColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(195, 208, 229, 0.5)
      : hmsWhiteColor;

  themeHMSBorderColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(45, 52, 64, 1)
      : hmsWhiteColor;

  themeTileNameColor = mode == ThemeMode.dark
      ? const Color.fromRGBO(0, 0, 0, 0.9)
      : hmsHintColor;

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

int _getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }

  final hexNum = int.parse(hexColor, radix: 16);

  if (hexNum == 0) {
    return 0xff000000;
  }

  return hexNum;
}

Color primaryDefault = Color(_getColorFromHex("#2572ED"));
Color primaryBright = Color(_getColorFromHex("#538DFF"));
Color primaryDim = Color(_getColorFromHex("#002D6D"));
Color primaryDisabled = Color(_getColorFromHex("#004299"));

Color onPrimaryHighEmphasis = Color(_getColorFromHex("#FFFFFF"));
Color onPrimaryMediumEmphasis = Color(_getColorFromHex("#CCDAFF"));
Color onPrimaryLowEmphasis = Color(_getColorFromHex("#84AAFF"));

Color secondaryDefault = Color(_getColorFromHex("#444954"));
Color secondaryBright = Color(_getColorFromHex("#70778B"));
Color secondaryDim = Color(_getColorFromHex("#293042"));
Color secondaryDisabled = Color(_getColorFromHex("#404759"));

Color onSecondaryHighEmphasis = Color(_getColorFromHex("#FFFFFF"));
Color onSecondaryMediumEmphasis = Color(_getColorFromHex("#D3D9F0"));
Color onSecondaryLowEmphasis = Color(_getColorFromHex("#A4ABC0"));

Color backgroundDefault = Color(_getColorFromHex("#0B0E15"));
Color backgroundDim = Color(_getColorFromHex("#000000"));

Color surfaceDefault = Color(_getColorFromHex("#191B23"));
Color surfaceBright = Color(_getColorFromHex("#272A31"));
Color surfaceBrighter = Color(_getColorFromHex("#2E3038"));
Color surfaceDim = Color(_getColorFromHex("#11131A"));

Color onSurfaceHighEmphasis = Color(_getColorFromHex("#EFF0FA"));
Color onSurfaceMediumEmphasis = Color(_getColorFromHex("#C5C6D0"));
Color onSurfaceLowEmphasis = Color(_getColorFromHex("#8F9099"));

Color alertErrorDefault = Color(_getColorFromHex("#C74E5B"));
Color alertErrorBright = Color(_getColorFromHex("#FFB2B6"));
Color alertErrorBrighter = Color(_getColorFromHex("#FFEDEC"));
Color alertErrorDim = Color(_getColorFromHex("#270005"));

Color alertSuccess = Color(_getColorFromHex("#36B37E"));
Color alertWarning = Color(_getColorFromHex("#FFAB00"));

Color borderDefault = Color(_getColorFromHex("#1D1F27"));
Color borderBright = Color(_getColorFromHex("#272A31"));
Color borderPrimary = Color(_getColorFromHex("#2572ED"));

Color baseBlack = Color(_getColorFromHex("#000000"));
Color baseWhite = Color(_getColorFromHex("#FFFFFF"));
