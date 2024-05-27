library;

///Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_hand_raise_menu.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/chat_text_field.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[ChatTextUtility] is a utility widget that renders the chat text field and hand raise menu
class ChatTextUtility extends StatefulWidget {
  final Function sendMessage;
  final bool isHLSChat;

  const ChatTextUtility(
      {super.key, required this.sendMessage, required this.isHLSChat});

  @override
  State<ChatTextUtility> createState() => _ChatTextUtilityState();
}

class _ChatTextUtilityState extends State<ChatTextUtility>
    with WidgetsBindingObserver {
  bool showMenu = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bool isKeyboardOpen =
        (MediaQuery.of(context).viewInsets.bottom).toInt() > 0;
    showMenu = !isKeyboardOpen;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (HMSRoomLayout.chatData == null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: HMSThemeColors.surfaceDefault,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                  child: HMSSubheadingText(
                      text: "Chat disabled.",
                      textColor: HMSThemeColors.onSurfaceLowEmphasis),
                ),
              ),
            ),
          ),

        ///Text Field
        if ((HMSRoomLayout.chatData?.isPrivateChatEnabled ?? false) ||
            (HMSRoomLayout.chatData?.isPublicChatEnabled ?? false) ||
            (HMSRoomLayout.chatData?.rolesWhitelist.isNotEmpty ?? false))
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChatTextField(sendMessage: widget.sendMessage),
                  ),
                ),
              ],
            ),
          ),
        if (widget.isHLSChat && showMenu) HLSHandRaiseMenu()
      ],
    );
  }
}
