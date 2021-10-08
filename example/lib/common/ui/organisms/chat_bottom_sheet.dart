import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:intl/intl.dart';

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
    return Container(
        child: Center(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.blue,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Chat",
                      style: TextStyle(color: Colors.black, fontSize: 30.0),
                    ),
                  ),
                  FutureBuilder(
                      future: _meetingStore.getRoles(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return DropdownButton<String>(
                            value: valueChoose,
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
                              ..._meetingStore.peers.map((e) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                      "${e.name} ${e.isLocal ? "(You)" : ""}"),
                                  value: e.peerId,
                                );
                              }).toList(),
                              ...this
                                  .hmsRoles
                                  .map((e) => DropdownMenuItem<String>(
                                        child: Text("${e.name}"),
                                        value: e.name,
                                      ))
                                  .toList()
                            ],
                          );
                        } else
                          return CircularProgressIndicator(
                            color: Colors.black,
                          );
                      }),
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
                    return Text('No messages');
                  return ListView(
                    children: List.generate(
                      _meetingStore.messages.length,
                      (index) => Container(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _meetingStore.messages[index].sender
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    HMSMessageRecipientValues
                                        .getValueFromHMSMessageRecipientType(
                                            _meetingStore
                                                .messages[index]
                                                .hmsMessageRecipient!
                                                .hmsMessageRecipientType),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                Text(
                                  _meetingStore.messages[index].time.toString(),
                                  style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              _meetingStore.messages[index].message.toString(),
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
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
              color: Colors.grey,
              margin: EdgeInsets.only(top: 10.0),
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
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Type a Message"),
                    ),
                    width: widthOfScreen - 45.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      String message = messageTextController.text;
                      if (message.isEmpty) return;

                      DateTime currentTime = DateTime.now();
                      final DateFormat formatter =
                          DateFormat('yyyy-MM-dd hh:mm a');

                      List<String> rolesName = <String>[];
                      for (int i = 0; i < hmsRoles.length; i++)
                        rolesName.add(hmsRoles[i].name);
                      print("${this.hmsRoles.toString()} dekte hai");
                      if (this.valueChoose == "Everyone") {
                        _meetingStore.sendMessage(message);
                        _meetingStore.addMessage(HMSMessage(
                          sender: _meetingStore.localPeer!,
                          message: message,
                          type: "chat",
                          time: formatter.format(currentTime),
                          hmsMessageRecipient: HMSMessageRecipient(
                              recipientPeer: null,
                              recipientRoles: null,
                              hmsMessageRecipientType:
                                  HMSMessageRecipientType.BROADCAST),
                        ));
                      } else if (rolesName.contains(this.valueChoose)) {
                        _meetingStore.sendGroupMessage(
                            message, this.valueChoose);
                        _meetingStore.addMessage(HMSMessage(
                          sender: _meetingStore.localPeer!,
                          message: message,
                          type: "chat",
                          time: formatter.format(currentTime),
                          hmsMessageRecipient: HMSMessageRecipient(
                              recipientPeer: null,
                              recipientRoles: null,
                              hmsMessageRecipientType:
                                  HMSMessageRecipientType.ROLES),
                        ));
                      } else if (_meetingStore.localPeer!.peerId !=
                          this.valueChoose) {
                        _meetingStore.sendDirectMessage(
                            message, this.valueChoose);
                        _meetingStore.addMessage(HMSMessage(
                          sender: _meetingStore.localPeer!,
                          message: message,
                          type: "chat",
                          time: formatter.format(currentTime),
                          hmsMessageRecipient: HMSMessageRecipient(
                              recipientPeer: null,
                              recipientRoles: null,
                              hmsMessageRecipientType:
                                  HMSMessageRecipientType.PEER),
                        ));
                      }

                      messageTextController.clear();
                    },
                    child: Icon(
                      Icons.double_arrow,
                      size: 40.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

void chatMessages(BuildContext context, MeetingStore meetingStore) {
  showModalBottomSheet(
      context: context, builder: (ctx) => ChatWidget(meetingStore));
}
