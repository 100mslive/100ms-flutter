//Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_message_organism.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class HLSMessage extends StatefulWidget {
  @override
  State<HLSMessage> createState() => _HLSMessageState();
}

class _HLSMessageState extends State<HLSMessage> {
  late double widthOfScreen;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";
  final ScrollController _scrollController = ScrollController();
  final DateFormat formatter = DateFormat('hh:mm a');
  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance?.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInOut));
  }

  String sender(HMSMessageRecipient hmsMessageRecipient) {
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      return "PRIVATE";
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return hmsMessageRecipient.recipientRoles![0].name;
    }
    return "";
  }

  void sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text;
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) rolesName.add(hmsRoles[i].name);

    if (this.valueChoose == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(this.valueChoose)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles
          .add(hmsRoles.firstWhere((role) => role.name == this.valueChoose));
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (meetingStore.localPeer!.peerId != this.valueChoose) {
      var peer = await meetingStore.getPeer(peerId: this.valueChoose);
      meetingStore.sendDirectMessage(message, peer!);
    }
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.read<MeetingStore>().setNewMessageFalse();
        return true;
      },
      child: SafeArea(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: FractionallySizedBox(
            heightFactor: 0.8,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10, right: 10, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Row(
                              children: [
                                Text(
                                  "Chat",
                                  style: GoogleFonts.inter(
                                      color: defaultColor,
                                      fontSize: 20,
                                      letterSpacing: 0.15,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: borderColor,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Selector<
                                            MeetingStore,
                                            Tuple2<List<HMSRole>,
                                                List<HMSPeer>>>(
                                        selector: (_, meetingStore) => Tuple2(
                                            meetingStore.roles,
                                            meetingStore.peers),
                                        builder: (context, data, _) {
                                          List<HMSRole> roles = data.item1;
                                          return DropdownButton2(
                                            selectedItemHighlightColor:
                                                hmsdefaultColor,
                                            isExpanded: true,
                                            dropdownWidth:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                            buttonWidth: 100,
                                            buttonHeight: 35,
                                            itemHeight: 45,
                                            value: valueChoose,
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: surfaceColor),
                                            offset: Offset(-10, -10),
                                            iconEnabledColor: iconColor,
                                            // selectedItemHighlightColor: Colors.blue,
                                            onChanged: (dynamic newvalue) {
                                              setState(() {
                                                this.valueChoose =
                                                    newvalue as String;
                                              });
                                            },
                                            items: <DropdownMenuItem>[
                                              DropdownMenuItem(
                                                child: Text(
                                                  "Everyone",
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    letterSpacing: 0.4,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                value: "Everyone",
                                              ),
                                              ...roles
                                                  .sortedBy((element) => element
                                                      .priority
                                                      .toString())
                                                  .map((role) =>
                                                      DropdownMenuItem(
                                                        child: Text(
                                                          "${role.name}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontSize: 12,
                                                                  color:
                                                                      iconColor),
                                                        ),
                                                        value: role.name,
                                                      ))
                                                  .toList(),
                                              ...data.item2
                                                  .sortedBy(
                                                      (element) => element.name)
                                                  .map((peer) {
                                                    return !peer.isLocal
                                                        ? DropdownMenuItem(
                                                            child: Text(
                                                              "${peer.name} ${peer.isLocal ? "(You)" : ""}",
                                                              style: GoogleFonts
                                                                  .inter(
                                                                      fontSize:
                                                                          12,
                                                                      color:
                                                                          iconColor),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                            value: peer.peerId,
                                                          )
                                                        : null;
                                                  })
                                                  .whereNotNull()
                                                  .toList(),
                                            ],
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/close_button.svg",
                          width: 40,
                        ),
                        onPressed: () {
                          context.read<MeetingStore>().setNewMessageFalse();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Divider(
                      height: 5,
                      color: dividerColor,
                    ),
                  ),
                  Selector<MeetingStore, bool>(
                      selector: (_, meetingStore) =>
                          meetingStore.isMessageInfoShown,
                      builder: (context, infoDialog, _) {
                        if (infoDialog)
                          return Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: surfaceColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset("assets/icons/info.svg"),
                                SizedBox(width: 5),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    "Messages can only be seen by people in the call and are deleted when the call ends.",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        color: subHeadingColor,
                                        letterSpacing: 0.4,
                                        height: 16 / 12,
                                        fontSize: 12),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MeetingStore>()
                                          .setMessageInfoFalse();
                                    },
                                    child: SvgPicture.asset(
                                        "assets/icons/close.svg"))
                              ],
                            ),
                          );
                        else
                          return SizedBox();
                      }),
                  SizedBox(
                    height: 15,
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
                        _scrollToEnd();
                        return ListView(
                          controller: _scrollController,
                          children: List.generate(
                              data.item2,
                              (index) => Container(
                                  padding: EdgeInsets.fromLTRB(
                                    (data.item1[index].sender?.isLocal ?? false)
                                        ? 24.0
                                        : 8.0,
                                    10,
                                    (data.item1[index].sender?.isLocal ?? false)
                                        ? 8.0
                                        : 20.0,
                                    10,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  child: HLSMessageOrganism(
                                    isLocalMessage:
                                        data.item1[index].sender?.isLocal ??
                                                false
                                            ? true
                                            : false,
                                    message:
                                        data.item1[index].message.toString(),
                                    senderName:
                                        data.item1[index].sender?.name ?? "",
                                    date: formatter
                                        .format(data.item1[index].time),
                                    role:
                                        data.item1[index].hmsMessageRecipient ==
                                                null
                                            ? ""
                                            : sender(data.item1[index]
                                                .hmsMessageRecipient!),
                                  ))),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: surfaceColor),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0, left: 5.0),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              sendMessage();
                            },
                            style: GoogleFonts.inter(color: iconColor),
                            controller: messageTextController,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: GoogleFonts.inter(
                                    color: hintColor,
                                    fontSize: 14,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400),
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Send a message to everyone"),
                          ),
                          width: widthOfScreen - 70,
                        ),
                        InkWell(
                            onTap: () {
                              if (messageTextController.text.isEmpty) {
                                Utilities.showToast("Message can't be empty");
                              }
                              sendMessage();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                "assets/icons/send_message.svg",
                                color: defaultColor,
                                fit: BoxFit.scaleDown,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
