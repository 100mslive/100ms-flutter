import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class HLSSubtitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;

  const HLSSubtitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.4,
      this.lineHeight = 1.5,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            height: lineHeight,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            color: textColor,
            fontWeight: fontWeight));
  }
}
