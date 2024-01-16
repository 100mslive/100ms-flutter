//Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
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
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/recipient_selector_chip.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_error_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[ChatBottomSheet] is a bottom sheet that is used to render the bottom sheet for chat
class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  late double widthOfScreen;
  String currentlySelectedValue = "Choose a Recipient";
  String? currentlySelectedpeerId;

  final ScrollController _scrollController = ScrollController();
  final DateFormat formatter = DateFormat('hh:mm a');

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController
          .animateTo(_scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut));
    }
  }

  @override
  void initState() {
    super.initState();
    setRecipientChipValue();
  }

  ///This function sets the value of the recipient chip
  void setRecipientChipValue() {
    dynamic currentValue = context.read<MeetingStore>().recipientSelectorValue;
    if (currentValue is HMSPeer) {
      currentlySelectedValue = currentValue.name;
      currentlySelectedpeerId = currentValue.peerId;
    } else if (currentValue is HMSRole) {
      currentlySelectedValue = currentValue.name;
    } else if (currentValue is String) {
      currentlySelectedValue = currentValue;
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

    if (currentlySelectedValue == "Everyone") {
      meetingStore.sendBroadcastMessage(message);
    } else if (rolesName.contains(currentlySelectedValue)) {
      List<HMSRole> selectedRoles = [];
      selectedRoles.add(
          hmsRoles.firstWhere((role) => role.name == currentlySelectedValue));
      meetingStore.sendGroupMessage(message, selectedRoles);
    } else if (currentlySelectedpeerId != null &&
        meetingStore.localPeer!.peerId != currentlySelectedpeerId) {
      var peer = await meetingStore.getPeer(peerId: currentlySelectedpeerId!);
      if (peer != null) {
        meetingStore.sendDirectMessage(message, peer);
      }
    }
  }

  void _updateValueChoose(String newValue, String? peerId) {
    currentlySelectedValue = newValue;
    currentlySelectedpeerId = peerId;
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
                              ? Expanded(
                                  child: SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.6,
                                          ),
                                          child: const HMSEmptyChatWidget())))
                              : Expanded(
                                  child: Column(children: [
                                    const PinChatWidget(),

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
                  if ((HMSRoomLayout.chatData?.isPrivateChatEnabled ?? false) ||
                      (HMSRoomLayout.chatData?.isPublicChatEnabled ?? false) ||
                      (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ??
                          false))
                    ReceipientSelectorChip(
                        currentlySelectedValue: currentlySelectedValue,
                        updateSelectedValue: _updateValueChoose),

                  ///Text Field
                  if((HMSRoomLayout.chatData?.isPrivateChatEnabled??false) ||
                          (HMSRoomLayout.chatData?.isPublicChatEnabled??false) ||
                           (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty??false))
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
