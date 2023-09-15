import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/hls_aspect_ratio_option_dialog.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

import 'notification_settings_bottom_sheet.dart';

class ViewerSettingsBottomSheet extends StatefulWidget {
  const ViewerSettingsBottomSheet({super.key});

  @override
  State<ViewerSettingsBottomSheet> createState() =>
      _ViewerSettingsBottomSheetState();
}

class _ViewerSettingsBottomSheetState extends State<ViewerSettingsBottomSheet> {
  bool isStatsEnabled = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: SingleChildScrollView(
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
                          "packages/hms_room_kit/lib/src/assets/icons/close_button.svg",
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
                                badgeColor: hmsdefaultColor,
                                padding: EdgeInsets.all(
                                    context.read<MeetingStore>().peers.length <
                                            1000
                                        ? 5
                                        : 8)),
                            badgeContent: Text(context
                                .read<MeetingStore>()
                                .peers
                                .length
                                .toString()),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  (context.read<MeetingStore>().peers.length <
                                          1000
                                      ? 5
                                      : 10)),
                              child: SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
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
                      showDialog(
                          context: context,
                          builder: (_) => AspectRatioOptionDialog(
                                //Default mode takes the height and width of the device and
                                //sets up the player according to device height and width
                                availableAspectRatios: const [
                                  "Default",
                                  "16:9",
                                  "4:3",
                                  "1:1",
                                  "3:4",
                                  "9:16"
                                ],
                                meetingStore: context.read<MeetingStore>(),
                              ));
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
                            "packages/hms_room_kit/lib/src/assets/icons/aspect_ratio.svg",
                            colorFilter: ColorFilter.mode(
                                themeDefaultColor, BlendMode.srcIn),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Set Aspect Ratio",
                            semanticsLabel: "fl_aspect_ratio",
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  String name = await UtilityComponents.showNameChangeDialog(
                      context: context,
                      placeholder: "Enter Name",
                      prefilledValue:
                          context.read<MeetingStore>().localPeer?.name ?? "");

                  if (name.isNotEmpty && mounted) {
                    context.read<MeetingStore>().changeName(name: name);
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                  fit: BoxFit.scaleDown,
                ),
                title: Text(
                  "Change Name",
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
                    context.read<MeetingStore>().changeMetadata();
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(
                        context.read<MeetingStore>().isRaisedHand
                            ? errorColor
                            : themeDefaultColor,
                        BlendMode.srcIn),
                  ),
                  title: Text(
                    "Raise Hand",
                    semanticsLabel: "hand_raise_button",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: context.read<MeetingStore>().isRaisedHand
                            ? errorColor
                            : themeDefaultColor,
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
                    "packages/hms_room_kit/lib/src/assets/icons/notification.svg",
                    fit: BoxFit.scaleDown,
                    colorFilter:
                        ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
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
              if (Platform.isAndroid)
                ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      // context.read<MeetingStore>().enterPipModeOnAndroid();
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                      fit: BoxFit.scaleDown,
                      colorFilter:
                          ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
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
            ],
          ),
        ),
      ),
    );
  }
}
