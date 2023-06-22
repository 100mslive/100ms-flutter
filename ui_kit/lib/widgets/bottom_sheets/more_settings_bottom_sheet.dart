import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/constants.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/widgets/app_dialogs/stats_for_nerds.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/audio_settings_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/meeting_mode_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/notification_settings_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/bottom_sheets/start_hls_bottom_sheet.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/share_link_option.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
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
                    Text(
                      "More Options",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "packages/hmssdk_uikit/lib/assets/icons/close_button.svg",
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
                color: dividerColor,
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
                                    "packages/hmssdk_uikit/lib/assets/icons/participants.svg",
                                    color: themeDefaultColor,
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
                                "packages/hmssdk_uikit/lib/assets/icons/settings.svg",
                                color: themeDefaultColor,
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
                        backgroundColor: themeBottomSheetColor,
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
                      "packages/hmssdk_uikit/lib/assets/icons/participants.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Meeting mode",
                      semanticsLabel: "fl_meeting_mode",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
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
                      // Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hmssdk_uikit/lib/assets/icons/pencil.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Change Name",
                      semanticsLabel: "fl_change_name",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
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
                          ? "packages/hmssdk_uikit/lib/assets/icons/speaker_state_on.svg"
                          : "packages/hmssdk_uikit/lib/assets/icons/speaker_state_off.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      meetingStore.isSpeakerOn ? "Mute Room" : "Unmute Room",
                      semanticsLabel: "fl_mute_room",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      meetingStore.switchCamera();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hmssdk_uikit/lib/assets/icons/camera.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Switch Camera",
                      semanticsLabel: "fl_switch_camera",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      meetingStore.changeMetadataBRB();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hmssdk_uikit/lib/assets/icons/brb.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "BRB",
                      semanticsLabel: "fl_brb_list_tile",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: meetingStore.isBRB
                              ? colorScheme.error
                              : themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
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
                          "packages/hmssdk_uikit/lib/assets/icons/stats.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Stats for nerds",
                          semanticsLabel: "fl_stats_list_tile",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if ((meetingStore.localPeer?.role.permissions.mute ??
                          false) &&
                      (meetingStore.localPeer?.role.permissions.unMute ??
                          false))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          List<HMSRole> roles = await meetingStore.getRoles();
                          UtilityComponents.showRoleListForMute(
                              context, roles, meetingStore);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hmssdk_uikit/lib/assets/icons/mic_state_off.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Mute Role",
                          semanticsLabel: "fl_mute_role",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (meetingStore.localPeer?.role.permissions.changeRole ??
                      false)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          List<HMSRole> roles = await meetingStore.getRoles();
                          UtilityComponents.showDialogForBulkRoleChange(
                              context, roles, meetingStore);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hmssdk_uikit/lib/assets/icons/role_change.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Bulk Role Change",
                          semanticsLabel: "fl_bulk_roles_change",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
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
                                "packages/hmssdk_uikit/lib/assets/icons/stream.svg",
                                fit: BoxFit.scaleDown,
                                color: isRTMPRunning
                                    ? colorScheme.error
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                isRTMPRunning ? "Stop RTMP" : "Start RTMP",
                                semanticsLabel: isRTMPRunning
                                    ? "fl_stop_rtmp"
                                    : "fl_start_rtmp",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isRTMPRunning
                                        ? colorScheme.error
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
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
                                "packages/hmssdk_uikit/lib/assets/icons/record.svg",
                                fit: BoxFit.scaleDown,
                                color: isBrowserRecording
                                    ? colorScheme.error
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                isBrowserRecording
                                    ? "Stop Recording"
                                    : "Start Recording",
                                semanticsLabel: isBrowserRecording
                                    ? "fl_stop_recording"
                                    : "fl_start_recording",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isBrowserRecording
                                        ? colorScheme.error
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
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
                                  builder: (ctx) =>
                                      ChangeNotifierProvider.value(
                                          value: meetingStore,
                                          child: const StartHLSBottomSheet()),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: SvgPicture.asset(
                                "packages/hmssdk_uikit/lib/assets/icons/hls.svg",
                                fit: BoxFit.scaleDown,
                                color: hasHLSStarted
                                    ? colorScheme.error
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                hasHLSStarted ? "Stop HLS" : "Start HLS",
                                semanticsLabel: hasHLSStarted
                                    ? "fl_stop_hls"
                                    : "fl_start_hls",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: hasHLSStarted
                                        ? colorScheme.error
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
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
                          "packages/hmssdk_uikit/lib/assets/icons/screen_share.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Enter Pip Mode",
                          semanticsLabel: "fl_pip_mode",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
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
                        "packages/hmssdk_uikit/lib/assets/icons/share.svg",
                        fit: BoxFit.scaleDown,
                        color: themeDefaultColor,
                      ),
                      title: Text(
                        "Share Link",
                        semanticsLabel: "fl_share_link",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: themeBottomSheetColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            context: context,
                            builder: (ctx) =>
                                const NotificationSettingsBottomSheet());
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hmssdk_uikit/lib/assets/icons/notification.svg",
                        fit: BoxFit.scaleDown,
                        color: themeDefaultColor,
                      ),
                      title: Text(
                        "Modify Notifications",
                        semanticsLabel: "fl_notification_setting",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                  if (meetingStore.localPeer?.role.permissions.endRoom ??
                      false)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          UtilityComponents.onEndRoomPressed(context);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "packages/hmssdk_uikit/lib/assets/icons/end_room.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "End Room",
                          semanticsLabel: "fl_end_room",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
