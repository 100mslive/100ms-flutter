///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';

///[HMSSubtitleText] returns a text widget with the default theme
///The paramters and their default values are as follows:
///[text] - The text to be displayed, this is a required parameter
///[textColor] - The color of the text, this is a required parameter
///[letterSpacing] - The spacing between the letters, default value is 0.4
///[lineHeight] - The height of the line, default value is 16
///[fontSize] - The size of the font, default value is 14
///[fontWeight] - The weight of the font, default value is FontWeight.w400
///[textOverflow] - The overflow of the text, default value is TextOverflow.ellipsis
///[textAlign] - The alignment of the text, default value is TextAlign.left
class HMSSubtitleText extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? letterSpacing;
  final double? lineHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final int? maxLines;

  const HMSSubtitleText(
      {Key? key,
      required this.text,
      required this.textColor,
      this.letterSpacing = 0.4,
      this.lineHeight = 16,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w400,
      this.textOverflow = TextOverflow.ellipsis,
      this.textAlign,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: textOverflow,
        softWrap: true,
        maxLines: maxLines,
        textAlign: textAlign,
        style: HMSTextStyle.setTextStyle(
          height: lineHeight! / fontSize!,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          color: textColor,
          fontWeight: fontWeight,
        ));
  }
}
