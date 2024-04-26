//Package imports

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/leave_session_bottom_sheet.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/constants.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/role_change_request_dialog.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/track_change_request_dialog.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_disconnected_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_reconnection_toast.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';

///[UtilityComponents] contains the common components used in the app
class UtilityComponents {
  static Future<dynamic> onBackPressed(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: HMSThemeColors.surfaceDim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
          value: meetingStore,
          child: LeaveSessionBottomSheet(
            meetingStore: meetingStore,
          )),
    );

    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //     insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //     actionsPadding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
    //     backgroundColor: const Color.fromRGBO(32, 22, 23, 1),
    //     title: SizedBox(
    //       width: 300,
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           SvgPicture.asset(
    //             "packages/hms_room_kit/lib/src/assets/icons/end.svg",
    //             width: 24,
    //           ),
    //           const SizedBox(
    //             width: 5,
    //           ),
    //           Text(
    //             'Do you wish to leave?',
    //             style: HMSTextStyle.setTextStyle(
    //                 color: errorColor,
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.w600,
    //                 letterSpacing: 0.25),
    //           ),
    //         ],
    //       ),
    //     ),
    //     content: Text(
    //         "You will leave the room immediately. You can’t undo this action.",
    //         style: HMSTextStyle.setTextStyle(
    //             color: themeHintColor,
    //             fontSize: 14,
    //             fontWeight: FontWeight.w400,
    //             letterSpacing: 0.25)),
    //     actions: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           Expanded(
    //             child: ElevatedButton(
    //                 style: ButtonStyle(
    //                     shadowColor:
    //                         MaterialStateProperty.all(themeSurfaceColor),
    //                     backgroundColor: MaterialStateProperty.all(
    //                       const Color.fromRGBO(32, 22, 23, 1),
    //                     ),
    //                     shape:
    //                         MaterialStateProperty.all<RoundedRectangleBorder>(
    //                             RoundedRectangleBorder(
    //                       side: BorderSide(
    //                           width: 1, color: popupButtonBorderColor),
    //                       borderRadius: BorderRadius.circular(8.0),
    //                     ))),
    //                 onPressed: () => Navigator.pop(context, false),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 8.0, vertical: 12),
    //                   child: Text('Nevermind',
    //                       style: HMSTextStyle.setTextStyle(
    //                           color: hmsWhiteColor,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w600,
    //                           letterSpacing: 0.50)),
    //                 )),
    //           ),
    //           const SizedBox(
    //             width: 10,
    //           ),
    //           Expanded(
    //             child: ElevatedButton(
    //               style: ButtonStyle(
    //                   shadowColor: MaterialStateProperty.all(themeSurfaceColor),
    //                   backgroundColor: MaterialStateProperty.all(errorColor),
    //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                       RoundedRectangleBorder(
    //                     side: BorderSide(width: 1, color: errorColor),
    //                     borderRadius: BorderRadius.circular(8.0),
    //                   ))),
    //               onPressed: () => {
    //                 meetingStore.leave(),
    //                 Navigator.popUntil(context, (route) => route.isFirst)
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     horizontal: 8.0, vertical: 12),
    //                 child: Text(
    //                   'Leave Room',
    //                   style: HMSTextStyle.setTextStyle(
    //                       color: themeDefaultColor,
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w600,
    //                       letterSpacing: 0.50),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

  static Future<dynamic> onLeaveStudio(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        backgroundColor: themeBottomSheetColor,
        title: SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/leave_hls.svg",
                height: 24,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Leave Studio',
                style: HMSTextStyle.setTextStyle(
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
            style: HMSTextStyle.setTextStyle(
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
                      child: HMSTitleText(
                          text: 'Don’t Leave', textColor: themeDefaultColor),
                    )),
              ),
              const SizedBox(
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
                    meetingStore.leave(),
                    Navigator.popUntil(context, (route) => route.isFirst)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 12),
                    child: HMSTitleText(
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
    MeetingStore meetingStore = context.read<MeetingStore>();
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => TrackChangeRequestDialog(
              trackChangeRequest: trackChangeRequest,
              meetingStore: context.read<MeetingStore>(),
              isAudioModeOn: meetingStore.meetingMode == MeetingMode.audio,
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
              style: HMSTextStyle.setTextStyle(
                color: iconColor,
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text(
                  'OK',
                  style: HMSTextStyle.setTextStyle(),
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    autofocus: true,
                    controller: textController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        hintText: placeholder),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: Text(
                    'Cancel',
                    style: HMSTextStyle.setTextStyle(),
                  ),
                  onPressed: () {
                    Navigator.pop(context, '');
                  },
                ),
                ElevatedButton(
                  child: Text(
                    'OK',
                    style: HMSTextStyle.setTextStyle(),
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
    MeetingStore meetingStore = context.read<MeetingStore>();
    await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Recording"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Single file per layer",
                          style: HMSTextStyle.setTextStyle(
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
                          style: HMSTextStyle.setTextStyle(
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
                actions: [
                  ElevatedButton(
                    child: Text(
                      'Cancel',
                      style: HMSTextStyle.setTextStyle(),
                    ),
                    onPressed: () {
                      Navigator.pop(context, '');
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      'OK',
                      style: HMSTextStyle.setTextStyle(),
                    ),
                    onPressed: () {
                      if (textController.text == "") {
                      } else {
                        meetingStore.startHLSStreaming(
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
      MeetingStore meetingStore) async {
    List<HMSRole> selectedRoles = [];
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
                  style: HMSTextStyle.setTextStyle(
                    color: iconColor,
                  ),
                ),
                content: SizedBox(
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
                                      style: HMSTextStyle.setTextStyle(
                                        color: iconColor,
                                      ),
                                    ),
                                    Checkbox(
                                        value: selectedRoles
                                            .contains(roles[index]),
                                        activeColor: Colors.blue,
                                        onChanged: (bool? value) {
                                          if (value != null && value) {
                                            selectedRoles.add(roles[index]);
                                          } else if (selectedRoles
                                              .contains(roles[index])) {
                                            selectedRoles.remove(roles[index]);
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
                                style: HMSTextStyle.setTextStyle(
                                    color: Colors.red),
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
                                    style: HMSTextStyle.setTextStyle(),
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
                                      meetingStore.changeTrackStateForRole(
                                          true, null);
                                    } else if (selectedRoles.isNotEmpty) {
                                      meetingStore.changeTrackStateForRole(
                                          true, selectedRoles);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Mute",
                                    style: HMSTextStyle.setTextStyle(),
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
      MeetingStore meetingStore) async {
    List<HMSRole> selectedRoles = [];
    HMSRole toRole = roles[0];

    void updateDropDownValue(dynamic newValue) {
      toRole = newValue;
    }

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: themeBottomSheetColor,
                title: Text(
                  "Select roles for change role",
                  style: HMSTextStyle.setTextStyle(
                    color: iconColor,
                  ),
                ),
                content: SizedBox(
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
                                      style: HMSTextStyle.setTextStyle(
                                        color: iconColor,
                                      ),
                                    ),
                                    Checkbox(
                                        value: selectedRoles
                                            .contains(roles[index]),
                                        activeColor: hmsdefaultColor,
                                        onChanged: (bool? value) {
                                          if (value != null && value) {
                                            selectedRoles.add(roles[index]);
                                          } else if (selectedRoles
                                              .contains(roles[index])) {
                                            selectedRoles.remove(roles[index]);
                                          }
                                          setState(() {});
                                        }),
                                  ],
                                );
                              }),
                          Text(
                            "Change roles to",
                            style: HMSTextStyle.setTextStyle(
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: themeSurfaceColor,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: borderColor,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                                child: HMSDropDown(
                                    dropDownItems: roles
                                        .sortedBy((element) =>
                                            element.priority.toString())
                                        .map((role) => DropdownMenuItem(
                                              value: role,
                                              child: HMSTitleText(
                                                text: role.name,
                                                textColor: themeDefaultColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ))
                                        .toList(),
                                    iconStyleData: IconStyleData(
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconEnabledColor: themeDefaultColor,
                                    ),
                                    selectedValue: toRole,
                                    updateSelectedValue: updateDropDownValue)),
                          ),
                          const SizedBox(
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
                                    style: HMSTextStyle.setTextStyle(
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
                                    if (selectedRoles.isEmpty) {
                                      Utilities.showToast(
                                          "Please select a role");
                                    } else {
                                      meetingStore.changeRoleOfPeersWithRoles(
                                          toRole, selectedRoles);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Change Role",
                                    style: HMSTextStyle.setTextStyle(
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
                contentPadding: const EdgeInsets.only(
                    left: 14, right: 10, top: 15, bottom: 15),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: textController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          hintText: placeholder),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Recording",
                          style: HMSTextStyle.setTextStyle(
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
                                side: const BorderSide(
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
                                style: HMSTextStyle.setTextStyle(
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
                            style: HMSTextStyle.setTextStyle(
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
    MeetingStore meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        backgroundColor: const Color.fromRGBO(32, 22, 23, 1),
        title: SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                width: 24,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "End Room",
                style: HMSTextStyle.setTextStyle(
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
            style: HMSTextStyle.setTextStyle(
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
                          const Color.fromRGBO(32, 22, 23, 1),
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
                          style: HMSTextStyle.setTextStyle(
                              color: themeDefaultColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50)),
                    )),
              ),
              const SizedBox(
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
                    meetingStore.endRoom(false, "Room Ended From Flutter"),
                    if (meetingStore.isRoomEnded)
                      {Navigator.popUntil(context, (route) => route.isFirst)}
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(
                      "End Room",
                      style: HMSTextStyle.setTextStyle(
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
    MeetingStore meetingStore = Provider.of<MeetingStore>(context);
    return GestureDetector(
      onTap: () {
        if (meetingStore.isScreenRotationAllowed) {
          meetingStore.allowScreenRotation(false);
        } else {
          meetingStore.allowScreenRotation(true);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
            "packages/hms_room_kit/lib/src/assets/icons/rotate.svg",
            colorFilter: ColorFilter.mode(
                meetingStore.isScreenRotationAllowed ? Colors.blue : iconColor,
                BlendMode.srcIn)),
      ),
    );
  }

  // static Future<bool> showErrorDialog(
  //     {required BuildContext context,
  //     required String errorMessage,
  //     required String errorTitle,
  //     required String actionMessage,
  //     required Function() action}) async {
  //   bool? res = await showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: () async => false,
  //           child: AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12)),
  //             insetPadding:
  //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //             backgroundColor: HMSThemeColors.backgroundDefault,
  //             title: Center(
  //               child: Text(
  //                 errorTitle,
  //                 style: HMSTextStyle.setTextStyle(
  //                     color: HMSThemeColors.alertErrorDefault,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600),
  //               ),
  //             ),
  //             content: Text(errorMessage,
  //                 style: HMSTextStyle.setTextStyle(
  //                     color: HMSThemeColors.onSurfaceHighEmphasis,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w400)),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   ElevatedButton(
  //                       style: ButtonStyle(
  //                           shadowColor: MaterialStateProperty.all(
  //                               HMSThemeColors.backgroundDefault),
  //                           backgroundColor: MaterialStateProperty.all(
  //                               HMSThemeColors.primaryDefault),
  //                           shape: MaterialStateProperty.all<
  //                               RoundedRectangleBorder>(RoundedRectangleBorder(
  //                             side: BorderSide(
  //                                 width: 1,
  //                                 color: HMSThemeColors.primaryDefault),
  //                             borderRadius: BorderRadius.circular(8.0),
  //                           ))),
  //                       onPressed: action,
  //                       child: Text(
  //                         actionMessage,
  //                         style: HMSTextStyle.setTextStyle(),
  //                       )),
  //                 ],
  //               )
  //             ],
  //           ),
  //         );
  //       });
  //   return res ?? false;
  // }

  static Widget showReconnectingDialog(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: HMSThemeColors.backgroundDefault.withOpacity(0.5),
        child: const HMSReconnectionToast());
  }

  ///This returns the error toasts whenever the error is terminal
  static Widget showFailureError(
      HMSException exception, BuildContext context, Function onLeavePressed) {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: HMSThemeColors.backgroundDefault.withOpacity(0.5),
        child: HMSDisconnectedToast(
          errorDescription:
              "CODE: ${exception.code?.errorCode}, ${exception.description}",
          onLeavePressed: onLeavePressed,
        ));
  }

  static onEndStream(
      {required BuildContext context,
      required String title,
      required String content,
      required String actionText,
      required String ignoreText,
      bool leaveRoom = false}) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        actionsPadding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        backgroundColor: const Color.fromRGBO(32, 22, 23, 1),
        title: SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                width: 24,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: HMSTextStyle.setTextStyle(
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
            style: HMSTextStyle.setTextStyle(
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
                          const Color.fromRGBO(32, 22, 23, 1),
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
                          style: HMSTextStyle.setTextStyle(
                              color: hmsWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.50)),
                    )),
              ),
              const SizedBox(
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
                    meetingStore.stopHLSStreaming(),
                    if (leaveRoom)
                      {
                        meetingStore.leave(),
                      },
                    Navigator.pop(context)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12),
                    child: Text(
                      actionText,
                      style: HMSTextStyle.setTextStyle(
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
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              backgroundColor: themeBottomSheetColor,
              title: Text("Change Name",
                  style: HMSTextStyle.setTextStyle(
                      color: themeDefaultColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.15,
                      fontSize: 20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style:
                        TextStyle(color: HMSThemeColors.onSurfaceHighEmphasis),
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
                      contentPadding:
                          const EdgeInsets.only(left: 10, right: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(107, 125, 153, 1)),
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        onPressed: () => Navigator.pop(context, ""),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 12),
                          child: Text('Cancel',
                              style: HMSTextStyle.setTextStyle(
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
                          style: HMSTextStyle.setTextStyle(
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
    MeetingStore meetingStore = context.read<MeetingStore>();

    void updateDropDownValue(dynamic newValue) {
      valueChoose = newValue;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                actionsPadding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                backgroundColor: themeBottomSheetColor,
                insetPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                contentPadding: const EdgeInsets.only(
                    top: 20, bottom: 15, left: 24, right: 24),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HMSTitleText(
                      text: "Change Audio Mixing Mode",
                      fontSize: 20,
                      letterSpacing: 0.15,
                      textColor: themeDefaultColor,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    HMSSubtitleText(
                        text: "Select Audio Mixing mode",
                        textColor: themeSubHeadingColor),
                  ],
                ),
                content: Container(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    color: themeSurfaceColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: borderColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: HMSDropDown(
                          dropDownItems: <DropdownMenuItem>[
                        DropdownMenuItem(
                          value: HMSAudioMixingMode.TALK_AND_MUSIC,
                          child: HMSTitleText(
                            text: HMSAudioMixingMode.TALK_AND_MUSIC.name,
                            textColor: themeDefaultColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownMenuItem(
                          value: HMSAudioMixingMode.TALK_ONLY,
                          child: HMSTitleText(
                            text: HMSAudioMixingMode.TALK_ONLY.name,
                            textColor: themeDefaultColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        DropdownMenuItem(
                          value: HMSAudioMixingMode.MUSIC_ONLY,
                          child: HMSTitleText(
                            text: HMSAudioMixingMode.MUSIC_ONLY.name,
                            textColor: themeDefaultColor,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                          iconStyleData: IconStyleData(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: themeDefaultColor,
                          ),
                          selectedValue: valueChoose,
                          updateSelectedValue: updateDropDownValue)),
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
                                side: const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(107, 125, 153, 1)),
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () => Navigator.pop(context, false),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            child: Text('Cancel',
                                style: HMSTextStyle.setTextStyle(
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
                          if (meetingStore.isAudioShareStarted)
                            meetingStore.setAudioMixingMode(valueChoose)
                          else
                            Utilities.showToast("Audio Share not enabled"),
                          Navigator.pop(context),
                          Navigator.pop(context)
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          child: Text(
                            'Change',
                            style: HMSTextStyle.setTextStyle(
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
}
