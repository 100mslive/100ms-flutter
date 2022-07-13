//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
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
        title: Text(
          'Leave Room?',
          style: GoogleFonts.inter(
              color: iconColor, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () => {
                    _meetingStore.leave(),
                    Navigator.popUntil(context, (route) => route.isFirst)
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
        title: Text(
          'End Room?',
          style: GoogleFonts.inter(
              color: iconColor, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
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

  static showErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Wrong Meeting Url",
                  style: GoogleFonts.inter(
                      color: Colors.red.shade300,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Text("Please enter a valid meeting URL",
                style: GoogleFonts.inter(
                    color: defaultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400)),
          );
        });
  }
}
