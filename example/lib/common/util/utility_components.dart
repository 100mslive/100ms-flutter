import 'package:flutter/material.dart';

class UtilityComponents {
  static void showSnackBarWithString(event, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event)));
  }
}
