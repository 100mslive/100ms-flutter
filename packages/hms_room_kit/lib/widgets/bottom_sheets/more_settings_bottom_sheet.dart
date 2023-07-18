import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/common/constants.dart';
import 'package:hms_room_kit/common/utility_components.dart';
import 'package:hms_room_kit/widgets/app_dialogs/stats_for_nerds.dart';
import 'package:hms_room_kit/widgets/bottom_sheets/audio_settings_bottom_sheet.dart';
import 'package:hms_room_kit/widgets/bottom_sheets/meeting_mode_bottom_sheet.dart';
import 'package:hms_room_kit/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/widgets/bottom_sheets/start_hls_bottom_sheet.dart';
import 'package:hms_room_kit/widgets/common_widgets/share_link_option.dart';
import 'package:hms_room_kit/widgets/common_widgets/subheading_text.dart';
import 'package:hms_room_kit/widgets/common_widgets/title_text.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class MoreSettingsBottomSheet extends StatefulWidget {
  final bool isAudioMixerDisabled;

  const MoreSettingsBottomSheet({Key? key, this.isAudioMixerDisabled = true})
      : super(key: key);
  @override
  State<MoreSettingsBottomSheet> createState() =>
      _MoreSettingsBottomSheetState();
}

class _MoreSettingsBottomSheetState extends State<MoreSettingsBottomSheet> {
  void _showRoleList(
      {required List<HMSRole> roles, required MeetingStore meetingStore}) {
    UtilityComponents.showRoleListForMute(context, roles, meetingStore);
  }

  void _showDialogForBulkRoleChange(
      {required List<HMSRole> roles, required MeetingStore meetingStore}) {
    UtilityComponents.showDialogForBulkRoleChange(context, roles, meetingStore);
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TitleText(
                      text: "Settings",
                      textColor: onSurfaceHighEmphasis,
                      fontSize: 20,
                      lineHeight: 24 / 20,
                      letterSpacing: 0.15,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/close_button.svg",
                        width: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: borderDefault,
                height: 5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: themeBottomSheetColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            context: context,
                            builder: (ctx) => ChangeNotifierProvider.value(
                                value: context.read<MeetingStore>(),
                                child: const ParticipantsBottomSheet()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: moreSettingsButtonColor,
                              borderRadius: BorderRadius.circular(10)),
                          height: 100,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              badge.Badge(
                                badgeStyle: badge.BadgeStyle(
                                    badgeColor: hmsdefaultColor),
                                badgeContent: Text(context
                                    .read<MeetingStore>()
                                    .peers
                                    .length
                                    .toString()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/assets/icons/participants.svg",
                                    colorFilter: ColorFilter.mode(
                                        themeDefaultColor, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Participants",
                                semanticsLabel: "participants_button",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          if (Platform.isAndroid) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: themeBottomSheetColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              context: context,
                              builder: (ctx) => ChangeNotifierProvider.value(
                                  value: meetingStore,
                                  child: const AudioSettingsBottomSheet()),
                            );
                          } else {
                            meetingStore.switchAudioOutputUsingiOSUI();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: moreSettingsButtonColor,
                              borderRadius: BorderRadius.circular(10)),
                          height: 100,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "packages/hms_room_kit/lib/assets/icons/settings.svg",
                                colorFilter: ColorFilter.mode(
                                    themeDefaultColor, BlendMode.srcIn),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Audio Settings",
                                semanticsLabel: "fl_audio_settings",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: surfaceDim,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        context: context,
                        builder: (ctx) => ChangeNotifierProvider.value(
                            value: meetingStore,
                            child: const MeetingModeBottomSheet()),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/assets/icons/participants.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          onSurfaceHighEmphasis, BlendMode.srcIn),
                    ),
                    title: SubheadingText(
                      text: "Meeting mode",
                      textColor: onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (meetingStore.localPeer?.role.publishSettings?.allowed
                          .contains("screen") ??
                      false)
                    Selector<MeetingStore, bool>(
                        selector: ((_, meetingStore) =>
                            meetingStore.isScreenShareOn),
                        builder: (_, isScreenShareOn, __) {
                          return ListTile(
                            horizontalTitleGap: 2,
                            onTap: () async {
                              Navigator.pop(context);
                              if (isScreenShareOn) {
                                meetingStore.stopScreenShare();
                              } else {
                                meetingStore.startScreenShare();
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              "packages/hms_room_kit/lib/assets/icons/screen_share.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  onSurfaceHighEmphasis, BlendMode.srcIn),
                            ),
                            title: SubheadingText(
                              text: isScreenShareOn
                                  ? "Stop Screen Share"
                                  : "Share Screen",
                              textColor: onSurfaceHighEmphasis,
                              letterSpacing: 0.15,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                      String name =
                          await UtilityComponents.showNameChangeDialog(
                              context: context,
                              placeholder: "Enter Name",
                              prefilledValue: context
                                      .read<MeetingStore>()
                                      .localPeer
                                      ?.name ??
                                  "");
                      if (name.isNotEmpty) {
                        meetingStore.changeName(name: name);
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/assets/icons/pencil.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          onSurfaceHighEmphasis, BlendMode.srcIn),
                    ),
                    title: SubheadingText(
                      text: "Change Name",
                      textColor: onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      meetingStore.toggleSpeaker();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      meetingStore.isSpeakerOn
                          ? "packages/hms_room_kit/lib/assets/icons/speaker_state_on.svg"
                          : "packages/hms_room_kit/lib/assets/icons/speaker_state_off.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          onSurfaceHighEmphasis, BlendMode.srcIn),
                    ),
                    title: SubheadingText(
                      text: meetingStore.isSpeakerOn
                          ? "Mute Room"
                          : "Unmute Room",
                      textColor: onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        context.read<MeetingStore>().changeMetadata();
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/hand_outline.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: meetingStore.isRaisedHand
                            ? "Lower Hand"
                            : "Raise Hand",
                        textColor: onSurfaceHighEmphasis,
                        fontWeight: FontWeight.w600,
                      )),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      meetingStore.changeMetadataBRB();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/assets/icons/brb.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          onSurfaceHighEmphasis, BlendMode.srcIn),
                    ),
                    title: SubheadingText(
                      text: "BRB",
                      textColor: meetingStore.isBRB
                          ? alertErrorDefault
                          : onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (Constant.debugMode)
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => ListenableProvider.value(
                                value: meetingStore,
                                child: StatsForNerds(
                                  peerTrackNode: meetingStore.peerTracks,
                                )));
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/stats.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: "Stats for nerds",
                        textColor: onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if ((meetingStore.localPeer?.role.permissions.mute ??
                          false) &&
                      (meetingStore.localPeer?.role.permissions.unMute ??
                          false))
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        List<HMSRole> roles = await meetingStore.getRoles();
                        _showRoleList(roles: roles, meetingStore: meetingStore);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/mic_state_off.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: "Mute Role",
                        textColor: onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (meetingStore.localPeer?.role.permissions.changeRole ??
                      false)
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        List<HMSRole> roles = await meetingStore.getRoles();
                        _showDialogForBulkRoleChange(
                            roles: roles, meetingStore: meetingStore);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/role_change.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: "Bulk Role Change",
                        textColor: onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (meetingStore.localPeer?.role.permissions.rtmpStreaming ??
                      false)
                    Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.streamingType["rtmp"] ?? false,
                        builder: (_, isRTMPRunning, __) {
                          return ListTile(
                            horizontalTitleGap: 2,
                            onTap: () async {
                              if (isRTMPRunning) {
                                meetingStore.stopRtmpAndRecording();
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                Map<String, dynamic> data =
                                    await UtilityComponents.showRTMPInputDialog(
                                        context: context,
                                        placeholder:
                                            "Enter Comma separated RTMP Urls",
                                        isRecordingEnabled: meetingStore
                                                .recordingType["browser"] ==
                                            true);
                                List<String>? urls;
                                if (data["url"]!.isNotEmpty) {
                                  urls = data["url"]!.split(",");
                                }
                                if (urls != null) {
                                  meetingStore.startRtmpOrRecording(
                                      meetingUrl: Constant.streamingUrl,
                                      toRecord: data["toRecord"] ?? false,
                                      rtmpUrls: urls);
                                } else if (data["toRecord"] ?? false) {
                                  meetingStore.startRtmpOrRecording(
                                      meetingUrl: Constant.streamingUrl,
                                      toRecord: data["toRecord"] ?? false,
                                      rtmpUrls: null);
                                }
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              "packages/hms_room_kit/lib/assets/icons/stream.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  isRTMPRunning
                                      ? alertErrorDefault
                                      : onSurfaceHighEmphasis,
                                  BlendMode.srcIn),
                            ),
                            title: SubheadingText(
                              text: isRTMPRunning ? "Stop RTMP" : "Start RTMP",
                              textColor: isRTMPRunning
                                  ? alertErrorDefault
                                  : onSurfaceHighEmphasis,
                              letterSpacing: 0.15,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                  if (meetingStore
                          .localPeer?.role.permissions.browserRecording ??
                      false)
                    Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.recordingType["browser"] ?? false,
                        builder: (_, isBrowserRecording, __) {
                          return ListTile(
                            horizontalTitleGap: 2,
                            onTap: () async {
                              if (isBrowserRecording) {
                                meetingStore.stopRtmpAndRecording();
                              } else {
                                meetingStore.startRtmpOrRecording(
                                    meetingUrl: Constant.streamingUrl,
                                    toRecord: true,
                                    rtmpUrls: []);
                              }
                              Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              "packages/hms_room_kit/lib/assets/icons/record.svg",
                              height: 20,
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                  isBrowserRecording
                                      ? alertErrorDefault
                                      : onSurfaceHighEmphasis,
                                  BlendMode.srcIn),
                            ),
                            title: SubheadingText(
                              text: isBrowserRecording
                                  ? "Stop Recording"
                                  : "Start Recording",
                              textColor: isBrowserRecording
                                  ? alertErrorDefault
                                  : onSurfaceHighEmphasis,
                              letterSpacing: 0.15,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                  if (meetingStore.localPeer?.role.permissions.hlsStreaming ??
                      false)
                    Selector<MeetingStore, bool>(
                        selector: ((_, meetingStore) =>
                            meetingStore.hasHlsStarted),
                        builder: (_, hasHLSStarted, __) {
                          return ListTile(
                            horizontalTitleGap: 2,
                            onTap: () async {
                              if (hasHLSStarted) {
                                meetingStore.stopHLSStreaming();
                                Navigator.pop(context);
                                return;
                              }
                              Navigator.pop(context);
                              showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor: themeBottomSheetColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                context: context,
                                builder: (ctx) => ChangeNotifierProvider.value(
                                    value: meetingStore,
                                    child: const StartHLSBottomSheet()),
                              );
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                                "packages/hms_room_kit/lib/assets/icons/hls.svg",
                                height: 20,
                                width: 20,
                                colorFilter: ColorFilter.mode(
                                    hasHLSStarted
                                        ? alertErrorDefault
                                        : onSurfaceHighEmphasis,
                                    BlendMode.srcIn)),
                            title: SubheadingText(
                              text: hasHLSStarted ? "Stop HLS" : "Start HLS",
                              textColor: hasHLSStarted
                                  ? alertErrorDefault
                                  : onSurfaceHighEmphasis,
                              letterSpacing: 0.15,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                  if (Platform.isAndroid)
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        context.read<MeetingStore>().enterPipModeOnAndroid();
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/screen_share.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: "Enter Pip Mode",
                        textColor: onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) => ShareLinkOptionDialog(
                              roles: meetingStore.roles,
                              roomID: meetingStore.hmsRoom!.id));
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/assets/icons/share.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          onSurfaceHighEmphasis, BlendMode.srcIn),
                    ),
                    title: SubheadingText(
                      text: "Share Link",
                      textColor: onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  /**
                   * This has been turned OFF by default for now 
                   * Needs some discussion around the toasts
                   */
                  // ListTile(
                  //     horizontalTitleGap: 2,
                  //     onTap: () async {
                  //       Navigator.pop(context);
                  //       showModalBottomSheet(
                  //           isScrollControlled: true,
                  //           backgroundColor: themeBottomSheetColor,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //           ),
                  //           context: context,
                  //           builder: (ctx) =>
                  //               const NotificationSettingsBottomSheet());
                  //     },
                  //     contentPadding: EdgeInsets.zero,
                  //     leading: SvgPicture.asset(
                  //       "packages/hms_room_kit/lib/assets/icons/notification.svg",
                  //       height: 20,
                  //       width: 20,
                  //       color: onSurfaceHighEmphasis,
                  //     ),
                  //     title: Text(
                  //       "Modify Notifications",
                  //       semanticsLabel: "fl_notification_setting",
                  //       style: GoogleFonts.inter(
                  //           fontSize: 14,
                  //           colorFilter:  ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
                  //           letterSpacing: 0.25,
                  //           fontWeight: FontWeight.w600),
                  //     )),
                  if (meetingStore.localPeer?.role.permissions.endRoom ?? false)
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        UtilityComponents.onEndRoomPressed(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/end_room.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            onSurfaceHighEmphasis, BlendMode.srcIn),
                      ),
                      title: SubheadingText(
                        text: "End Room",
                        textColor: onSurfaceHighEmphasis,
                        letterSpacing: 0.15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
