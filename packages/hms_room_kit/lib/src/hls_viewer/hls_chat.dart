//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//Project imports
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/message_container.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';

///[HLSChat] is a widget that is used to display the chat screen
///It is used to send messages to everyone, to a specific role or to a specific peer
class HLSChat extends StatefulWidget {
  const HLSChat({super.key});

  @override
  State<HLSChat> createState() => _HLSChatState();
}

class _HLSChatState extends State<HLSChat> {
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

  void updateDropDownValue(dynamic newValue) {
    valueChoose = newValue;
  }

  ///This function is used to scroll to the end of the chat
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut));
  }

  ///This function is used to get the sender of the message
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

  ///This function is used to send the message
  void sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text;
    if (message.isEmpty) return;

    List<String> rolesName = <String>[];
    for (int i = 0; i < hmsRoles.length; i++) {
      rolesName.add(hmsRoles[i].name);
    }

    if (valueChoose == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(valueChoose)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles
          .add(hmsRoles.firstWhere((role) => role.name == valueChoose));
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (meetingStore.localPeer!.peerId != valueChoose) {
      var peer = await meetingStore.getPeer(peerId: valueChoose);
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
          child: Container(
            color: HMSThemeColors.surfaceDefault,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Chat",
                                  style: HMSTextStyle.setTextStyle(
                                      color: themeDefaultColor,
                                      fontSize: 20,
                                      letterSpacing: 0.15,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Divider(
                      height: 5,
                      color: dividerColor,
                    ),
                  ),
                  Selector<MeetingStore, Tuple2<bool, String?>>(
                      selector: (_, meetingStore) => Tuple2(
                          meetingStore.isMessageInfoShown,
                          meetingStore.sessionMetadata),
                      builder: (context, displayFlags, _) {
                        if (displayFlags.item1 &&
                            (displayFlags.item2 == null)) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: themeSurfaceColor),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "packages/hms_room_kit/lib/src/assets/icons/info.svg"),
                                        const SizedBox(width: 18.5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.66,
                                          child: Text(
                                            "Messages can only be seen by people in the call and are deleted when the call ends.",
                                            style: HMSTextStyle.setTextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: themeSubHeadingColor,
                                                letterSpacing: 0.4,
                                                height: 16 / 12,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          context
                                              .read<MeetingStore>()
                                              .setMessageInfoFalse();
                                        },
                                        child: SvgPicture.asset(
                                            "packages/hms_room_kit/lib/src/assets/icons/close.svg"))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  Selector<MeetingStore, String?>(
                      selector: (_, meetingStore) =>
                          meetingStore.sessionMetadata,
                      builder: (context, sessionMetadata, _) {
                        if (sessionMetadata != null && sessionMetadata != "") {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: themeSurfaceColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/pin.svg"),
                                    const SizedBox(width: 18.5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.66,
                                      child: SelectableLinkify(
                                        text: sessionMetadata,
                                        onOpen: (link) async {
                                          Uri url = Uri.parse(link.url);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url,
                                                mode: LaunchMode
                                                    .externalApplication);
                                          }
                                        },
                                        options: const LinkifyOptions(
                                            humanize: false),
                                        style: HMSTextStyle.setTextStyle(
                                            fontSize: 12.0,
                                            color: themeSubHeadingColor,
                                            letterSpacing: 0.4,
                                            height: 16 / 12,
                                            fontWeight: FontWeight.w400),
                                        linkStyle: HMSTextStyle.setTextStyle(
                                            fontSize: 12.0,
                                            color: hmsdefaultColor,
                                            letterSpacing: 0.4,
                                            height: 16 / 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<MeetingStore>()
                                          .setSessionMetadataForKey(
                                              key: SessionStoreKeyValues
                                                  .getNameFromMethod(SessionStoreKey
                                                      .pinnedMessageSessionKey),
                                              metadata: null);
                                    },
                                    child: SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/close.svg"))
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child:
                        Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                      selector: (_, meetingStore) => Tuple2(
                          meetingStore.messages, meetingStore.messages.length),
                      builder: (context, data, _) {
                        if (data.item2 == 0) {
                          return Center(
                              child: Text(
                            'No messages',
                            style: HMSTextStyle.setTextStyle(color: iconColor),
                          ));
                        }
                        _scrollToEnd();
                        return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: data.item1.length,
                            itemBuilder: (_, index) {
                              return Container(
                                  padding: EdgeInsets.fromLTRB(
                                    (data.item1[index].sender?.isLocal ?? false)
                                        ? 50.0
                                        : 8.0,
                                    10,
                                    (data.item1[index].sender?.isLocal ?? false)
                                        ? 8.0
                                        : 20.0,
                                    10,
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: MessageContainer(
                                    message: data.item1[index].message
                                        .trim()
                                        .toString(),
                                    senderName:
                                        data.item1[index].sender?.name ??
                                            "Anonymous",
                                    date: formatter
                                        .format(data.item1[index].time),
                                    role:
                                        data.item1[index].hmsMessageRecipient ==
                                                null
                                            ? ""
                                            : sender(data.item1[index]
                                                .hmsMessageRecipient!),
                                  ));
                            });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: themeSurfaceColor),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5.0, left: 5.0),
                          width: widthOfScreen - 70,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              sendMessage();
                            },
                            style: HMSTextStyle.setTextStyle(color: iconColor),
                            controller: messageTextController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: HMSTextStyle.setTextStyle(
                                    color: themeHintColor,
                                    fontSize: 14,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400),
                                contentPadding: const EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Send a message to everyone"),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (messageTextController.text.isEmpty) {
                                Utilities.showToast("Message can't be empty");
                              }
                              sendMessage();
                            },
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                                colorFilter: ColorFilter.mode(
                                    themeDefaultColor, BlendMode.srcIn),
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
