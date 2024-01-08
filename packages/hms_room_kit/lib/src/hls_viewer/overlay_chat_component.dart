//Dart imports

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/chat_text_field.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/pin_chat_widget.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

///[OverlayChatComponent] is a component that is used to show the chat
class OverlayChatComponent extends StatefulWidget {
  final double? height;
  const OverlayChatComponent({super.key, this.height});

  @override
  State<OverlayChatComponent> createState() => _OverlayChatComponentState();
}

class _OverlayChatComponentState extends State<OverlayChatComponent> {
  TextEditingController messageTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    messageTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ///This function scrolls to the end of the list
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut));
  }

  ///This function sends the message
  void _sendMessage() async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    String message = messageTextController.text.trim();
    if (message.isEmpty) return;
    meetingStore.sendBroadcastMessage(message);
    messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: widget.height ?? MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            ///Chat Header
            Expanded(
              child: Selector<MeetingStore, Tuple2<List<HMSMessage>, int>>(
                  selector: (_, meetingStore) => Tuple2(
                      meetingStore.messages, meetingStore.messages.length),
                  builder: (context, data, _) {
                    _scrollToEnd();
                    return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: data.item1.length,
                        itemBuilder: (_, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HMSTitleText(
                                text: data.item1[index].sender?.name ??
                                    "Anonymous",
                                textColor: Colors.white,
                                fontSize: 14,
                                lineHeight: 20,
                                letterSpacing: 0.1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SelectableLinkify(
                                text: data.item1[index].message,
                                onOpen: (link) async {
                                  Uri url = Uri.parse(link.url);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url,
                                        mode: LaunchMode.externalApplication);
                                  }
                                },
                                options: const LinkifyOptions(humanize: false),
                                style: HMSTextStyle.setTextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 20 / 14,
                                  letterSpacing: 0.25,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              )
                            ],
                          );
                        });
                  }),
            ),
            const SizedBox(
              height: 8,
            ),

            ///This renders the pinned message widget
            Selector<MeetingStore, Tuple2<List<dynamic>, int>>(
                selector: (_, meetingStore) => Tuple2(
                    meetingStore.pinnedMessages,
                    meetingStore.pinnedMessages.length),
                builder: (_, data, __) {
                  return PinChatWidget(
                    pinnedMessage: data.item1,
                    backgroundColor: HMSThemeColors.backgroundDim.withAlpha(64),
                  );
                }),

            Selector<MeetingStore, bool>(
                selector: (_, meetingStore) =>
                    meetingStore.chatControls["enabled"],
                builder: (_, isChatEnabled, __) {
                  return isChatEnabled
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///This will be added in future versions
                              ///
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: HMSTitleText(
                                      text: "TO",
                                      textColor: HMSThemeColors
                                          .onSurfaceMediumEmphasis,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      lineHeight: 16,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  Container(
                                      height: 24,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          color: HMSThemeColors.backgroundDim
                                              .withOpacity(0.64)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: SvgPicture.asset(
                                                "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                                                height: 16,
                                                width: 16,
                                                colorFilter: ColorFilter.mode(
                                                    HMSThemeColors
                                                        .onSurfaceMediumEmphasis,
                                                    BlendMode.srcIn),
                                              ),
                                            ),
                                            HMSTitleText(
                                                text: "Everyone",
                                                fontSize: 12,
                                                lineHeight: 16,
                                                letterSpacing: 0.4,
                                                fontWeight: FontWeight.w400,
                                                textColor: HMSThemeColors
                                                    .onPrimaryHighEmphasis),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: HMSThemeColors
                                                    .onPrimaryHighEmphasis,
                                                size: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(),
                              if (HMSRoomLayout.chatData?.realTimeControls
                                      ?.canDisableChat ??
                                  false)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    PopupMenuButton(
                                      padding: EdgeInsets.zero,
                                      position: PopupMenuPosition.over,
                                      color: HMSThemeColors.surfaceDefault,
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Row(children: [
                                                SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/src/assets/icons/${context.read<MeetingStore>().chatControls["enabled"] ? "recording_paused" : "resume"}.svg",
                                                    width: 20,
                                                    height: 20,
                                                    colorFilter: ColorFilter.mode(
                                                        HMSThemeColors
                                                            .onSurfaceHighEmphasis,
                                                        BlendMode.srcIn)),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                HMSTitleText(
                                                  text: context
                                                          .read<MeetingStore>()
                                                          .chatControls["enabled"]
                                                      ? "Pause Chat"
                                                      : "Resume Chat",
                                                  textColor: HMSThemeColors
                                                      .onSurfaceHighEmphasis,
                                                  fontSize: 14,
                                                  lineHeight: 20,
                                                  letterSpacing: 0.1,
                                                ),
                                              ]),
                                            ))
                                      ],
                                      onSelected: (value) {
                                        switch (value) {
                                          case 1:
                                            context
                                                .read<MeetingStore>()
                                                .setSessionMetadataForKey(
                                                    key: SessionStoreKeyValues
                                                        .getNameFromMethod(
                                                            SessionStoreKey
                                                                .chatState),
                                                    metadata: {
                                                  "enabled": context
                                                          .read<MeetingStore>()
                                                          .chatControls["enabled"]
                                                      ? false
                                                      : true,
                                                  "updatedBy": {
                                                    "peerID": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.peerId,
                                                    "userID": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.customerUserId,
                                                    "userName": context
                                                        .read<MeetingStore>()
                                                        .localPeer
                                                        ?.name
                                                  },
                                                  "updatedAt": DateTime.now()
                                                      .millisecondsSinceEpoch //unix timestamp in miliseconds
                                                });
                                            break;
                                        }
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            color: HMSThemeColors.backgroundDim
                                                .withOpacity(0.64)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SvgPicture.asset(
                                            "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                                            height: 16,
                                            width: 16,
                                            colorFilter: ColorFilter.mode(
                                                HMSThemeColors
                                                    .onSurfaceLowEmphasis,
                                                BlendMode.srcIn),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                        )
                      : const SizedBox();
                }),
            ChatTextField(
              sendMessage: _sendMessage,
              toastBackgroundColor: HMSThemeColors.backgroundDim.withAlpha(64),
            )
          ],
        ),
      ),
    );
  }
}
