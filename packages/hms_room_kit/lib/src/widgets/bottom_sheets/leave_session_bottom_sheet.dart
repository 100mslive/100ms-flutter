import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/end_service_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/leave_session_tile.dart';

class LeaveSessionBottomSheet extends StatelessWidget {
  final MeetingStore meetingStore;
  const LeaveSessionBottomSheet({super.key, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return ((meetingStore.localPeer?.role.permissions.endRoom ?? false) ||
            ((meetingStore.localPeer?.role.permissions.hlsStreaming ?? false) &&
                meetingStore.hasHlsStarted))
        ? Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LeaveSessionTile(
                  tilePadding:
                      const EdgeInsets.only(top: 12.0, left: 18, right: 18),
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/exit_room.svg",
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                    semanticsLabel: "leave_room_button",
                  ),
                  title: "Leave",
                  titleColor: HMSThemeColors.onSurfaceHighEmphasis,
                  subTitle:
                      "Others will continue after you leave. You can join the session again.",
                  subTitleColor: HMSThemeColors.onSurfaceMediumEmphasis,
                  onTap: () => {
                    Navigator.pop(context),
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
                        onButtonPressed: () => {
                          meetingStore.leave(),
                        },
                        title: HMSTitleText(
                          text: "Leave Session",
                          textColor: HMSThemeColors.alertErrorDefault,
                          letterSpacing: 0.15,
                          fontSize: 20,
                        ),
                        bottomSheetTitleIcon: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.alertErrorDefault,
                              BlendMode.srcIn),
                        ),
                        subTitle: HMSSubheadingText(
                          text:
                              "Others will continue after you leave. You can join\n the session again.",
                          maxLines: 2,
                          textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                        ),
                        buttonText: "Leave Session",
                      ),
                    )
                  },
                ),
                LeaveSessionTile(
                  tileColor: HMSThemeColors.alertErrorDim,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/end.svg",
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.alertErrorBrighter, BlendMode.srcIn),
                    semanticsLabel: "leave_room_button",
                  ),
                  title:
                      ((meetingStore.localPeer?.role.permissions.hlsStreaming ??
                                  false) &&
                              meetingStore.hasHlsStarted)
                          ? "End Stream"
                          : "End Session",
                  titleColor: HMSThemeColors.alertErrorBrighter,
                  subTitle: ((meetingStore
                                  .localPeer?.role.permissions.hlsStreaming ??
                              false) &&
                          meetingStore.hasHlsStarted)
                      ? "The stream will end for everyone after they’ve watched it."
                      : "The session will end for everyone in the room immediately.",
                  subTitleColor: HMSThemeColors.alertErrorBright,
                  onTap: () => {
                    Navigator.pop(context),
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
                        onButtonPressed: () => {
                          if ((meetingStore.localPeer?.role.permissions
                                      .hlsStreaming ??
                                  false) &&
                              meetingStore.hasHlsStarted)
                            {
                              meetingStore.stopHLSStreaming(),
                              meetingStore.leave(),
                            }
                          else
                            {
                              meetingStore.endRoom(
                                  false, "Room Ended From Flutter"),
                            },
                        },
                        title: HMSTitleText(
                          text: ((meetingStore.localPeer?.role.permissions
                                          .hlsStreaming ??
                                      false) &&
                                  meetingStore.hasHlsStarted)
                              ? "End Stream"
                              : "End Session",
                          textColor: HMSThemeColors.alertErrorDefault,
                          letterSpacing: 0.15,
                          fontSize: 20,
                        ),
                        bottomSheetTitleIcon: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.alertErrorDefault,
                              BlendMode.srcIn),
                        ),
                        subTitle: HMSSubheadingText(
                          text: ((meetingStore.localPeer?.role.permissions
                                          .hlsStreaming ??
                                      false) &&
                                  meetingStore.hasHlsStarted)
                              ? "The stream will end for everyone after they’ve watched it."
                              : "The session will end for everyone in the room immediately.",
                          maxLines: 3,
                          textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                        ),
                        buttonText: ((meetingStore.localPeer?.role.permissions
                                        .hlsStreaming ??
                                    false) &&
                                meetingStore.hasHlsStarted)
                            ? "End Stream"
                            : "End Session",
                      ),
                    )
                  },
                ),
              ],
            ),
          )
        : EndServiceBottomSheet(
            onButtonPressed: () => {
              meetingStore.leave(),
            },
            title: HMSTitleText(
              text: "Leave Session",
              textColor: HMSThemeColors.alertErrorDefault,
              letterSpacing: 0.15,
              fontSize: 20,
            ),
            bottomSheetTitleIcon: SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                  HMSThemeColors.alertErrorDefault, BlendMode.srcIn),
            ),
            subTitle: HMSSubheadingText(
              text:
                  "Others will continue after you leave. You can join\n the session again.",
              maxLines: 2,
              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
            ),
            buttonText: "Leave Session",
          );
  }
}
