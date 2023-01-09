import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  final HMSSDK hmssdk;
  final List<HMSMessage> oldMessage;
  const MessagePage(
      {super.key, required this.hmssdk, required this.oldMessage});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    implements HMSUpdateListener, HMSActionResultListener {
  List<HMSMessage> messages = [];
  //Local Peer
  HMSLocalPeer? localPeer;
  //Store value of session Metadata (Pin Message)
  String? sessionMetadata;
  @override
  void initState() {
    messages.addAll(widget.oldMessage);
    widget.hmssdk.addUpdateListener(listener: this);
    //fetching localpeer
    getLocalpeer();

    //fetching sessionMetadata(current pin message)
    getSessionMetadata();
    super.initState();
  }

  getLocalpeer() async {
    //fetching localpeer
    localPeer = await widget.hmssdk.getLocalPeer();
    setState(() {});
  }

  getSessionMetadata() async {
    //fetching sessionMetadata(current pin message)
    sessionMetadata = await widget.hmssdk.getSessionMetadata();
    setState(() {});
  }

  @override
  void dispose() {
    widget.hmssdk.removeUpdateListener(listener: this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    TextEditingController messageTextController = TextEditingController();
    final DateFormat formatter = DateFormat('hh:mm');
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: Colors.white,
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
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
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
                // Checking if sessionMetdata (Pin message) exist or not if yes then show UI otherwise skip
                if (sessionMetadata != null && sessionMetadata != "")
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.push_pin_rounded),
                            const SizedBox(width: 18.5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.66,
                              child: Text(
                                sessionMetadata!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                    height: 16 / 12,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              // Removing session metadata by setting it value to null.
                              widget.hmssdk.setSessionMetadata(
                                  metadata: null,
                                  hmsActionResultListener: this);
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                  ),
                Expanded(
                    child: messages.isEmpty
                        ? const Text('No messages')
                        : ListView.separated(
                            itemCount: messages.length,
                            itemBuilder: (itemBuilder, index) {
                              return GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              messages[index].sender?.name ??
                                                  "",
                                              style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            formatter
                                                .format(messages[index].time),
                                            style: const TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          PopupMenuButton(
                                            color: Colors.black,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  child:
                                                      const Text('Pin Message'),
                                                  onTap: () {
                                                    // Setting session metadata to senderName: Message by calling "setSessionMetadata" method of HMSSDK
                                                    widget.hmssdk.setSessionMetadata(
                                                        metadata:
                                                            "${messages[index].sender!.name}: ${messages[index].message}",
                                                        hmsActionResultListener:
                                                            this);
                                                  },
                                                )
                                              ];
                                            },
                                            child: const Icon(
                                              Icons.more_vert_outlined,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        messages[index].message.toString(),
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
                            },
                          )),
                Container(
                  color: Colors.grey,
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                        width: widthOfScreen - 45.0,
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
                      ),
                      GestureDetector(
                        onTap: () {
                          String message = messageTextController.text;
                          if (message.isEmpty) return;
                          widget.hmssdk.sendBroadcastMessage(
                              message: message, hmsActionResultListener: this);
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

  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onJoin({required HMSRoom room}) {}

  @override
  void onMessage({required HMSMessage message}) {
    if (message.type == "metadata") {
      // If message type is metadata then fetch session metadata.
      getSessionMetadata();
      return;
    }
    // Adding message to list
    messages.add(message);
    setState(() {});
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  Future<void> onSuccess(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments}) async {
    switch (methodType) {
      case HMSActionResultListenerMethod.sendBroadcastMessage:
        log("message send successfully");
        if (arguments!['type'] != null && arguments['type'] == "metadata") {
          // if message type is metadata then call method getSessionMetadata of HMSSDK.
          getSessionMetadata();
          break;
        }
        // creating message if sendBroadcastMessage is success and adding it to messages list.
        HMSMessage message = HMSMessage(
            sender: localPeer,
            message: arguments['message'],
            type: arguments['type'] ?? "chat",
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: null,
                recipientRoles: null,
                hmsMessageRecipientType: HMSMessageRecipientType.BROADCAST));
        messages.add(message);
        setState(() {});
        break;
      case HMSActionResultListenerMethod.setSessionMetadata:
        log("session metadata send successfully");
        // sendBroadcastMessage if setSessionMetadata is successful with type: "metadata" and message: "refresh".
        widget.hmssdk.sendBroadcastMessage(
            message: "refresh",
            type: "metadata",
            hmsActionResultListener: this);
        break;
      default:
        log("Success: type: ${methodType.name} arguments:$arguments");
        break;
    }
  }

  @override
  void onException(
      {HMSActionResultListenerMethod methodType =
          HMSActionResultListenerMethod.unknown,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    log("Error: type: ${methodType.name} hmsException: ${hmsException.message} arguments:$arguments");
  }
}
