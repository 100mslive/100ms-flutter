//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ChatWidget extends StatefulWidget {
  final MeetingStore meetingStore;

  ChatWidget(this.meetingStore);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late double widthOfScreen;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";

  @override
  void initState() {
    super.initState();
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
                            Selector<MeetingStore,
                                    Tuple2<List<HMSRole>, List<HMSPeer>>>(
                                selector: (_, meetingStore) => Tuple2(
                                    meetingStore.roles, meetingStore.peers),
                                builder: (context, data, _) {
                                  List<HMSRole> roles = data.item1;
                                  if (roles.length > 0) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        buttonWidth: 150,
                                        value: valueChoose,
                                        iconEnabledColor: Colors.white,
                                        onChanged: (newvalue) {
                                          setState(() {
                                            this.valueChoose =
                                                newvalue as String;
                                          });
                                        },
                                        items: [
                                          DropdownMenuItem<String>(
                                            child: Text("Everyone"),
                                            value: "Everyone",
                                          ),
                                          ...data.item2
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
                                      color: Colors.white,
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
                    child: Selector<MeetingStore, Tuple2<List<HMSMessage>,int>>(
                      selector: (_, meetingStore) => Tuple2(meetingStore.messages,meetingStore.messages.length),
                      builder: (context, data, _) {
                        // if (!_meetingStore.isMeetingStarted) return SizedBox();

                        if (data.item2== 0)
                          return Center(child: Text('No messages'));

                        return ListView(
                          children: List.generate(
                            data.item2,
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
                                          data.item1[index].sender?.name ?? "",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: MediaQuery.of(context).platformBrightness==Brightness.light?
                                          Colors.grey:Colors.white70,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(
                                        data.item1[index].time.toString(),
                                        style: TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.white,
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
                                          data.item1[index].message.toString(),
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(
                                        HMSMessageRecipientValues
                                                .getValueFromHMSMessageRecipientType(
                                                    data.item1[index]
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
                            List<HMSRole> hmsRoles = widget.meetingStore.roles;
                            String message = messageTextController.text;
                            if (message.isEmpty) return;

                            List<String> rolesName = <String>[];
                            for (int i = 0; i < hmsRoles.length; i++)
                              rolesName.add(hmsRoles[i].name);

                            if (this.valueChoose == "Everyone") {
                              widget.meetingStore.sendBroadcastMessage(message);
                            } else if (rolesName.contains(this.valueChoose)) {
                              List<HMSRole> selectedRoles = [];
                              selectedRoles.add(hmsRoles.firstWhere(
                                  (role) => role.name == this.valueChoose));
                              widget.meetingStore.sendGroupMessage(
                                  message, selectedRoles);
                            } else if (widget.meetingStore.localPeer!.peerId !=
                                this.valueChoose) {
                              var peer = await widget.meetingStore.getPeer(
                                  peerId: this.valueChoose);
                              widget.meetingStore.sendDirectMessage(message, peer!);
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

void chatMessages(BuildContext context) {
  MeetingStore meetingStore = context.read<MeetingStore>();
  showModalBottomSheet(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
          value: meetingStore, child: ChatWidget(meetingStore)),
      isScrollControlled: true);
}
