///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[ChatUtilitiesBottomSheet] is a bottom sheet that is used to render the bottom sheet to show the options for a message
///like pin message, block user etc
class ChatUtilitiesBottomSheet extends StatefulWidget {
  final HMSMessage message;

  const ChatUtilitiesBottomSheet({Key? key, required this.message})
      : super(key: key);

  @override
  State<ChatUtilitiesBottomSheet> createState() =>
      _ChatUtilitiesBottomSheetState();
}

class _ChatUtilitiesBottomSheetState extends State<ChatUtilitiesBottomSheet> {
  bool isPinned = false;
  bool isBlocked = false;
  bool isLocalBlocked = false;

  @override
  initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
    isPinned = context.read<MeetingStore>().pinnedMessages.indexWhere(
            (element) => element["id"] == widget.message.messageId) !=
        -1;

    // Initial check for isBlocked
    updateIsBlocked();

    // Add listener to update isBlocked when blackListedUserIds changes
    context.read<MeetingStore>().addListener(updateIsBlocked);
  }

  void updateIsBlocked() {
    setState(() {
      isBlocked = context.read<MeetingStore>().blackListedUserIds.indexWhere(
              (userId) => userId == widget.message.sender?.customerUserId) !=
          -1;
      isLocalBlocked = context
              .read<MeetingStore>()
              .blackListedUserIds
              .indexWhere((userId) =>
                  userId ==
                  context.read<MeetingStore>().localPeer?.customerUserId) !=
          -1;
    });
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    context.read<MeetingStore>().removeListener(updateIsBlocked);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HMSTitleText(
                    text: "Message Options",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis),
                const HMSCrossButton()
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(
                color: HMSThemeColors.borderDefault,
                height: 5,
              ),
            ),

            ///This renders the option to pin the message
            ///This is only rendered if the user has the permission to pin messages
            ///If the message is already pinned it renders the option to unpin the message
            ///If the message is not pinned it renders the option to pin the message
            if (HMSRoomLayout.chatData?.allowPinningMessages ?? true)
              ListTile(
                  horizontalTitleGap: 2,
                  onTap: () async {
                    Navigator.pop(context);
                    if (isPinned) {
                      context
                          .read<MeetingStore>()
                          .unpinMessage(widget.message.messageId);
                    } else {
                      context.read<MeetingStore>().pinMessage(widget.message);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/pin.svg",
                    semanticsLabel: "fl_pin_message_icon",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  ),
                  title: HMSSubheadingText(
                      text: isPinned ? "Unpin" : "Pin",
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis)),

            ListTile(
                horizontalTitleGap: 2,
                onTap: () async {
                  Navigator.pop(context);
                  await Clipboard.setData(
                      ClipboardData(text: widget.message.message));
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  "packages/hms_room_kit/lib/src/assets/icons/copy.svg",
                  semanticsLabel: "fl_copy_message_icon",
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                      HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                ),
                title: HMSSubheadingText(
                    text: "Copy Text",
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w600,
                    textColor: HMSThemeColors.onSurfaceHighEmphasis)),

            if ((HMSRoomLayout.chatData?.realTimeControls?.canHideMessage ??
                false))
              ListTile(
                  horizontalTitleGap: 2,
                  onTap: () async {
                    Navigator.pop(context);
                    context.read<MeetingStore>().hideMessage(widget.message);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/hide.svg",
                    semanticsLabel: "fl_copy_message_icon",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  ),
                  title: HMSSubheadingText(
                      text: "Hide for Everyone",
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis)),

            if ((HMSRoomLayout.chatData?.realTimeControls?.canBlockUser ??
                    false) &&
                !(widget.message.sender?.isLocal ?? true) &&
                !isLocalBlocked)
              ListTile(
                  horizontalTitleGap: 2,
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.message.sender?.customerUserId != null) {
                      context.read<MeetingStore>().togglePeerBlock(
                          userId: widget.message.sender!.customerUserId!,
                          isBlocked: isBlocked);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/block.svg",
                    semanticsLabel: "fl_block_peer_icon",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.alertErrorDefault, BlendMode.srcIn),
                  ),
                  title: HMSSubheadingText(
                      text: isBlocked ? "Unblock from Chat" : "Block from Chat",
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      textColor: HMSThemeColors.alertErrorDefault)),

            if ((context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .removeOthers ??
                    false) &&
                !(widget.message.sender?.isLocal ?? true))
              ListTile(
                  horizontalTitleGap: 2,
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.message.sender != null) {
                      context
                          .read<MeetingStore>()
                          .removePeerFromRoom(widget.message.sender!);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/peer_remove.svg",
                    semanticsLabel: "fl_remove_peer",
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                        HMSThemeColors.alertErrorDefault, BlendMode.srcIn),
                  ),
                  title: HMSSubheadingText(
                      text: "Remove Participant",
                      letterSpacing: 0.1,
                      fontWeight: FontWeight.w600,
                      textColor: HMSThemeColors.alertErrorDefault)),
          ]),
        ),
      ),
    );
  }
}
