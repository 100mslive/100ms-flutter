import 'package:flutter/material.dart';

/// The [HMSThemeColors] class contains the color constants used in the UI
class HMSThemeColors {
  static Color primaryDefault = const Color(0xFF2572ED);
  static Color primaryBright = const Color(0xFF538DFF);
  static Color primaryDim = const Color(0xFF002D6D);
  static Color primaryDisabled = const Color(0xFF004299);

  static Color onPrimaryHighEmphasis = const Color(0xFFFFFFFF);
  static Color onPrimaryMediumEmphasis = const Color(0xFFCCDAFF);
  static Color onPrimaryLowEmphasis = const Color(0xFF84AAFF);

  static Color secondaryDefault = const Color(0xFF444954);
  static Color secondaryBright = const Color(0xFF70778B);
  static Color secondaryDim = const Color(0xFF293042);
  static Color secondaryDisabled = const Color(0xFF404759);

  static Color onSecondaryHighEmphasis = const Color(0xFFFFFFFF);
  static Color onSecondaryMediumEmphasis = const Color(0xFFD3D9F0);
  static Color onSecondaryLowEmphasis = const Color(0xFFA4ABC0);

  static Color backgroundDefault = const Color(0xFF0B0E15);
  static Color backgroundDim = const Color(0xFF000000);

  static Color surfaceDefault = const Color(0xFF191B23);
  static Color surfaceBright = const Color(0xFF272A31);
  static Color surfaceBrighter = const Color(0xFF2E3038);
  static Color surfaceDim = const Color(0xFF11131A);

  static Color onSurfaceHighEmphasis = const Color(0xFFEFF0FA);
  static Color onSurfaceMediumEmphasis = const Color(0xFFC5C6D0);
  static Color onSurfaceLowEmphasis = const Color(0xFF8F9099);

  static Color alertErrorDefault = const Color(0xFFC74E5B);
  static Color alertErrorBright = const Color(0xFFFFB2B6);
  static Color alertErrorBrighter = const Color(0xFFFFEDEC);
  static Color alertErrorDim = const Color(0xFF270005);

  static Color alertSuccess = const Color(0xFF36B37E);
  static Color alertWarning = const Color(0xFFFFAB00);

  static Color borderDefault = const Color(0xFF1D1F27);
  static Color borderBright = const Color(0xFF272A31);
  static Color borderPrimary = const Color(0xFF2572ED);

  static Color baseBlack = const Color(0xFF000000);
  static Color baseWhite = const Color(0xFFFFFFFF);

  /// Returns the color from the given [hexColor]
  static int _getColorFromHex(String hexColor) {
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

  /// Applies the layout colors from the given [palette]
  static void applyLayoutColors(Map<String, String>? palette) {
    palette?.forEach((key, value) {
      switch (key) {
        case "primary_default":
          primaryDefault = Color(_getColorFromHex(value));
          break;
        case "primary_bright":
          primaryBright = Color(_getColorFromHex(value));
          break;
        case "primary_dim":
          primaryDim = Color(_getColorFromHex(value));
          break;
        case "primary_disabled":
          primaryDisabled = Color(_getColorFromHex(value));
          break;
        case "on_primary_high":
          onPrimaryHighEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_primary_medium":
          onPrimaryMediumEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_primary_low":
          onPrimaryLowEmphasis = Color(_getColorFromHex(value));
          break;
        case "secondary_default":
          secondaryDefault = Color(_getColorFromHex(value));
          break;
        case "secondary_bright":
          secondaryBright = Color(_getColorFromHex(value));
          break;
        case "secondary_dim":
          secondaryDim = Color(_getColorFromHex(value));
          break;
        case "secondary_disabled":
          secondaryDisabled = Color(_getColorFromHex(value));
          break;
        case "on_secondary_high":
          onSecondaryHighEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_secondary_medium":
          onSecondaryMediumEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_secondary_low":
          onSecondaryLowEmphasis = Color(_getColorFromHex(value));
          break;
        case "background_default":
          backgroundDefault = Color(_getColorFromHex(value));
          break;
        case "background_dim":
          backgroundDim = Color(_getColorFromHex(value));
          break;
        case "surface_default":
          surfaceDefault = Color(_getColorFromHex(value));
          break;
        case "surface_bright":
          surfaceBright = Color(_getColorFromHex(value));
          break;
        case "surface_brighter":
          surfaceBrighter = Color(_getColorFromHex(value));
          break;
        case "surface_dim":
          surfaceDim = Color(_getColorFromHex(value));
          break;
        case "on_surface_high":
          onSurfaceHighEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_surface_medium":
          onSurfaceMediumEmphasis = Color(_getColorFromHex(value));
          break;
        case "on_surface_low":
          onSurfaceLowEmphasis = Color(_getColorFromHex(value));
          break;
        case "alert_error_default":
          alertErrorDefault = Color(_getColorFromHex(value));
          break;
        case "alert_error_bright":
          alertErrorBright = Color(_getColorFromHex(value));
          break;
        case "alert_error_brighter":
          alertErrorBrighter = Color(_getColorFromHex(value));
          break;
        case "alert_error_dim":
          alertErrorDim = Color(_getColorFromHex(value));
          break;
        case "alert_success":
          alertSuccess = Color(_getColorFromHex(value));
          break;
        case "alert_warning":
          alertWarning = Color(_getColorFromHex(value));
          break;
        case "border_default":
          borderDefault = Color(_getColorFromHex(value));
          break;
        case "border_bright":
          borderBright = Color(_getColorFromHex(value));
          break;
        case "base_black":
          baseBlack = Color(_getColorFromHex(value));
          break;
        case "base_white":
          baseWhite = Color(_getColorFromHex(value));
          break;
      }
    });
  }

  /// Resets the layout colors to the default values
  static void resetLayoutColors() {
    primaryDefault = const Color(0xFF2572ED);
    primaryBright = const Color(0xFF538DFF);
    primaryDim = const Color(0xFF002D6D);
    primaryDisabled = const Color(0xFF004299);

    onPrimaryHighEmphasis = const Color(0xFFFFFFFF);
    onPrimaryMediumEmphasis = const Color(0xFFCCDAFF);
    onPrimaryLowEmphasis = const Color(0xFF84AAFF);

    secondaryDefault = const Color(0xFF444954);
    secondaryBright = const Color(0xFF70778B);
    secondaryDim = const Color(0xFF293042);
    secondaryDisabled = const Color(0xFF404759);

    onSecondaryHighEmphasis = const Color(0xFFFFFFFF);
    onSecondaryMediumEmphasis = const Color(0xFFD3D9F0);
    onSecondaryLowEmphasis = const Color(0xFFA4ABC0);

    backgroundDefault = const Color(0xFF0B0E15);
    backgroundDim = const Color(0xFF000000);

    surfaceDefault = const Color(0xFF191B23);
    surfaceBright = const Color(0xFF272A31);
    surfaceBrighter = const Color(0xFF2E3038);
    surfaceDim = const Color(0xFF11131A);

    onSurfaceHighEmphasis = const Color(0xFFEFF0FA);
    onSurfaceMediumEmphasis = const Color(0xFFC5C6D0);
    onSurfaceLowEmphasis = const Color(0xFF8F9099);

    alertErrorDefault = const Color(0xFFC74E5B);
    alertErrorBright = const Color(0xFFFFB2B6);
    alertErrorBrighter = const Color(0xFFFFEDEC);
    alertErrorDim = const Color(0xFF270005);

    alertSuccess = const Color(0xFF36B37E);
    alertWarning = const Color(0xFFFFAB00);

    borderDefault = const Color(0xFF1D1F27);
    borderBright = const Color(0xFF272A31);
    borderPrimary = const Color(0xFF2572ED);

    baseBlack = const Color(0xFF000000);
    baseWhite = const Color(0xFFFFFFFF);
  }
}
