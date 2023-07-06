import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/subheading_text.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';

class HLSWaitingUI extends StatelessWidget {
  const HLSWaitingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "packages/hmssdk_uikit/lib/assets/icons/time.svg",
          height: 80,
          width: 80,
        ),
        const SizedBox(
          height: 16,
        ),
        TitleText(
          text: "Class hasn’t started yet",
          textColor: onSurfaceHighEmphasis,
          fontSize: 28,
          lineHeight: 32,
          letterSpacing: 0.25,
        ),
        const SizedBox(
          height: 5,
        ),
        SubheadingText(
            text: "Please wait for the teacher to start the class.",
            textColor: onSurfaceMediumEmphasis)
      ],
    );
  }
}
