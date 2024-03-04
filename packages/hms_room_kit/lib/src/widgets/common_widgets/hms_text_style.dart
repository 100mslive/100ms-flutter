///Package imports
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

///[HMSTextStyle] returns a text style
///TextStyle is returned on the basis of the font family selected on the prebuilt dashboard
///If no font family is selected, then the default font family returned is Inter
///It takes following parameters:
///[fontSize] - The size of the font
///[color] - The color of the text
///[fontWeight] - The weight of the font
///[fontStyle] - The style of the font
///[letterSpacing] - The spacing between the letters
///[height] - The height of the line
class HMSTextStyle {
  static TextStyle setTextStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
  }) {
    switch (HMSRoomLayout.roleLayoutData?.typography?.typography) {
      case 'Roboto':
        return GoogleFonts.roboto(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
      case 'Lato':
        return GoogleFonts.lato(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
      case 'Montserrat':
        return GoogleFonts.montserrat(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
      case 'Open Sans':
        return GoogleFonts.openSans(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
      case 'IBM Plex Sans':
        return GoogleFonts.ibmPlexSans(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
      default:
        return GoogleFonts.inter(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        );
    }
  }
}
