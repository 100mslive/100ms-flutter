import 'dart:math';
import 'package:flutter/material.dart';

class Item {
  static final random = Random();
  final size = random.nextInt(5) + 15;
  String emoji = "";

  final Alignment alignment =
      Alignment(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1);
  Item({required this.emoji});
}
