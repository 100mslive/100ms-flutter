import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HLSTitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;

  const HLSTitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.5,
      this.lineHeight = 1.5,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w600})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            color: textColor,
            height: 1.5,
            fontSize: 16,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600));
  }
}
