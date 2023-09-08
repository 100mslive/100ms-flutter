import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';

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
    _controller =
        TabController(length: 2, vsync: this, initialIndex: widget.tabIndex);

    _controller.addListener(() {
      setState(() {});
    });
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
                          width: MediaQuery.of(context).size.width * 0.78,
                          height: 36,
                          decoration: BoxDecoration(
                              color: HMSThemeColors.surfaceDefault,
                              borderRadius: BorderRadius.circular(8)),
                          child: TabBar(
                            controller: _controller,
                            tabs: [
                              Tab(
                                child: HMSSubheadingText(
                                    text: "Chat",
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HMSCrossButton(
                          onPressed: () =>
                              context.read<MeetingStore>().setNewMessageFalse(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.78,
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
