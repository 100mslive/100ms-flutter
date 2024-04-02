///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[LiveBadge] renders the badge based on the text and colors provided.
///By default it renders a live badge as the name suggests.
///It also provides parameters to configure the text, color and size of the badge
class LiveBadge extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? badgeColor;
  final String? text;
  const LiveBadge(
      {super.key, this.height, this.width, this.badgeColor, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 24,
        width: width ?? 43,
        decoration: BoxDecoration(
            color: badgeColor ?? HMSThemeColors.alertErrorDefault,
            borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: HMSTitleText(
              text: text ?? "LIVE",
              fontSize: 10,
              lineHeight: 16,
              letterSpacing: 1.5,
              textColor: HMSThemeColors.alertErrorBrighter),
        ));
  }
}
