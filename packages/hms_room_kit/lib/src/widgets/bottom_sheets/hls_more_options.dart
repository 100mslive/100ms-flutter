///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/change_name_bottom_sheet.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/more_option_item.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/overlay_participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/tab_widgets/chat_participants_tab_bar.dart';

///[HLSMoreOptionsBottomSheet] is a bottom sheet that is used to show more options in the meeting
class HLSMoreOptionsBottomSheet extends StatefulWidget {
  const HLSMoreOptionsBottomSheet({super.key});

  @override
  State<HLSMoreOptionsBottomSheet> createState() =>
      _HLSMoreOptionsBottomSheetBottomSheetState();
}

class _HLSMoreOptionsBottomSheetBottomSheetState
    extends State<HLSMoreOptionsBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 20, right: 20, bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HMSTitleText(
                      text: "Options",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [HMSCrossButton()],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Divider(
                color: HMSThemeColors.borderDefault,
                height: 5,
              ),
            ),

            ///Here we render the participants button and the change name button
            Wrap(
              spacing: 12,
              runSpacing: 24,
              children: [
                if (HMSRoomLayout.isParticipantsListEnabled)
                  MoreOptionItem(
                      onTap: () async {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: HMSThemeColors.surfaceDim,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: context.read<MeetingStore>(),
                              child: (HMSRoomLayout.chatData == null ||
                                      (HMSRoomLayout.chatData?.isOverlay ??
                                          true))
                                  ? const OverlayParticipantsBottomSheet()
                                  : const ChatParticipantsTabBar(
                                      tabIndex: 1,
                                    )),
                        );
                      },
                      optionIcon: badge.Badge(
                        badgeStyle: badge.BadgeStyle(
                          badgeColor: HMSThemeColors.surfaceDefault,
                        ),
                        badgeContent: HMSTitleText(
                          text: Utilities.formatNumber(
                              context.read<MeetingStore>().peersInRoom),
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          fontSize: 10,
                          lineHeight: 16,
                          letterSpacing: 1.5,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context
                                          .read<MeetingStore>()
                                          .peersInRoom <
                                      1000
                                  ? 15
                                  : context.read<MeetingStore>().peersInRoom <
                                          10000
                                      ? 20
                                      : 30),
                          child: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      optionText: "Participants"),
                MoreOptionItem(
                    onTap: () async {
                      var meetingStore = context.read<MeetingStore>();
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: HMSThemeColors.surfaceDim,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                        ),
                        context: context,
                        builder: (ctx) => ChangeNotifierProvider.value(
                            value: meetingStore,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(ctx).viewInsets.bottom),
                                child: const ChangeNameBottomSheet())),
                      );
                    },
                    optionIcon: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn),
                    ),
                    optionText: "Change Name")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
