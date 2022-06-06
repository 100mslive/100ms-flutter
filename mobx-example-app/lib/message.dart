import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobx_example/setup/meeting_store.dart';

class Message extends StatefulWidget {
  final MeetingStore meetingStore;
  const Message({Key? key, required this.meetingStore}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late MeetingStore _meetingStore;
  late double widthOfScreen;
  late List<HMSRole> hmsRoles;
  TextEditingController messageTextController = TextEditingController();
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
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Message",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
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
                      if (!_meetingStore.isMeetingStarted) {
                        return const SizedBox();
                      }
                      if (_meetingStore.messages.isEmpty) {
                        return const Text('No messages');
                      }
                      return ListView.separated(
                        itemCount: _meetingStore.messages.length,
                        itemBuilder: (itemBuilder, index) {
                          return Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _meetingStore
                                                .messages[index].sender?.name ??
                                            "",
                                        style: const TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      formatter.format(
                                          _meetingStore.messages[index].time),
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  _meetingStore.messages[index].message
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.grey,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                        child: TextField(
                          autofocus: true,
                          controller: messageTextController,
                          decoration: const InputDecoration(
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
                          _meetingStore.sendBroadcastMessage(message);
                          messageTextController.clear();
                        },
                        child: const Icon(
                          Icons.double_arrow,
                          size: 40.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

void chatMessages(BuildContext context, MeetingStore meetingStore) {
  showModalBottomSheet(
      context: context,
      builder: (ctx) => Message(meetingStore: meetingStore),
      isScrollControlled: true);
}
