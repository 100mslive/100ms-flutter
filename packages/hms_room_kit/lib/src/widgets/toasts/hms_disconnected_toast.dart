///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';

///[HMSDisconnectedToast] renders the toast when a user gets disconnected and the user needs to rejoin
class HMSDisconnectedToast extends StatelessWidget {
  final String errorDescription;
  final Function? onLeavePressed;
  const HMSDisconnectedToast(
      {super.key,
      this.onLeavePressed,
      this.errorDescription = "Reconnection Failed"});

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: HMSSubheadingText(
          maxLines: 2,
          text: errorDescription,
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
      action: HMSToastButton(
        buttonTitle: "Leave",
        action: () {
          if (onLeavePressed != null) {
            onLeavePressed!();
          }
        },
        buttonColor: HMSThemeColors.alertErrorDefault,
        textColor: HMSThemeColors.alertErrorBrighter,
      ),
    );
  }
}
