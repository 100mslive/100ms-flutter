library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/end_service_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/leave_session_tile.dart';

class LeaveSessionBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;
  const LeaveSessionBottomSheet({super.key, required this.meetingStore});

  @override
  State<LeaveSessionBottomSheet> createState() =>
      _LeaveSessionBottomSheetState();
}

class _LeaveSessionBottomSheetState extends State<LeaveSessionBottomSheet> {
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

  ///Here we render bottom sheet with leave and end options

  @override
  Widget build(BuildContext context) {
    return ((widget.meetingStore.localPeer?.role.permissions.endRoom ??
                false) ||
            ((widget.meetingStore.localPeer?.role.permissions.hlsStreaming ??
                    false) &&
                widget.meetingStore.hasHlsStarted))
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
                      builder: (ctx) => ChangeNotifierProvider.value(
                        value: widget.meetingStore,
                        child: EndServiceBottomSheet(
                          onButtonPressed: () => {
                            widget.meetingStore.leave(),
                          },
                          title: HMSTitleText(
                            text:
                                "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
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
                                "Others will continue after you leave. You can join the session again.",
                            maxLines: 2,
                            textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                          ),
                          buttonText:
                              "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
                        ),
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
                  title: ((widget.meetingStore.localPeer?.role.permissions
                                  .hlsStreaming ??
                              false) &&
                          widget.meetingStore.hasHlsStarted)
                      ? "End Stream"
                      : "End Session",
                  titleColor: HMSThemeColors.alertErrorBrighter,
                  subTitle: ((widget.meetingStore.localPeer?.role.permissions
                                  .hlsStreaming ??
                              false) &&
                          widget.meetingStore.hasHlsStarted)
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
                      builder: (ctx) => ChangeNotifierProvider.value(
                        value: widget.meetingStore,
                        child: EndServiceBottomSheet(
                          onButtonPressed: () => {
                            if ((widget.meetingStore.localPeer?.role.permissions
                                        .hlsStreaming ??
                                    false) &&
                                widget.meetingStore.hasHlsStarted)
                              {
                                widget.meetingStore.stopHLSStreaming(),
                                widget.meetingStore.leave(),
                              }
                            else
                              {
                                widget.meetingStore
                                    .endRoom(false, "Room Ended From Flutter"),
                              },
                          },
                          title: HMSTitleText(
                            text: ((widget.meetingStore.localPeer?.role
                                            .permissions.hlsStreaming ??
                                        false) &&
                                    widget.meetingStore.hasHlsStarted)
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
                            text: ((widget.meetingStore.localPeer?.role
                                            .permissions.hlsStreaming ??
                                        false) &&
                                    widget.meetingStore.hasHlsStarted)
                                ? "The stream will end for everyone after they’ve watched it."
                                : "The session will end for everyone in the room immediately.",
                            maxLines: 3,
                            textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                          ),
                          buttonText: ((widget.meetingStore.localPeer?.role
                                          .permissions.hlsStreaming ??
                                      false) &&
                                  widget.meetingStore.hasHlsStarted)
                              ? "End Stream"
                              : "End Session",
                        ),
                      ),
                    )
                  },
                ),
              ],
            ),
          )
        : ChangeNotifierProvider.value(
            value: widget.meetingStore,
            child: EndServiceBottomSheet(
              onButtonPressed: () => {
                widget.meetingStore.leave(),
              },
              title: HMSTitleText(
                text:
                    "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
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
                    "Others will continue after you leave. You can join the session again.",
                maxLines: 2,
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              ),
              buttonText:
                  "Leave ${HMSRoomLayout.peerType == PeerRoleType.conferencing ? "Session" : "Stream"}",
            ),
          );
  }
}
