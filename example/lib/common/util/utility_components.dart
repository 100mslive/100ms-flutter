//Package imports

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/app_dialogs/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/service/constant.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:collection/collection.dart';

class UtilityComponents {
  static Future<dynamic> onBackPressed(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        backgroundColor: Color.fromRGBO(32, 22, 23, 1),
        title: Container(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/end.svg",
                width: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Do you wish to leave?',
                style: GoogleFonts.inter(
                    color: errorColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.25),
              ),
            ],
          ),
        ),
        content: Text(
            "You will leave the room immediately. You can’t undo this action.",
            style: GoogleFonts.inter(
                color: themeHintColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(themeSurfaceColor),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(32, 22, 23, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: popupButtonBorderColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () => Navigator.pop(context, false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Text('Nevermind',
                          style: GoogleFonts.inter(
                              color: hmsWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50)),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                      backgroundColor: MaterialStateProperty.all(errorColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: errorColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => {
                    _meetingStore.leave(),
                    Navigator.popUntil(context, (route) => route.isFirst)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(
                      'Leave Room',
                      style: GoogleFonts.inter(
                          color: themeDefaultColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static Future<dynamic> onLeaveStudio(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        backgroundColor: themeBottomSheetColor,
        title: Container(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/leave_hls.svg",
                height: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Leave Studio',
                style: GoogleFonts.inter(
                    color: themeDefaultColor,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15),
              ),
            ],
          ),
        ),
        content: Text(
            "Others will continue after you leave. You can join the studio again.",
            style: GoogleFonts.inter(
                color: themeHintColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(themeSurfaceColor),
                        backgroundColor:
                            MaterialStateProperty.all(themeBottomSheetColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: popupButtonBorderColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () => Navigator.pop(context, false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: TitleText(
                          text: 'Don’t Leave', textColor: themeDefaultColor),
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                      backgroundColor: MaterialStateProperty.all(errorColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: errorColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => {
                    _meetingStore.leave(),
                    Navigator.popUntil(context, (route) => route.isFirst)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 12),
                    child: TitleText(
                      text: 'Leave',
                      textColor: hmsWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static void showRoleChangeDialog(
      HMSRoleChangeRequest event, BuildContext context) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => RoleChangeRequestDialog(
            roleChangeRequest: event,
            meetingStore: context.read<MeetingStore>()));
  }

  static showTrackChangeDialog(
      BuildContext context, HMSTrackChangeRequest trackChangeRequest) async {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => TrackChangeRequestDialog(
              trackChangeRequest: trackChangeRequest,
              meetingStore: context.read<MeetingStore>(),
              isAudioModeOn: _meetingStore.meetingMode == MeetingMode.Audio,
            ));
  }

  static showonExceptionDialog(event, BuildContext context) {
    event = event as HMSException;
    var message =
        "${event.message} ${event.id ?? ""} ${event.code?.errorCode ?? ""} ${event.description} ${event.action} ${event.params ?? "".toString()}";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: themeBottomSheetColor,
            content: Text(
              message,
              style: GoogleFonts.inter(
                color: iconColor,
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.inter(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  static Future<String> showInputDialog(
      {context, String placeholder = "", String prefilledValue = ""}) async {
    TextEditingController textController = TextEditingController();
    if (prefilledValue.isNotEmpty) {
      textController.text = prefilledValue;
    }
    String answer = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              backgroundColor: themeBottomSheetColor,
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: textController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          hintText: placeholder),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(),
                  ),
                  onPressed: () {
                    Navigator.pop(context, '');
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'OK',
                    style: GoogleFonts.inter(),
                  ),
                  onPressed: () {
                    if (textController.text == "") {
                    } else {
                      Navigator.pop(context, textController.text);
                    }
                  },
                ),
              ],
            ));

    return answer;
  }

  static showHLSDialog({required BuildContext context}) async {
    TextEditingController textController = TextEditingController();
    textController.text = Constant.streamingUrl;
    bool isSingleFileChecked = false, isVODChecked = false;
    MeetingStore _meetingStore = context.read<MeetingStore>();
    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Recording"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Single file per layer",
                            style: GoogleFonts.inter(
                              color: iconColor,
                            ),
                          ),
                          Checkbox(
                              value: isSingleFileChecked,
                              activeColor: Colors.blue,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  isSingleFileChecked = value;
                                  setState(() {});
                                }
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Video on Demand",
                            style: GoogleFonts.inter(
                              color: iconColor,
                            ),
                          ),
                          Checkbox(
                              value: isVODChecked,
                              activeColor: Colors.blue,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  isVODChecked = value;
                                  setState(() {});
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      Navigator.pop(context, '');
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      if (textController.text == "") {
                      } else {
                        _meetingStore.startHLSStreaming(
                            isSingleFileChecked, isVODChecked);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            }));
  }

  static showRoleListForMute(BuildContext context, List<HMSRole> roles,
      MeetingStore _meetingStore) async {
    List<HMSRole> _selectedRoles = [];
    bool muteAll = false;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                title: Text(
                  "Select Role for Mute",
                  style: GoogleFonts.inter(
                    color: iconColor,
                  ),
                ),
                content: Container(
                    width: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: roles.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      roles[index].name,
                                      style: GoogleFonts.inter(
                                        color: iconColor,
                                      ),
                                    ),
                                    Checkbox(
                                        value: _selectedRoles
                                            .contains(roles[index]),
                                        activeColor: Colors.blue,
                                        onChanged: (bool? value) {
                                          if (value != null && value) {
                                            _selectedRoles.add(roles[index]);
                                          } else if (_selectedRoles
                                              .contains(roles[index])) {
                                            _selectedRoles.remove(roles[index]);
                                          }
                                          setState(() {});
                                        }),
                                  ],
                                );
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mute All",
                                style: GoogleFonts.inter(color: Colors.red),
                              ),
                              Checkbox(
                                  value: muteAll,
                                  activeColor: Colors.blue,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      muteAll = value;
                                    }
                                    setState(() {});
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shadowColor: MaterialStateProperty.all(
                                          themeSurfaceColor),
                                      backgroundColor:
                                          MaterialStateProperty.all(errorColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: errorColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(),
                                  )),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shadowColor: MaterialStateProperty.all(
                                          themeSurfaceColor),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              hmsdefaultColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: hmsdefaultColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  onPressed: () {
                                    if (muteAll) {
                                      _meetingStore.changeTrackStateForRole(
                                          true, null);
                                    } else if (_selectedRoles.isNotEmpty) {
                                      _meetingStore.changeTrackStateForRole(
                                          true, _selectedRoles);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Mute",
                                    style: GoogleFonts.inter(),
                                  ))
                            ],
                          )
                        ],
                      ),
                    )),
              );
            }));
  }

  static showDialogForBulkRoleChange(BuildContext context, List<HMSRole> roles,
      MeetingStore _meetingStore) async {
    double width = MediaQuery.of(context).size.width;
    List<HMSRole> _selectedRoles = [];
    HMSRole toRole = roles[0];
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                title: Text(
                  "Select roles for change role",
                  style: GoogleFonts.inter(
                    color: iconColor,
                  ),
                ),
                content: Container(
                    width: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: roles.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      roles[index].name,
                                      style: GoogleFonts.inter(
                                        color: iconColor,
                                      ),
                                    ),
                                    Checkbox(
                                        value: _selectedRoles
                                            .contains(roles[index]),
                                        activeColor: hmsdefaultColor,
                                        onChanged: (bool? value) {
                                          if (value != null && value) {
                                            _selectedRoles.add(roles[index]);
                                          } else if (_selectedRoles
                                              .contains(roles[index])) {
                                            _selectedRoles.remove(roles[index]);
                                          }
                                          setState(() {});
                                        }),
                                  ],
                                );
                              }),
                          Text(
                            "Change roles to",
                            style: GoogleFonts.inter(
                              color: iconColor,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: themeSurfaceColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: borderColor,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                              isExpanded: true,
                              dropdownWidth: width * 0.7,
                              buttonWidth: width * 0.7,
                              buttonHeight: 48,
                              itemHeight: 48,
                              value: toRole,
                              icon: Icon(Icons.keyboard_arrow_down),
                              buttonDecoration: BoxDecoration(
                                color: themeSurfaceColor,
                              ),
                              dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: themeSurfaceColor,
                                  border: Border.all(color: borderColor)),
                              offset: Offset(-10, -10),
                              iconEnabledColor: themeDefaultColor,
                              selectedItemHighlightColor: hmsdefaultColor,
                              onChanged: (dynamic newvalue) {
                                setState(() {
                                  toRole = newvalue;
                                });
                              },
                              items: roles
                                  .sortedBy(
                                      (element) => element.priority.toString())
                                  .map((role) => DropdownMenuItem(
                                        child: TitleText(
                                          text: role.name,
                                          textColor: themeDefaultColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        value: role,
                                      ))
                                  .toList(),
                            )),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shadowColor: MaterialStateProperty.all(
                                          themeSurfaceColor),
                                      backgroundColor:
                                          MaterialStateProperty.all(errorColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: errorColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                  )),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      shadowColor: MaterialStateProperty.all(
                                          themeSurfaceColor),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              hmsdefaultColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1, color: hmsdefaultColor),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ))),
                                  onPressed: () {
                                    if (_selectedRoles.isEmpty) {
                                      Utilities.showToast(
                                          "Please select a role");
                                    } else {
                                      _meetingStore.changeRoleOfPeersWithRoles(
                                          toRole, _selectedRoles);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Change Role",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          )
                        ],
                      ),
                    )),
              );
            }));
  }

  static Future<Map<String, dynamic>> showRTMPInputDialog(
      {context,
      String placeholder = "",
      String prefilledValue = "",
      bool isRecordingEnabled = false}) async {
    TextEditingController textController = TextEditingController();
    if (prefilledValue.isNotEmpty) {
      textController.text = prefilledValue;
    }
    Map<String, dynamic> answer = await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                contentPadding:
                    EdgeInsets.only(left: 14, right: 10, top: 15, bottom: 15),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        controller: textController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            hintText: placeholder),
                      ),
                      CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Recording",
                            style: GoogleFonts.inter(
                              color: iconColor,
                            ),
                          ),
                          activeColor: Colors.blue,
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: isRecordingEnabled,
                          onChanged: (bool? value) {
                            setState(() {
                              isRecordingEnabled = value ?? false;
                            });
                          })
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(themeSurfaceColor),
                              backgroundColor: MaterialStateProperty.all(
                                  themeBottomSheetColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(107, 125, 153, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () => Navigator.pop(
                              context, {"url": "", "toRecord": false}),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 12),
                            child: Text('Cancel',
                                style: GoogleFonts.inter(
                                    color: themeDefaultColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.50)),
                          )),
                      ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(themeSurfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(hmsdefaultColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 1, color: hmsdefaultColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () => {
                          if (textController.text != "")
                            {
                              Navigator.pop(context, {
                                "url": textController.text,
                                "toRecord": isRecordingEnabled
                              })
                            }
                          else if (isRecordingEnabled)
                            {
                              Navigator.pop(context,
                                  {"url": "", "toRecord": isRecordingEnabled})
                            }
                          else
                            {
                              Utilities.showToast(
                                  "Please enter RTMP URLs or enable recording")
                            }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 12),
                          child: Text(
                            'Start RTMP',
                            style: GoogleFonts.inter(
                                color: hmsWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }));

    return answer;
  }

  static Future<dynamic> onEndRoomPressed(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        backgroundColor: Color.fromRGBO(32, 22, 23, 1),
        title: Container(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/end_warning.svg",
                width: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "End Room",
                style: GoogleFonts.inter(
                    color: errorColor,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15),
              ),
            ],
          ),
        ),
        content: Text(
            "The session will end for everyone and all the activities will stop. You can’t undo this action.",
            style: GoogleFonts.inter(
                color: dialogcontentColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(themeSurfaceColor),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(32, 22, 23, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: popupButtonBorderColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () => Navigator.pop(context, false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Text("Don't End",
                          style: GoogleFonts.inter(
                              color: themeDefaultColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50)),
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                      backgroundColor: MaterialStateProperty.all(errorColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: errorColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => {
                    _meetingStore.endRoom(false, "Room Ended From Flutter"),
                    if (_meetingStore.isRoomEnded)
                      {Navigator.popUntil(context, (route) => route.isFirst)}
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(
                      "End Room",
                      style: GoogleFonts.inter(
                          color: hmsWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static Widget rotateScreen(BuildContext context) {
    MeetingStore _meetingStore = Provider.of<MeetingStore>(context);
    return GestureDetector(
      onTap: () {
        if (_meetingStore.isLandscapeLocked)
          _meetingStore.setLandscapeLock(false);
        else {
          _meetingStore.setLandscapeLock(true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          "assets/icons/rotate.svg",
          color: _meetingStore.isLandscapeLocked ? Colors.blue : iconColor,
        ),
      ),
    );
  }

  static Future<bool> showErrorDialog(
      {required BuildContext context,
      required String errorMessage,
      required String errorTitle,
      required String actionMessage,
      required Function() action}) async {
    bool? res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              backgroundColor: themeBottomSheetColor,
              title: Center(
                child: Text(
                  errorTitle,
                  style: GoogleFonts.inter(
                      color: Colors.red.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              content: Text(errorMessage,
                  style: GoogleFonts.inter(
                      color: themeDefaultColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(themeSurfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(hmsdefaultColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 1, color: hmsdefaultColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        child: Text(
                          actionMessage,
                          style: GoogleFonts.inter(),
                        ),
                        onPressed: action),
                  ],
                )
              ],
            ),
          );
        });
    return res ?? false;
  }

  static Widget showReconnectingDialog(BuildContext context,
      {String alertMessage = "Leave Room"}) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: themeBottomSheetColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              "Reconnecting...",
              style: GoogleFonts.inter(
                  color: Colors.red.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            LinearProgressIndicator(
              color: hmsdefaultColor,
            ),
            SizedBox(
              height: 15,
            ),
            Text('Oops, No internet Connection.\nReconnecting...',
                style: GoogleFonts.inter(
                    color: themeDefaultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                    backgroundColor: MaterialStateProperty.all(hmsdefaultColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: hmsdefaultColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                child: Text(
                  alertMessage,
                  style: GoogleFonts.inter(),
                ),
                onPressed: () {
                  context.read<MeetingStore>().leave();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                })
          ]),
        ),
      ),
    );
  }

  static onEndStream(
      {required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required String ignoreText,
      bool leaveRoom = false}) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        backgroundColor: Color.fromRGBO(32, 22, 23, 1),
        title: Container(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/icons/end_warning.svg",
                width: 24,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                    color: errorColor,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.15),
              ),
            ],
          ),
        ),
        content: Text(content,
            style: GoogleFonts.inter(
                color: dialogcontentColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(themeSurfaceColor),
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(32, 22, 23, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1, color: popupButtonBorderColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 12),
                      child: Text(ignoreText,
                          style: GoogleFonts.inter(
                              color: hmsWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50)),
                    )),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                      backgroundColor: MaterialStateProperty.all(errorColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: errorColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => {
                    _meetingStore.stopHLSStreaming(),
                    if (leaveRoom)
                      {
                        _meetingStore.leave(),
                      },
                    Navigator.pop(context)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(
                      actionText,
                      style: GoogleFonts.inter(
                          color: themeDefaultColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.50),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static Future<String> showNameChangeDialog(
      {context, String placeholder = "", String prefilledValue = ""}) async {
    TextEditingController textController =
        TextEditingController(text: prefilledValue);
    if (prefilledValue.isNotEmpty) {
      textController.text = prefilledValue;
    }
    String answer = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              backgroundColor: themeBottomSheetColor,
              title: Text("Change Name",
                  style: GoogleFonts.inter(
                      color: themeDefaultColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                      fontSize: 20)),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) => (textController.text == "")
                          ? Utilities.showToast("Name can't be empty")
                          : Navigator.pop(context, textController.text.trim()),
                      autofocus: true,
                      controller: textController,
                      decoration: InputDecoration(
                        fillColor: themeSurfaceColor,
                        filled: true,
                        hintText: "Enter Name",
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: borderColor, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(themeSurfaceColor),
                            backgroundColor: MaterialStateProperty.all(
                                themeBottomSheetColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(107, 125, 153, 1)),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () => Navigator.pop(context, ""),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 12),
                          child: Text('Cancel',
                              style: GoogleFonts.inter(
                                  color: themeDefaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.50)),
                        )),
                    ElevatedButton(
                      style: ButtonStyle(
                          shadowColor:
                              MaterialStateProperty.all(themeSurfaceColor),
                          backgroundColor:
                              MaterialStateProperty.all(hmsdefaultColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: hmsdefaultColor),
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () => {
                        if (textController.text == "")
                          {
                            Utilities.showToast("Name can't be empty"),
                          }
                        else
                          {Navigator.pop(context, textController.text.trim())}
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 12),
                        child: Text(
                          'Change',
                          style: GoogleFonts.inter(
                              color: hmsWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));

    return answer;
  }

  static void showChangeAudioMixingModeDialog(BuildContext context) {
    HMSAudioMixingMode valueChoose = HMSAudioMixingMode.TALK_AND_MUSIC;
    double width = MediaQuery.of(context).size.width;
    MeetingStore _meetingStore = context.read<MeetingStore>();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                actionsPadding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10),
                backgroundColor: themeBottomSheetColor,
                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                contentPadding:
                    EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      text: "Change Audio Mixing Mode",
                      fontSize: 20,
                      letterSpacing: 0.15,
                      textColor: themeDefaultColor,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SubtitleText(
                        text: "Select Audio Mixing mode",
                        textColor: themeSubHeadingColor),
                  ],
                ),
                content: Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    color: themeSurfaceColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: borderColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    isExpanded: true,
                    dropdownWidth: width * 0.7,
                    buttonWidth: width * 0.7,
                    buttonHeight: 48,
                    itemHeight: 48,
                    value: valueChoose,
                    icon: Icon(Icons.keyboard_arrow_down),
                    buttonDecoration: BoxDecoration(
                      color: themeSurfaceColor,
                    ),
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: themeSurfaceColor,
                        border: Border.all(color: borderColor)),
                    offset: Offset(-10, -10),
                    iconEnabledColor: themeDefaultColor,
                    selectedItemHighlightColor: hmsdefaultColor,
                    onChanged: (dynamic newvalue) {
                      setState(() {
                        valueChoose = newvalue;
                      });
                    },
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: TitleText(
                          text: HMSAudioMixingMode.TALK_AND_MUSIC.name,
                          textColor: themeDefaultColor,
                          fontWeight: FontWeight.w400,
                        ),
                        value: HMSAudioMixingMode.TALK_AND_MUSIC,
                      ),
                      DropdownMenuItem(
                        child: TitleText(
                          text: HMSAudioMixingMode.TALK_ONLY.name,
                          textColor: themeDefaultColor,
                          fontWeight: FontWeight.w400,
                        ),
                        value: HMSAudioMixingMode.TALK_ONLY,
                      ),
                      DropdownMenuItem(
                        child: TitleText(
                          text: HMSAudioMixingMode.MUSIC_ONLY.name,
                          textColor: themeDefaultColor,
                          fontWeight: FontWeight.w400,
                        ),
                        value: HMSAudioMixingMode.MUSIC_ONLY,
                      )
                    ],
                  )),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(themeSurfaceColor),
                              backgroundColor: MaterialStateProperty.all(
                                  themeBottomSheetColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(107, 125, 153, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () => Navigator.pop(context, false),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            child: Text('Cancel',
                                style: GoogleFonts.inter(
                                    color: themeDefaultColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.50)),
                          )),
                      ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(themeSurfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(hmsdefaultColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 1, color: hmsdefaultColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () => {
                          if (_meetingStore.isAudioShareStarted)
                            _meetingStore.setAudioMixingMode(valueChoose)
                          else
                            Utilities.showToast("Audio Share not enabled"),
                          Navigator.pop(context),
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          child: Text(
                            'Change',
                            style: GoogleFonts.inter(
                                color: themeDefaultColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }));
  }

  static Future<String> showAudioShareDialog(
      {required BuildContext context,
      required MeetingStore meetingStore,
      required bool isPlaying}) async {
    double volume = meetingStore.audioPlayerVolume;
    String answer = await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                contentPadding:
                    EdgeInsets.only(left: 14, right: 10, top: 15, bottom: 15),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isPlaying ? "Stop playing" : "Pick song from files"),
                    SizedBox(height: 10),
                    if (isPlaying)
                      Column(
                        children: [
                          Text("Volume: ${(volume * 100).truncate()}"),
                          Slider(
                            min: 0.0,
                            max: 1.0,
                            value: volume,
                            onChanged: (value) {
                              setState(() {
                                volume = value;
                                meetingStore.setAudioPlayerVolume(volume);
                              });
                            },
                          ),
                        ],
                      )
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              shadowColor:
                                  MaterialStateProperty.all(themeSurfaceColor),
                              backgroundColor: MaterialStateProperty.all(
                                  themeBottomSheetColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(107, 125, 153, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () => Navigator.pop(context, ""),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 12),
                            child: Text('Cancel',
                                style: GoogleFonts.inter(
                                    color: themeDefaultColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.50)),
                          )),
                      ElevatedButton(
                        style: ButtonStyle(
                            shadowColor:
                                MaterialStateProperty.all(themeSurfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(hmsdefaultColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side:
                                  BorderSide(width: 1, color: hmsdefaultColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () async {
                          if (isPlaying) {
                            meetingStore.stopAudioIos();
                            Navigator.pop(context, "");
                          } else {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              String? path =
                                  "file://" + result.files.single.path!;

                              Navigator.pop(context, path);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 12),
                          child: Text(
                            isPlaying ? 'Stop' : 'Select',
                            style: GoogleFonts.inter(
                                color: themeDefaultColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.50),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }));

    return answer;
  }
}
