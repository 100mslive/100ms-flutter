///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';

///[ChatOnlyBottomSheet] is a bottom sheet that is used to render the bottom sheet to show chat only when participants
///list is disabled from dashboard
class ChatOnlyBottomSheet extends StatefulWidget {
  const ChatOnlyBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChatOnlyBottomSheet> createState() => _ChatOnlyBottomSheetState();
}

class _ChatOnlyBottomSheetState extends State<ChatOnlyBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

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
                if (HMSRoomLayout.chatData?.realTimeControls?.canDisableChat ??
                    false)
                  PopupMenuButton(
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      color: HMSThemeColors.surfaceDefault,
                      child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/settings.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceLowEmphasis,
                              BlendMode.srcIn)),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 1,
                                child: Row(children: [
                                  SvgPicture.asset(
                                      "packages/hms_room_kit/lib/src/assets/icons/${context.read<MeetingStore>().chatControls["enabled"] ? "recording_paused" : "resume"}.svg",
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                          HMSThemeColors.onSurfaceHighEmphasis,
                                          BlendMode.srcIn)),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  HMSTitleText(
                                    text: context
                                            .read<MeetingStore>()
                                            .chatControls["enabled"]
                                        ? "Pause Chat"
                                        : "Resume Chat",
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    fontSize: 14,
                                    lineHeight: 20,
                                    letterSpacing: 0.1,
                                  ),
                                ]))
                          ],
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            context
                                .read<MeetingStore>()
                                .setSessionMetadataForKey(
                                    key:
                                        SessionStoreKeyValues.getNameFromMethod(
                                            SessionStoreKey.chatState),
                                    metadata: {
                                  "enabled": context
                                          .read<MeetingStore>()
                                          .chatControls["enabled"]
                                      ? false
                                      : true,
                                  "updatedBy": {
                                    "peerID": context
                                        .read<MeetingStore>()
                                        .localPeer
                                        ?.peerId,
                                    "userID": context
                                        .read<MeetingStore>()
                                        .localPeer
                                        ?.customerUserId,
                                    "userName": context
                                        .read<MeetingStore>()
                                        .localPeer
                                        ?.name
                                  },
                                  "updatedAt": DateTime.now()
                                      .millisecondsSinceEpoch //unix timestamp in miliseconds
                                });
                            break;
                        }
                      }),
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
