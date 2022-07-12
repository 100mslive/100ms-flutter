//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class UtilityComponents {
  static void showToastWithString(String message) {
    Fluttertoast.showToast(msg: message);
  }

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
                color: hintColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(surfaceColor),
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(32, 22, 23, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side:
                            BorderSide(width: 1, color: popupButtonBorderColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => Navigator.pop(context, false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text('Nevermind',
                        style: GoogleFonts.inter(
                            color: defaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50)),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(surfaceColor),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text(
                    'Leave Room',
                    style: GoogleFonts.inter(
                        color: defaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50),
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
        backgroundColor: bottomSheetColor,
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
                    color: defaultColor,
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
                color: hintColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                letterSpacing: 0.25)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(surfaceColor),
                      backgroundColor:
                          MaterialStateProperty.all(bottomSheetColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side:
                            BorderSide(width: 1, color: popupButtonBorderColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => Navigator.pop(context, false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: HLSTitleText(
                        text: 'Don’t Leave', textColor: defaultColor),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(surfaceColor),
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
                  child: HLSTitleText(
                    text: 'Leave',
                    textColor: defaultColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static void showRoleChangeDialog(HMSRoleChangeRequest? event, context) async {
    event = event as HMSRoleChangeRequest;
    String answer = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => RoleChangeDialogOrganism(roleChangeRequest: event!));
    MeetingStore meetingStore =
        Provider.of<MeetingStore>(context, listen: false);
    if (answer == "OK") {
      meetingStore.acceptChangeRole(event);
      UtilityComponents.showToastWithString(
          "Role Change to " + event.suggestedRole.name);
    } else {
      meetingStore.roleChangeRequest = null;
    }
  }

  static showTrackChangeDialog(event, context) async {
    event = event as HMSTrackChangeRequest;
    MeetingStore meetingStore =
        Provider.of<MeetingStore>(context, listen: false);
    String answer = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => TrackChangeDialogOrganism(
              trackChangeRequest: event,
              isAudioModeOn: meetingStore.meetingMode == MeetingMode.Audio,
            ));
    if (answer == "OK") {
      if (meetingStore.meetingMode == MeetingMode.Audio) {
        meetingStore.setMode(MeetingMode.Audio);
      }
      meetingStore.changeTracks(event);
    } else {
      meetingStore.hmsTrackChangeRequest = null;
    }
  }

  static showonExceptionDialog(event, context) {
    event = event as HMSException;
    var message =
        "${event.message} ${event.id ?? ""} ${event.code?.errorCode ?? ""} ${event.description} ${event.action} ${event.params ?? "".toString()}";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: bottomSheetColor,
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
              backgroundColor: bottomSheetColor,
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
    textController.text = Constant.rtmpUrl;
    bool isSingleFileChecked = false, isVODChecked = false;
    MeetingStore _meetingStore = context.read<MeetingStore>();
    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: bottomSheetColor,
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
                            hintText: "Enter HLS Url"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                            textController.text.trim(),
                            isSingleFileChecked,
                            isVODChecked);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            }));
  }

  static showRoleList(BuildContext context, List<HMSRole> roles,
      MeetingStore _meetingStore) async {
    List<HMSRole> _selectedRoles = [];
    bool muteAll = false;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: bottomSheetColor,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(),
                                  )),
                              ElevatedButton(
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
                backgroundColor: bottomSheetColor,
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
                  ElevatedButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {"url": "", "toRecord": false});
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      'OK',
                      style: GoogleFonts.inter(),
                    ),
                    onPressed: () {
                      if (textController.text != "") {
                        Navigator.pop(context, {
                          "url": textController.text,
                          "toRecord": isRecordingEnabled
                        });
                      }
                    },
                  ),
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
        backgroundColor: bottomSheetColor,
        title: Text(
          'End Room?',
          style: GoogleFonts.inter(
              color: iconColor, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: errorColor,
              ),
              onPressed: () {
                _meetingStore.endRoom(false, "Room Ended From Flutter");
                if (_meetingStore.isRoomEnded) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              child: Text('Yes', style: GoogleFonts.inter(fontSize: 24))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(fontSize: 24),
            ),
          ),
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
      required String errorTitle}) async {
    bool res = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: bottomSheetColor,
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
                    color: defaultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
            actions: [
              ElevatedButton(
                  child: Text(
                    'OK',
                    style: GoogleFonts.inter(),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  })
            ],
          );
        });
    return res;
  }

  static onEndStream(
      {required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required String ignoreText}) {
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
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(surfaceColor),
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(32, 22, 23, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        side:
                            BorderSide(width: 1, color: popupButtonBorderColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(ignoreText,
                        style: GoogleFonts.inter(
                            color: defaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50)),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(surfaceColor),
                    backgroundColor: MaterialStateProperty.all(errorColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: errorColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: () =>
                    {_meetingStore.stopHLSStreaming(), Navigator.pop(context)},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Text(
                    actionText,
                    style: GoogleFonts.inter(
                        color: defaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50),
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
              backgroundColor: bottomSheetColor,
              title: Text("Change Name",
                  style: GoogleFonts.inter(
                      color: defaultColor,
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
                          : Navigator.pop(context, textController.text),
                      autofocus: true,
                      controller: textController,
                      decoration: InputDecoration(
                        fillColor: surfaceColor,
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
                                MaterialStateProperty.all(surfaceColor),
                            backgroundColor:
                                MaterialStateProperty.all(bottomSheetColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(107, 125, 153, 1)),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () => Navigator.pop(context, false),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 12),
                          child: Text('Cancel',
                              style: GoogleFonts.inter(
                                  color: defaultColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.50)),
                        )),
                    ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(surfaceColor),
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
                          {Navigator.pop(context, textController.text)}
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 12),
                        child: Text(
                          'Change',
                          style: GoogleFonts.inter(
                              color: defaultColor,
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
}
