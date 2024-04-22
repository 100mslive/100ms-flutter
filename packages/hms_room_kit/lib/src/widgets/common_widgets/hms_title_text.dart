///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';

///[HMSTitleText] is a widget that is used to render the title text
///It takes following parameters:
///[text] is the text to be rendered, this is a required parameter
///[textColor] is the color of the text, this is a required parameter
///[letterSpacing] is the spacing between the letters, default value is 0.5
///[lineHeight] is the height of the line, default value is 24
///[fontSize] is the size of the font, default value is 16
///[fontWeight] is the weight of the font, default value is FontWeight.w600
///[textOverflow] is the overflow of the text, default value is TextOverflow.ellipsis
///[maxLines] are the max number of lines that HMSTitleText will render after that it will overflow
class HMSTitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const HMSTitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.5,
      this.lineHeight = 24,
      this.fontSize = 16,
      this.fontWeight = FontWeight.w600,
      this.textOverflow = TextOverflow.ellipsis,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: textOverflow,
        maxLines: maxLines,
        style: HMSTextStyle.setTextStyle(
            color: textColor,
            height: lineHeight! / fontSize!,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight));
  }
}
