import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class MeetingModeBottomSheet extends StatefulWidget {
  const MeetingModeBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  State<MeetingModeBottomSheet> createState() => _MeetingModeBottomSheetState();
}

class _MeetingModeBottomSheetState extends State<MeetingModeBottomSheet> {
  GlobalKey? dropdownKey;

  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: borderColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: themeDefaultColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Meeting Modes",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/close_button.svg",
                      width: 40,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode ==
                            MeetingMode.equalProminenceWithInset) {
                          Utilities.showToast(
                              "Meeting mode is already set to Grid View");
                          return;
                        }
                        meetingStore
                            .setMode(MeetingMode.equalProminenceWithInset);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/role_change.svg",
                        semanticsLabel: "fl_normal_mode",
                        colorFilter: ColorFilter.mode(
                            (meetingStore.meetingMode ==
                                    MeetingMode.equalProminenceWithInset)
                                ? errorColor
                                : themeDefaultColor,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Normal Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: (meetingStore.meetingMode ==
                                    MeetingMode.equalProminenceWithInset)
                                ? errorColor
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode ==
                            MeetingMode.activeSpeakerWithInset) {
                          Utilities.showToast(
                              "Meeting mode is already set to Active Speaker");
                          return;
                        }
                        meetingStore
                            .setMode(MeetingMode.activeSpeakerWithInset);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                        semanticsLabel: "fl_active_speaker_mode",
                        colorFilter: ColorFilter.mode(
                            (meetingStore.meetingMode ==
                                    MeetingMode.activeSpeakerWithInset)
                                ? errorColor
                                : themeDefaultColor,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Active Speaker Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: (meetingStore.meetingMode ==
                                    MeetingMode.activeSpeakerWithInset)
                                ? errorColor
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.audio) {
                          Utilities.showToast(
                              "Meeting mode is already set to Audio Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.audio);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg',
                        colorFilter: ColorFilter.mode(
                            meetingStore.meetingMode == MeetingMode.audio
                                ? errorColor
                                : themeDefaultColor,
                            BlendMode.srcIn),
                        semanticsLabel: "fl_audio_video_view",
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Audio View",
                        semanticsLabel: "fl_audio_video_mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: meetingStore.meetingMode == MeetingMode.audio
                                ? errorColor
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.hero) {
                          Utilities.showToast(
                              "Meeting mode is already set to Hero Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.hero);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                        semanticsLabel: "fl_hero_mode",
                        colorFilter: ColorFilter.mode(
                            meetingStore.meetingMode == MeetingMode.hero
                                ? errorColor
                                : themeDefaultColor,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Hero Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: meetingStore.meetingMode == MeetingMode.hero
                                ? errorColor
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.single) {
                          Utilities.showToast(
                              "Meeting mode is already set to Single Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.single);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/single_tile.svg",
                        semanticsLabel: "fl_single_mode",
                        colorFilter: ColorFilter.mode(
                            meetingStore.meetingMode == MeetingMode.single
                                ? errorColor
                                : themeDefaultColor,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Single Tile Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                meetingStore.meetingMode == MeetingMode.single
                                    ? errorColor
                                    : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
