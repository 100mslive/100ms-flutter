import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/enums/meeting_mode.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
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
                      "packages/hms_room_kit/lib/assets/icons/close_button.svg",
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
                        if (meetingStore.meetingMode == MeetingMode.Grid) {
                          Utilities.showToast(
                              "Meeting mode is already set to Grid View");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.Grid);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/role_change.svg",
                        semanticsLabel: "fl_normal_mode",
                        color: (meetingStore.meetingMode == MeetingMode.Grid)
                            ? colorScheme.error
                            : themeDefaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Normal Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                (meetingStore.meetingMode == MeetingMode.Grid)
                                    ? colorScheme.error
                                    : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode ==
                            MeetingMode.ActiveSpeaker) {
                          Utilities.showToast(
                              "Meeting mode is already set to Active Speaker");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.ActiveSpeaker);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/participants.svg",
                        semanticsLabel: "fl_active_speaker_mode",
                        color: (meetingStore.meetingMode ==
                                MeetingMode.ActiveSpeaker)
                            ? colorScheme.error
                            : themeDefaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Active Speaker Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: (meetingStore.meetingMode ==
                                    MeetingMode.ActiveSpeaker)
                                ? colorScheme.error
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.OneToOne) {
                          Utilities.showToast(
                              "Meeting mode is already set to One to one Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.OneToOne);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/participants.svg",
                        semanticsLabel: "fl_one_to_one_mode",
                        color:
                            (meetingStore.meetingMode == MeetingMode.OneToOne)
                                ? colorScheme.error
                                : themeDefaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "One to One Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: (meetingStore.meetingMode ==
                                    MeetingMode.OneToOne)
                                ? colorScheme.error
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.Audio) {
                          Utilities.showToast(
                              "Meeting mode is already set to Audio Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.Audio);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        'packages/hms_room_kit/lib/assets/icons/mic_state_on.svg',
                        color: meetingStore.meetingMode == MeetingMode.Audio
                            ? colorScheme.error
                            : themeDefaultColor,
                        semanticsLabel: "fl_audio_video_view",
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Audio View",
                        semanticsLabel: "fl_audio_video_mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: meetingStore.meetingMode == MeetingMode.Audio
                                ? colorScheme.error
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.Hero) {
                          Utilities.showToast(
                              "Meeting mode is already set to Hero Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.Hero);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/participants.svg",
                        semanticsLabel: "fl_hero_mode",
                        color: meetingStore.meetingMode == MeetingMode.Hero
                            ? colorScheme.error
                            : themeDefaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Hero Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: meetingStore.meetingMode == MeetingMode.Hero
                                ? colorScheme.error
                                : themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        if (meetingStore.meetingMode == MeetingMode.Single) {
                          Utilities.showToast(
                              "Meeting mode is already set to Single Mode");
                          return;
                        }
                        meetingStore.setMode(MeetingMode.Single);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/single_tile.svg",
                        semanticsLabel: "fl_single_mode",
                        color: meetingStore.meetingMode == MeetingMode.Single
                            ? colorScheme.error
                            : themeDefaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                      title: Text(
                        "Single Tile Mode",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color:
                                meetingStore.meetingMode == MeetingMode.Single
                                    ? colorScheme.error
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
