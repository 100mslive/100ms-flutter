library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[HLSWaitingUI] is the UI that is shown when the HLS stream is not started
class HLSWaitingUI extends StatelessWidget {
  const HLSWaitingUI({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: HMSThemeColors.surfaceDefault,
            child: SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/live.svg",
              height: 56,
              width: 56,
              colorFilter: ColorFilter.mode(
                  HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          HMSTitleText(
            text: "Stream yet to start",
            textColor: HMSThemeColors.onSurfaceHighEmphasis,
            fontSize: 24,
            lineHeight: 32,
            letterSpacing: 0.25,
          ),
          const SizedBox(
            height: 8,
          ),
          HMSSubheadingText(
              text: "Sit back and relax",
              fontSize: 16,
              lineHeight: 24,
              letterSpacing: 0.5,
              textColor: HMSThemeColors.onSurfaceMediumEmphasis)
        ],
      ),
    );
  }
}
