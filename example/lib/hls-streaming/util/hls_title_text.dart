import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HLSTitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;

  const HLSTitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.5,
      this.lineHeight = 24,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w600,
      this.textOverflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: textOverflow,
        style: GoogleFonts.inter(
            color: textColor,
            height: lineHeight! / fontSize!,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight));
  }
}
