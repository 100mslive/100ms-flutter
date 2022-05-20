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
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.teal,
    Colors.green,
    Colors.deepOrange,
  ];
}
