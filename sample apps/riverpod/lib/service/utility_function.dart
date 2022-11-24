//Package imports
import 'package:flutter/material.dart';

class Utilities {
  static String getAvatarTitle(String name) {
    List<String>? parts = name.trim().split(" ");
    if (parts.length == 1) {
      name = parts[0][0];
    } else if (parts.length >= 2) {
      name = parts[0][0];
      if (parts[1] == "" || parts[1] == " ") {
        name += parts[0][1];
      } else {
        name += parts[1][0];
      }
    }
    return name.toUpperCase();
  }

  static Color getBackgroundColour(String name) {
    return Utilities
        .colors[name.toUpperCase().codeUnitAt(0) % Utilities.colors.length];
  }

  static List<Color> colors = [
    const Color(0xFFFAC919),
    const Color(0xFF00AE63),
    const Color(0xFF6554C0),
    const Color(0xFFF69133),
    const Color(0xFF8FF5FB)
  ];

  static double getRatio(Size size, BuildContext context) {
    EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return (size.height -
            viewPadding.top -
            viewPadding.bottom -
            kToolbarHeight) /
        (size.width - viewPadding.left - viewPadding.right);
  }
}
