library;

///Dart imports
import 'dart:math' as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';

///[ChatTextField] is a component that is used to render the chat text field
///It renders the text field or relevant UI based on chat State
class ChatTextField extends StatefulWidget {
  final Function sendMessage;
  final Color? toastBackgroundColor;
  final bool isHLSChat;
  const ChatTextField(
      {Key? key,
      required this.sendMessage,
      this.isHLSChat = false,
      this.toastBackgroundColor})
      : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  TextEditingController messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageTextController = TextEditingController();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Selector<MeetingStore, Tuple3<bool, int, List<String>>>(

          ///item1: whether chat is resumed or not
          ///item2: number of blacklisted users
          ///item3: list of blacklisted user ids
          selector: (_, meetingStore) => Tuple3(
              meetingStore.chatControls["enabled"],
              meetingStore.blackListedUserIds.length,
              meetingStore.blackListedUserIds),
          builder: (_, chatControls, __) {
            return chatControls.item1

                ///If chat is not paused we render the text field
                ///else we render the paused chat toast
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: chatControls.item3.contains(context
                            .read<MeetingStore>()
                            .localPeer
                            ?.customerUserId)

                        ///If the user is blocked from sending messages
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: widget.toastBackgroundColor ??
                                      HMSThemeColors.surfaceDefault,
                                  height: 36,
                                  child: Center(
                                    child: HMSSubheadingText(
                                        text:
                                            "You’ve been blocked from sending messages",
                                        textColor: HMSThemeColors
                                            .onSurfaceMediumEmphasis),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: HMSThemeColors.surfaceDefault,
                                  child: Selector<MeetingStore, dynamic>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.recipientSelectorValue,
                                      builder: (_, selectedValue, __) {
                                        return TextField(
                                          ///Here if the selected value is empty or equal to "Choose a Recipient" we disable the text field
                                          enabled: selectedValue !=
                                              "Choose a Recipient",
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          textInputAction: TextInputAction.send,
                                          onTapOutside: (event) => FocusManager
                                              .instance.primaryFocus
                                              ?.unfocus(),
                                          onSubmitted: (value) {
                                            widget.sendMessage(
                                                messageTextController);
                                            messageTextController.clear();
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          style: HMSTextStyle.setTextStyle(
                                              color: HMSThemeColors
                                                  .onSurfaceHighEmphasis,
                                              fontWeight: FontWeight.w400,
                                              height: 20 / 14,
                                              fontSize: 14,
                                              letterSpacing: 0.25),
                                          controller: messageTextController,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    if (messageTextController
                                                        .text
                                                        .trim()
                                                        .isEmpty) {
                                                      Utilities.showToast(
                                                          "Message can't be empty");
                                                    }
                                                    widget.sendMessage(
                                                        messageTextController);
                                                    messageTextController
                                                        .clear();
                                                  },
                                                  child: SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/src/assets/icons/send_message.svg",
                                                    fit: BoxFit.scaleDown,
                                                    colorFilter: ColorFilter.mode(
                                                        messageTextController
                                                                .text
                                                                .trim()
                                                                .isEmpty
                                                            ? HMSThemeColors
                                                                .onSurfaceLowEmphasis
                                                            : HMSThemeColors
                                                                .onSurfaceHighEmphasis,
                                                        BlendMode.srcIn),
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: HMSThemeColors
                                                          .primaryDefault),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8))),
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              hintStyle: HMSTextStyle
                                                  .setTextStyle(
                                                      color: HMSThemeColors
                                                          .onSurfaceLowEmphasis,
                                                      fontSize: 14,
                                                      height: 20 / 14,
                                                      letterSpacing: 0.25,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 12),
                                              hintText: HMSRoomLayout.chatData
                                                      ?.messagePlaceholder ??
                                                  "Send a message..."),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ))
                : HMSToast(
                    toastColor: widget.toastBackgroundColor ??
                        HMSThemeColors.surfaceDefault,
                    toastPosition: 0,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HMSSubheadingText(
                          text: "Chat paused",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          lineHeight: 20,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w400,
                        ),
                        HMSSubtitleText(
                          text:
                              "Chat has been paused by ${context.read<MeetingStore>().chatControls["updatedBy"].toString().substring(0, math.min(10, context.read<MeetingStore>().chatControls["updatedBy"].toString().length))}",
                          textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                        )
                      ],
                    ),
                    action: (HMSRoomLayout
                                .chatData?.realTimeControls?.canDisableChat ??
                            false)
                        ? HMSToastButton(
                            buttonTitle: "Resume",
                            action: () {
                              context
                                  .read<MeetingStore>()
                                  .setSessionMetadataForKey(
                                      key: SessionStoreKeyValues
                                          .getNameFromMethod(
                                              SessionStoreKey.chatState),
                                      metadata: {
                                    "enabled": true,
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
                            },
                            height: 36,
                            width: 88,
                            buttonColor: HMSThemeColors.primaryDefault,
                            textColor: HMSThemeColors.onPrimaryHighEmphasis,
                          )
                        : null,
                  );
          }),
    );
  }
}
