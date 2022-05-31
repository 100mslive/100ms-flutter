//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/enum/meeting_mode.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/role_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/track_change_request_dialog.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_tile.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';

class UtilityComponents {
  static void showSnackBarWithString(event, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        event,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black87,
    ));
  }

  static Future<dynamic> onBackPressed(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Leave Room?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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
              child: Text('Yes', style: TextStyle(fontSize: 24))),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: 24),
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
      UtilityComponents.showSnackBarWithString(
          "Role Change to " + event.suggestedRole.name, context);
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
            content: Text(message),
            actions: [
              ElevatedButton(
                child: Text('OK'),
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
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context, '');
                  },
                ),
                ElevatedButton(
                  child: Text('OK'),
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

  static showRoleList(BuildContext context, List<HMSRole> roles,
      MeetingStore _meetingStore) async {
    List<HMSRole> _selectedRoles = [];
    bool muteAll = false;
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: Text("Select Role for Mute"),
                content: Container(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: ListView.builder(
                              itemCount: roles.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(roles[index].name),
                                    Checkbox(
                                        value: _selectedRoles
                                            .contains(roles[index]),
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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mute All"),
                            Checkbox(
                                value: muteAll,
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
                                child: Text("Cancel")),
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
                                child: Text("Mute Roles"))
                          ],
                        )
                      ],
                    )),
              );
            }));
  }

  static Future<Map<String, String>> showRTMPInputDialog(
      {context,
      String placeholder = "",
      String prefilledValue = "",
      bool isRecordingEnabled = false}) async {
    TextEditingController textController = TextEditingController();
    if (prefilledValue.isNotEmpty) {
      textController.text = prefilledValue;
    }
    Map<String, String> answer = await showDialog(
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
                          title: Text("Recording"),
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
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, {"url": "", "toRecord": "false"});
                    },
                  ),
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      if (textController.text == "" && !isRecordingEnabled) {
                      } else {
                        Navigator.pop(context, {
                          "url": textController.text,
                          "toRecord": isRecordingEnabled.toString()
                        });
                      }
                    },
                  ),
                ],
              );
            }));

    return answer;
  }

  static List<Widget> videoTileWidget(
      int itemCount, List<PeerTrackNode> peerTracks, Size size) {
    return List.generate(itemCount, (index) {
      if (peerTracks[index].track?.source != "REGULAR") {
        return ChangeNotifierProvider.value(
          key: ValueKey(peerTracks[index].uid),
          value: peerTracks[index],
          child: peerTracks[index].peer.isLocal
              ? Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.screen_share),
                      Text("You are sharing your screen"),
                    ],
                  ),
                )
              : VideoTile(
                  key: Key(peerTracks[index].uid),
                  scaleType: ScaleType.SCALE_ASPECT_FIT,
                  itemHeight: size.height,
                  itemWidth: size.width,
                ),
        );
      }
      return ChangeNotifierProvider.value(
          key: ValueKey(peerTracks[index].uid),
          value: peerTracks[index],
          child: VideoTile(
            key: ValueKey(peerTracks[index].uid),
            itemHeight: size.height,
            itemWidth: size.width,
          ));
    });
  }

  static List<Widget> audioTileWidget(
      int itemCount, List<PeerTrackNode> peerTracks, Size size) {
    return List.generate(itemCount, (index) {
      return ChangeNotifierProvider.value(
          key: ValueKey(peerTracks[index].uid),
          value: peerTracks[index],
          child: AudioTile(
            key: ValueKey(peerTracks[index].uid),
            itemHeight: size.height,
            itemWidth: size.width,
          ));
    });
  }
}
