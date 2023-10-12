///Package imports
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/more_option_item.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/end_service_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/overlay_participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/tab_widgets/chat_participants_tab_bar.dart';

///This renders the app utilities bottom sheet for webRTC or broadcaster
///It contains the participants, screen share, brb, raise hand and recording
///options
class AppUtilitiesBottomSheet extends StatefulWidget {
  const AppUtilitiesBottomSheet({Key? key}) : super(key: key);
  @override
  State<AppUtilitiesBottomSheet> createState() =>
      _AppUtilitiesBottomSheetState();
}

class _AppUtilitiesBottomSheetState extends State<AppUtilitiesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return Padding(
      padding: EdgeInsets.only(
          top: 16.0,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04,
          bottom: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///This renders the title and close button
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
                  children: [
                    HMSCrossButton(),
                  ],
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

            ///This renders the participants, screen share, brb, raise hand and recording options
            Wrap(
              runSpacing: 24,
              spacing: MediaQuery.of(context).size.width * 0.005,
              children: [
                ///This renders the participants option if participants list is enabled
                if (HMSRoomLayout.isParticipantsListEnabled)
                  MoreOptionItem(
                      onTap: () async {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: HMSThemeColors.surfaceDim,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: meetingStore,
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

                ///This renders the screen share option
                MoreOptionItem(
                  onTap: () async {
                    Navigator.pop(context);
                    if (meetingStore.isScreenShareOn) {
                      meetingStore.stopScreenShare();
                    } else {
                      meetingStore.startScreenShare();
                    }
                  },
                  isActive: meetingStore.isScreenShareOn,
                  optionIcon: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  ),
                  optionText: meetingStore.isScreenShareOn
                      ? "Sharing Screen"
                      : "Share Screen",
                ),

                ///This renders the brb option
                if (HMSRoomLayout.isBRBEnabled)
                  MoreOptionItem(
                      onTap: () async {
                        meetingStore.changeMetadataBRB();
                        Navigator.pop(context);
                      },
                      isActive: meetingStore.isBRB,
                      optionIcon: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/brb.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        ),
                      ),
                      optionText:
                          meetingStore.isBRB ? "I'm Back" : "Be Right Back")

                ///This renders the raise hand option
                ,
                MoreOptionItem(
                    onTap: () async {
                      context.read<MeetingStore>().toggleLocalPeerHandRaise();
                      Navigator.pop(context);
                    },
                    isActive: meetingStore.isRaisedHand,
                    optionIcon: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn),
                    ),
                    optionText: meetingStore.isRaisedHand
                        ? "Lower Hand"
                        : "Raise Hand"),

                ///This renders the recording option
                ///This option is only rendered if the local peer has the permission to
                ///start/stop browser recording
                ///
                ///The recording permission is checked using the role of the local peer
                ///
                ///If Streaming is already running we disable the recording option
                if (meetingStore.localPeer?.role.permissions.browserRecording ??
                    false)

                  ///If streaming is on or in initialising state disable the button
                  ((meetingStore.streamingType["hls"] ?? false) ||
                          (meetingStore.streamingType["rtmp"] ?? false) ||
                          meetingStore.isRecordingInInitialisingState)
                      ? MoreOptionItem(
                          onTap: () {},
                          isActive: false,
                          optionIcon: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceLowEmphasis,
                                BlendMode.srcIn),
                          ),
                          optionText: "Start Recording",
                          optionTextColor: HMSThemeColors.onSurfaceLowEmphasis,
                        )
                      : MoreOptionItem(
                          onTap: () async {
                            bool isRecordingRunning =
                                ((meetingStore.recordingType["hls"] ?? false) ||
                                    (meetingStore.recordingType["browser"] ??
                                        false) ||
                                    (meetingStore.recordingType["server"] ??
                                        false));
                            if (isRecordingRunning) {
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
                                builder: (ctx) => EndServiceBottomSheet(
                                  onButtonPressed: () =>
                                      meetingStore.stopRtmpAndRecording(),
                                  title: HMSTitleText(
                                    text: "Stop Recording",
                                    textColor: HMSThemeColors.alertErrorDefault,
                                    letterSpacing: 0.15,
                                    fontSize: 20,
                                  ),
                                  bottomSheetTitleIcon: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/alert.svg",
                                    height: 20,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.alertErrorDefault,
                                        BlendMode.srcIn),
                                  ),
                                  subTitle: HMSSubheadingText(
                                    text:
                                        "Are you sure you want to stop recording? You\n can’t undo this action.",
                                    maxLines: 2,
                                    textColor:
                                        HMSThemeColors.onSurfaceMediumEmphasis,
                                  ),
                                  buttonText: "Stop Recording",
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                              meetingStore.startRtmpOrRecording(
                                  meetingUrl: Constant.streamingUrl,
                                  toRecord: true,
                                  rtmpUrls: null);
                            }
                          },
                          isActive: ((meetingStore.recordingType["hls"] ??
                                  false) ||
                              (meetingStore.recordingType["browser"] ??
                                  false) ||
                              (meetingStore.recordingType["server"] ?? false)),
                          optionIcon: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                          ),
                          optionText:
                              ((meetingStore.recordingType["hls"] ?? false) ||
                                      (meetingStore.recordingType["browser"] ??
                                          false) ||
                                      (meetingStore.recordingType["server"] ??
                                          false))
                                  ? "Stop Recording"
                                  : "Start Recording",
                        )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
