//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/receive_message.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/send_message.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
  late double widthOfScreen;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void _scrollDown() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 20,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String sender(HMSMessageRecipient hmsMessageRecipient) {
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      return hmsMessageRecipient.recipientPeer?.name ?? "";
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return hmsMessageRecipient.recipientRoles![0].name;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    final DateFormat formatter = DateFormat('hh:mm a');
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_alt_outlined),
                        SizedBox(
                          width: 5,
                        ),
                        Selector<MeetingStore,
                                Tuple2<List<HMSRole>, List<HMSPeer>>>(
                            selector: (_, meetingStore) =>
                                Tuple2(meetingStore.roles, meetingStore.peers),
                            builder: (context, data, _) {
                              List<HMSRole> roles = data.item1;
                              if (roles.length > 0) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    selectedItemHighlightColor: hmsdefaultColor,
                                    isExpanded: true,
                                    dropdownWidth:
                                        MediaQuery.of(context).size.width * 0.6,
                                    buttonWidth: 120,
                                    value: valueChoose,
                                    offset: Offset(
                                        -1 *
                                            (MediaQuery.of(context).size.width *
                                                0.2),
                                        0),
                                    iconEnabledColor: iconColor,
                                    onChanged: (newvalue) {
                                      setState(() {
                                        this.valueChoose = newvalue as String;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem<String>(
                                        child: Text(
                                          "Everyone",
                                          style: GoogleFonts.inter(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        value: "Everyone",
                                      ),
                                      ...roles
                                          .sortedBy((element) =>
                                              element.priority.toString())
                                          .map((role) =>
                                              DropdownMenuItem<String>(
                                                child: Text(
                                                  "${role.name}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: GoogleFonts.inter(
                                                      color: iconColor),
                                                ),
                                                value: role.name,
                                              ))
                                          .toList(),
                                      ...data.item2
                                          .sortedBy((element) => element.name)
                                          .map((peer) {
                                            return !peer.isLocal
                                                ? DropdownMenuItem<String>(
                                                    child: Text(
                                                      "${peer.name} ${peer.isLocal ? "(You)" : ""}",
                                                      style: GoogleFonts.inter(
                                                          color: iconColor),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    value: peer.peerId,
                                                  )
                                                : null;
                                          })
                                          .whereNotNull()
                                          .toList(),
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
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child:
                        Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                      selector: (_, meetingStore) => Tuple2(
                          meetingStore.messages, meetingStore.messages.length),
                      builder: (context, data, _) {
                        if (data.item2 == 0)
                          return Center(
                              child: Text(
                            'No messages',
                            style: GoogleFonts.inter(color: iconColor),
                          ));

                        return ListView(
                          controller: _scrollController,
                          children: List.generate(
                            data.item2,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(vertical: 2),
                              child: data.item1[index].sender?.isLocal ?? false
                                  ? SendMessageScreen(
                                      senderName:
                                          data.item1[index].sender?.name ?? "",
                                      date: formatter
                                          .format(data.item1[index].time),
                                      message:
                                          data.item1[index].message.toString(),
                                      role: data.item1[index].hmsMessageRecipient ==
                                              null
                                          ? ""
                                          : sender(data.item1[index]
                                              .hmsMessageRecipient!))
                                  : ReceiveMessageScreen(
                                      message:
                                          data.item1[index].message.toString(),
                                      senderName:
                                          data.item1[index].sender?.name ?? "",
                                      date: formatter
                                          .format(data.item1[index].time),
                                      role: data.item1[index]
                                                  .hmsMessageRecipient ==
                                              null
                                          ? ""
                                          : sender(data.item1[index].hmsMessageRecipient!)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.grey,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                          child: TextField(
                            style: GoogleFonts.inter(color: iconColor),
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
                          width: widthOfScreen - 60,
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
                              widget.meetingStore
                                  .sendGroupMessage(message, selectedRoles);
                            } else if (widget.meetingStore.localPeer!.peerId !=
                                this.valueChoose) {
                              var peer = await widget.meetingStore
                                  .getPeer(peerId: this.valueChoose);
                              widget.meetingStore
                                  .sendDirectMessage(message, peer!);
                            }
                            messageTextController.clear();
                            _scrollDown();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (ctx) => ChangeNotifierProvider.value(
          value: meetingStore, child: ChatWidget(meetingStore)),
      isScrollControlled: true);
}
