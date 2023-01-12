import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';

class NotificationSettings extends StatefulWidget {
  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool peerJoinedNotif = true;
  bool peerLeaveNotif = true;
  bool newMessageNotif = true;
  bool handRaiseNotif = true;
  bool errorNotif = true;
  @override
  void initState() {
    super.initState();
    getAppSettings();
  }

  Future<void> getAppSettings() async {
    peerJoinedNotif =
        await Utilities.getBoolData(key: 'peer-join-notif') ?? true;
    peerLeaveNotif =
        await Utilities.getBoolData(key: 'peer-leave-notif') ?? true;
    newMessageNotif =
        await Utilities.getBoolData(key: 'new-message-notif') ?? true;
    handRaiseNotif =
        await Utilities.getBoolData(key: 'hand-raise-notif') ?? true;
    errorNotif = await Utilities.getBoolData(key: 'error-notif') ?? true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      "Notifications",
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
                        // color: defaultColor,
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
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/person.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Peer Joined",
                      semanticsLabel: "fl_peer_join_notif",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: peerJoinedNotif,
                        onChanged: (value) => {
                              peerJoinedNotif = value,
                              Utilities.saveBoolData(
                                  key: 'peer-join-notif', value: value),
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/end_room.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Peer Left",
                      semanticsLabel: "fl_peer_leave_notif",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: peerLeaveNotif,
                        onChanged: (value) => {
                              peerLeaveNotif = value,
                              Utilities.saveBoolData(
                                  key: 'peer-leave-notif', value: value),
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/message_badge_off.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "New Message",
                      semanticsLabel: "fl_new-message_notif",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: newMessageNotif,
                        onChanged: (value) => {
                              newMessageNotif = value,
                              Utilities.saveBoolData(
                                  key: 'new-message-notif', value: value),
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/icons/hand_outline.svg',
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Hand Raise",
                      semanticsLabel: "fl_hand_raise_notif",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: handRaiseNotif,
                        onChanged: (value) => {
                              handRaiseNotif = value,
                              Utilities.saveBoolData(
                                  key: 'hand-raise-notif', value: value),
                              setState(() {})
                            }),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    enabled: false,
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      'assets/icons/warning.svg',
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Error",
                      semanticsLabel: "fl_error_notif",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: CupertinoSwitch(
                        activeColor: hmsdefaultColor,
                        value: errorNotif,
                        onChanged: (value) => {
                              errorNotif = value,
                              Utilities.saveBoolData(
                                  key: 'error-notif', value: value),
                              setState(() {})
                            }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
