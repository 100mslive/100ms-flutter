//Package imports
import 'package:flutter/material.dart';

class Utilities {
  static String getAvatarTitle(String name) {
    List<String>? parts = name.split(" ");
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
    return name;
  }

  static Color getBackgroundColour(String name) {
    return Utilities
        .colors[name.toLowerCase().codeUnitAt(0) % Utilities.colors.length];
  }

  static List<Color> colors = [
    Color(0xFFFAC919),
    Color(0xFF00AE63),
    Color(0xFF6554C0),
    Color(0xFFF69133),
    Color(0xFF8FF5FB)
  ];
}
