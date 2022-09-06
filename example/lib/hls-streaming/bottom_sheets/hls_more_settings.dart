import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/hls-streaming/bottom_sheets/hls_device_settings.dart';
import 'package:hmssdk_flutter_example/hls-streaming/bottom_sheets/meeting_mode_sheet.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSMoreSettings extends StatefulWidget {
  @override
  State<HLSMoreSettings> createState() => _HLSMoreSettingsState();
}

class _HLSMoreSettingsState extends State<HLSMoreSettings> {
  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
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
                          color: defaultColor,
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
                        "assets/icons/close_button.svg",
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
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: dividerColor,
                height: 5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (Platform.isAndroid)
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: bottomSheetColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: context.read<MeetingStore>(),
                              child: HLSDeviceSettings()),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/settings.svg",
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Device Settings",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: defaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: bottomSheetColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        context: context,
                        builder: (ctx) => ChangeNotifierProvider.value(
                            value: context.read<MeetingStore>(),
                            child: MeetingModeSheet()),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/participants.svg",
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(
                      "Meeting mode",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: defaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
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
                        context.read<MeetingStore>().changeName(name: name);
                      }
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/pencil.svg",
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(
                      "Change Name",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: defaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      Navigator.pop(context);
                      context.read<MeetingStore>().toggleSpeaker();
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/speaker_state_on.svg",
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(
                      "Change Speaker State",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: defaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      context.read<MeetingStore>().switchCamera();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/camera.svg",
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(
                      "Switch Camera",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: defaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      context.read<MeetingStore>().changeMetadataBRB();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/brb.svg",
                      fit: BoxFit.scaleDown,
                    ),
                    title: Text(
                      "BRB",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: defaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        context.read<MeetingStore>().changeStatsVisible();
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/stats.svg",
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "${context.read<MeetingStore>().isStatsVisible ? "Hide" : "Show"} Stats",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: defaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                  if (_meetingStore.localPeer?.role.permissions.changeRole ??
                      false)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          List<HMSRole> roles = await _meetingStore.getRoles();
                          UtilityComponents.showRoleList(
                              context, roles, _meetingStore);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/mic_state_off.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          "Mute",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: defaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (!(_meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          if (_meetingStore.streamingType["rtmp"] == true) {
                            _meetingStore.stopRtmpAndRecording();
                          } else {
                            Map<String, dynamic> data =
                                await UtilityComponents.showRTMPInputDialog(
                                    context: context,
                                    placeholder:
                                        "Enter Comma separated RTMP Urls",
                                    isRecordingEnabled: _meetingStore
                                            .recordingType["browser"] ==
                                        true);
                            List<String>? urls;
                            if (data["url"]!.isNotEmpty) {
                              urls = data["url"]!.split(",");
                            }
                            if (urls != null) {
                              _meetingStore.startRtmpOrRecording(
                                  meetingUrl: Constant.streamingUrl,
                                  toRecord: false,
                                  rtmpUrls: urls);
                            }
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/stream.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          _meetingStore.streamingType["rtmp"] == true
                              ? "Stop RTMP"
                              : "Start RTMP",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: defaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (!(_meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          if (_meetingStore.recordingType["browser"] == true) {
                            _meetingStore.stopRtmpAndRecording();
                          } else {
                            _meetingStore.startRtmpOrRecording(
                                meetingUrl: Constant.streamingUrl,
                                toRecord: true,
                                rtmpUrls: []);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/record.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          _meetingStore.recordingType["browser"] == true
                              ? "Stop Recording"
                              : "Start Recording",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: defaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (!(_meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          if (Platform.isAndroid) {
                            if (_meetingStore.isAudioShareStarted) {
                              _meetingStore.stopAudioShare();
                            } else {
                              _meetingStore.startAudioShare();
                            }
                          }
                          else if (Platform.isIOS) {
                            bool isPlaying =
                                await _meetingStore.isPlayerRunningIos();
                            String url =
                                await UtilityComponents.showAudioShareDialog(
                                    context: context,
                                    meetingStore: _meetingStore,
                                    isPlaying: isPlaying);
                            if (url != "") {
                              _meetingStore.playAudioIos(url);
                            }
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.music_note,
                          color: defaultColor,
                        ),
                        title: Text(
                          _meetingStore.isAudioShareStarted
                              ? "Stop Audio Share"
                              : "Start Audio Share",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: defaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (Platform.isAndroid && _meetingStore.isAudioShareStarted)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          if (_meetingStore.isAudioShareStarted)
                            UtilityComponents.showChangeAudioMixingModeDialog(
                                context);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/music_wave.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          "Audio Mixing Mode",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: defaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        UtilityComponents.onEndRoomPressed(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/end_room.svg",
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "End Room",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: defaultColor,
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
