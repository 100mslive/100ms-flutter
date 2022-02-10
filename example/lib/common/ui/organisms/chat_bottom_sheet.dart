//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:collection/collection.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class ChatWidget extends StatefulWidget {
  final MeetingStore meetingStore;

  ChatWidget(this.meetingStore);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late MeetingStore _meetingStore;
  late double widthOfScreen;
  late List<HMSRole> hmsRoles;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";

  @override
  void initState() {
    super.initState();
    _meetingStore = widget.meetingStore;
    getRoles();
  }

  void getRoles() async {
    hmsRoles = await _meetingStore.getRoles();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people_alt_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Observer(builder: (ctx) {
                              List<HMSRole> roles = _meetingStore.roles;
                              if (roles.length > 0) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    buttonWidth: 150,
                                    value: valueChoose,
                                    iconEnabledColor: Colors.black,
                                    onChanged: (newvalue) {
                                      setState(() {
                                        this.valueChoose = newvalue as String;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text("Everyone"),
                                        value: "Everyone",
                                      ),
                                      ..._meetingStore.peers
                                          .map((peer) {
                                            return !peer.isLocal
                                                ? DropdownMenuItem<String>(
                                                    child: Text(
                                                        "${peer.name} ${peer.isLocal ? "(You)" : ""}"),
                                                    value: peer.peerId,
                                                  )
                                                : null;
                                          })
                                          .whereNotNull()
                                          .toList(),
                                      ...roles
                                          .map((role) =>
                                              DropdownMenuItem<String>(
                                                child: Text("${role.name}"),
                                                value: role.name,
                                              ))
                                          .toList()
                                    ],
                                  ),
                                );
                              } else
                                return CircularProgressIndicator(
                                  color: Colors.black,
                                );
                            }),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.clear,
                            size: 25.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Observer(
                      builder: (_) {
                        if (!_meetingStore.isMeetingStarted) return SizedBox();
                        if (_meetingStore.messages.isEmpty)
                          return Center(child: Text('No messages'));

                        return ListView(
                          children: List.generate(
                            _meetingStore.messages.length,
                            (index) => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _meetingStore.messages[index].sender
                                                  ?.name ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        _meetingStore.messages[index].time
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _meetingStore.messages[index].message
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(
                                        HMSMessageRecipientValues
                                                .getValueFromHMSMessageRecipientType(
                                                    _meetingStore
                                                        .messages[index]
                                                        .hmsMessageRecipient!
                                                        .hmsMessageRecipientType)
                                            .toLowerCase(),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                left: BorderSide(
                                  color: Colors.blue,
                                  width: 5,
                                ),
                              )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.grey[700],
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                          child: TextField(
                            autofocus: true,
                            controller: messageTextController,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Type a Message"),
                          ),
                          width: widthOfScreen - 45.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            String message = messageTextController.text;
                            if (message.isEmpty) return;

                            List<String> rolesName = <String>[];
                            for (int i = 0; i < hmsRoles.length; i++)
                              rolesName.add(hmsRoles[i].name);

                            if (this.valueChoose == "Everyone") {
                              _meetingStore.sendBroadcastMessage(message);
                            } else if (rolesName.contains(this.valueChoose)) {
                              List<HMSRole> selectedRoles = [];
                              selectedRoles.add(hmsRoles.firstWhere(
                                  (role) => role.name == this.valueChoose));
                              _meetingStore.sendGroupMessage(
                                  message, selectedRoles);
                            } else if (_meetingStore.localPeer!.peerId !=
                                this.valueChoose) {
                              var peer = await _meetingStore.getPeer(
                                  peerId: this.valueChoose);
                              _meetingStore.sendDirectMessage(message, peer!);
                            }

                            messageTextController.clear();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

void chatMessages(BuildContext context, MeetingStore meetingStore) {
  showModalBottomSheet(
      context: context,
      builder: (ctx) => ChatWidget(meetingStore),
      isScrollControlled: true);
}
