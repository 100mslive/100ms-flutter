///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[ChatParticipantsTabBar] is a tab bar that is used to render the tab bar for chat and participants
///This is only rendered when both chat and participants list are enabled.
class ChatParticipantsTabBar extends StatefulWidget {
  final int tabIndex;
  const ChatParticipantsTabBar({super.key, this.tabIndex = 0});

  @override
  State<ChatParticipantsTabBar> createState() => _ChatParticipantsTabBarState();
}

class _ChatParticipantsTabBarState extends State<ChatParticipantsTabBar>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
    _controller =
        TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);

    _controller.addListener(() {
      setState(() {});
    });
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width *
                              ((HMSRoomLayout.chatData?.realTimeControls
                                          ?.canDisableChat ??
                                      false)
                                  ? 0.69
                                  : 0.76),
                          height: 36,
                          decoration: BoxDecoration(
                              color: HMSThemeColors.surfaceDefault,
                              borderRadius: BorderRadius.circular(8)),
                          child: TabBar(
                            controller: _controller,
                            tabs: [
                              Tab(
                                child: HMSSubheadingText(
                                    text: HMSRoomLayout.chatData?.chatTitle ??
                                        "Chat",
                                    fontWeight: FontWeight.w600,
                                    textColor: _controller.index == 0
                                        ? HMSThemeColors.onSurfaceHighEmphasis
                                        : HMSThemeColors.onSurfaceLowEmphasis),
                              ),
                              Tab(
                                child: HMSSubheadingText(
                                    text: "Participants",
                                    fontWeight: FontWeight.w600,
                                    textColor: _controller.index == 1
                                        ? HMSThemeColors.onSurfaceHighEmphasis
                                        : HMSThemeColors.onSurfaceLowEmphasis),
                              ),
                            ],
                            indicatorPadding: const EdgeInsets.all(4),
                            indicator: BoxDecoration(
                                color: HMSThemeColors.surfaceBright,
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (HMSRoomLayout
                                .chatData?.realTimeControls?.canDisableChat ??
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
                                                  HMSThemeColors
                                                      .onSurfaceHighEmphasis,
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
                                            textColor: HMSThemeColors
                                                .onSurfaceHighEmphasis,
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
                                            key: SessionStoreKeyValues
                                                .getNameFromMethod(
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
                        HMSCrossButton(
                          onPressed: () =>
                              context.read<MeetingStore>().setNewMessageFalse(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.76,
                  child: TabBarView(controller: _controller, children: const [
                    ChatBottomSheet(),
                    ParticipantsBottomSheet()
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
