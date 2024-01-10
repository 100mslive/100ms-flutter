//Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_error_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

//Project imports
import 'package:hms_room_kit/src/widgets/chat_widgets/hms_empty_chat_widget.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/message_container.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/chat_text_field.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/pin_chat_widget.dart';

///[ChatBottomSheet] is a bottom sheet that is used to render the bottom sheet for chat
class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  late double widthOfScreen;
  String valueChoose = "Everyone";
  final ScrollController _scrollController = ScrollController();
  final DateFormat formatter = DateFormat('hh:mm a');
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.positions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }
  }

  void sendMessage(TextEditingController messageTextController) async {
    MeetingStore meetingStore = context.read<MeetingStore>();
    List<HMSRole> hmsRoles = meetingStore.roles;
    String message = messageTextController.text.trim();
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
        child: Stack(
          children: [
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Selector<MeetingStore,
                      Tuple4<List<HMSMessage>, int, List<dynamic>, int>>(
                    selector: (_, meetingStore) => Tuple4(
                        meetingStore.messages,
                        meetingStore.messages.length,
                        meetingStore.pinnedMessages,
                        meetingStore.pinnedMessages.length),
                    builder: (context, data, _) {
                      _scrollToEnd();
                      return

                          ///If there are no chats and no pinned messages
                          (data.item2 == 0 && data.item3.isEmpty)
                              ? const Expanded(
                                  child: Center(child: HMSEmptyChatWidget()))
                              : Expanded(
                                  child: Column(children: [
                                    PinChatWidget(
                                        pinnedMessage:
                                            data.item3.reversed.toList()),

                                    /// List containing chats
                                    Expanded(
                                      child: SingleChildScrollView(
                                        reverse: true,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ListView.builder(
                                                controller: _scrollController,
                                                shrinkWrap: true,
                                                itemCount: data.item1.length,
                                                itemBuilder: (_, index) {
                                                  return MessageContainer(
                                                    message: data.item1[index],
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                );
                    },
                  ),

                  /// This draws the chip to select the roles or peers to send message to
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: HMSTitleText(
                  //           text: "TO",
                  //           textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w400,
                  //           lineHeight: 16,
                  //           letterSpacing: 0.4,
                  //         ),
                  //       ),
                  //       Container(
                  //           height: 24,
                  //           decoration: BoxDecoration(
                  //               borderRadius:
                  //                   const BorderRadius.all(Radius.circular(4)),
                  //               color: HMSThemeColors.primaryDefault),
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(right: 4.0),
                  //                   child: SvgPicture.asset(
                  //                     "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                  //                     height: 16,
                  //                     width: 16,
                  //                     colorFilter: ColorFilter.mode(
                  //                         HMSThemeColors.onSurfaceMediumEmphasis,
                  //                         BlendMode.srcIn),
                  //                   ),
                  //                 ),
                  //                 HMSTitleText(
                  //                     text: valueChoose,
                  //                     fontSize: 12,
                  //                     lineHeight: 16,
                  //                     letterSpacing: 0.4,
                  //                     fontWeight: FontWeight.w400,
                  //                     textColor:
                  //                         HMSThemeColors.onPrimaryHighEmphasis),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 4.0),
                  //                   child: Icon(
                  //                     Icons.keyboard_arrow_down,
                  //                     color: HMSThemeColors.onPrimaryHighEmphasis,
                  //                     size: 12,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ))
                  //     ],
                  //   ),
                  // ),

                  ///Text Field
                  ChatTextField(sendMessage: sendMessage)
                ],
              ),
            ),
            Selector<MeetingStore, Tuple2<List<HMSToastModel>, int>>(
                selector: (_, meetingStore) =>
                    Tuple2(meetingStore.toasts, meetingStore.toasts.length),
                builder: (_, data, __) {
                  int errorToastIndex = data.item1.indexWhere((element) =>
                      element.hmsToastType == HMSToastsType.errorToast);

                  return (errorToastIndex != -1)
                      ? HMSErrorToast(
                          error: data.item1[errorToastIndex].toastData,
                          meetingStore: context.read<MeetingStore>(),
                          toastColor: HMSThemeColors.surfaceDefault,
                        )
                      : const SizedBox();
                })
          ],
        ),
      ),
    );
  }
}
