import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/hls_aspect_ratio_option_dialog.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/bottom_sheets/participants_bottom_sheet.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;

import 'notification_settings_bottom_sheet.dart';

class ViewerSettingsBottomSheet extends StatefulWidget {
  @override
  State<ViewerSettingsBottomSheet> createState() =>
      _ViewerSettingsBottomSheetState();
}

class _ViewerSettingsBottomSheetState extends State<ViewerSettingsBottomSheet> {
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
                            child: ParticipantsBottomSheet()),
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
                                "assets/icons/participants.svg",
                                color: themeDefaultColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                          key:  GlobalKey<ScaffoldState>(),
                                availableAspectRatios: [
                                  "16:9",
                                  "4:3",
                                  "1:1",
                                  "3:4",
                                  "9:16"
                                ],
                          meetingStore: context.read<MeetingStore>(),));
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
                            "assets/icons/aspect_ratio.svg",
                            color: themeDefaultColor,
                          ),
                          SizedBox(
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
              SizedBox(
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
                    "assets/icons/hand_outline.svg",
                    fit: BoxFit.scaleDown,
                    color: context.read<MeetingStore>().isRaisedHand
                        ? errorColor
                        : themeDefaultColor,
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
                        builder: (ctx) => NotificationSettingsBottomSheet());
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "assets/icons/notification.svg",
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
            ],
          ),
        ),
      ),
    );
  }
}
