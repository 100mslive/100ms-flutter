import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

class HLSWaitingUI extends StatelessWidget {
  const HLSWaitingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "packages/hms_room_kit/lib/src/assets/icons/time.svg",
          height: 80,
          width: 80,
        ),
        const SizedBox(
          height: 16,
        ),
        HMSTitleText(
          text: "Class hasn’t started yet",
          textColor: onSurfaceHighEmphasis,
          fontSize: 28,
          lineHeight: 32,
          letterSpacing: 0.25,
        ),
        const SizedBox(
          height: 5,
        ),
        HMSSubheadingText(
            text: "Please wait for the teacher to start the class.",
            textColor: onSurfaceMediumEmphasis)
      ],
    );
  }
}
