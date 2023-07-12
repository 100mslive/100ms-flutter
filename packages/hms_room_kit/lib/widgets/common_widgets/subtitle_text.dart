import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SubtitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;

  const SubtitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.4,
      this.lineHeight = 16,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w400,
      this.textOverflow = TextOverflow.ellipsis,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: textOverflow,
        textAlign: textAlign,
        style: GoogleFonts.inter(
            height: lineHeight! / fontSize!,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            color: textColor,
            fontWeight: fontWeight));
  }
}
