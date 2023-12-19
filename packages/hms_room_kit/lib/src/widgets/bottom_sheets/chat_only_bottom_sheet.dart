///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[ChatOnlyBottomSheet] is a bottom sheet that is used to render the bottom sheet to show chat only when participants
///list is disabled from dashboard
class ChatOnlyBottomSheet extends StatelessWidget {
  const ChatOnlyBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HMSSubheadingText(
                  text: HMSRoomLayout.chatData?.chatTitle ?? "Chat",
                  textColor: HMSThemeColors.onSurfaceHighEmphasis,
                  fontWeight: FontWeight.w600,
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/settings.svg",
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceLowEmphasis, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const HMSCrossButton(),
              ],
            ),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: ChatBottomSheet(),
            ))
          ],
        ),
      ),
    ));
  }
}
