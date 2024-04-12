///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/poll_and_quiz_bottom_sheet.dart';
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

///[HLSAppUtilitiesBottomSheet] is a bottom sheet that is used to show more options in the meeting
class HLSAppUtilitiesBottomSheet extends StatefulWidget {
  const HLSAppUtilitiesBottomSheet({super.key});

  @override
  State<HLSAppUtilitiesBottomSheet> createState() =>
      _HLSMoreOptionsBottomSheetBottomSheetState();
}

class _HLSMoreOptionsBottomSheetBottomSheetState
    extends State<HLSAppUtilitiesBottomSheet> {
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
    return Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 20, right: 20, bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
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
              runSpacing: 24,
              spacing: MediaQuery.of(context).size.width * 0.005,
              children: [
                if (HMSRoomLayout.isParticipantsListEnabled)
                  MoreOptionItem(
                      onTap: () async {
                        Navigator.pop(context);
                        var meetingStore = context.read<MeetingStore>();
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
                              child: const OverlayParticipantsBottomSheet()),
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
                if (Constant.prebuiltOptions?.userName == null)
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
                      optionText: "Change Name"),

                ///This renders the polls and quizzes option
                if ((context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollRead ??
                        false) ||
                    (context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollWrite ??
                        false))
                  MoreOptionItem(
                      onTap: () {
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
                              child: const PollAndQuizBottomSheet()),
                        );
                      },
                      optionIcon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/polls.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                      ),
                      optionText: "Polls and Quizzes"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
