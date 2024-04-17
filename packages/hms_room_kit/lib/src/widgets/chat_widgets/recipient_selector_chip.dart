///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/recipient_selector_widget.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';

///[ReceipientSelectorChip] is a widget that is used to render the receipient selector chip
class ReceipientSelectorChip extends StatefulWidget {
  final String currentlySelectedValue;
  final Function updateSelectedValue;
  final Color? chipColor;

  const ReceipientSelectorChip(
      {Key? key,
      required this.currentlySelectedValue,
      required this.updateSelectedValue,
      this.chipColor})
      : super(key: key);
  @override
  State<ReceipientSelectorChip> createState() => _ReceipientSelectorChipState();
}

class _ReceipientSelectorChipState extends State<ReceipientSelectorChip> {
  String currentlySelectedValue = "";

  @override
  void initState() {
    super.initState();
    currentlySelectedValue = widget.currentlySelectedValue;
  }

  void setSelectedValue() {
    currentlySelectedValue = "Choose a Recipient";
  }

  void _updateValueChoose(String newValue, String? peerId) {
    setState(() {
      currentlySelectedValue = newValue;
    });
    widget.updateSelectedValue(newValue, peerId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        if (!(HMSRoomLayout.chatData?.isPrivateChatEnabled ?? true) &&
            (HMSRoomLayout.chatData?.isPublicChatEnabled ?? false) &&
            (HMSRoomLayout.chatData?.rolesWhitelist.isEmpty ?? false))
          {() {}}
        else
          {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (ctx) => ChangeNotifierProvider.value(
                    value: context.read<MeetingStore>(),
                    child: RecipientSelectorWidget(
                      updateUI: _updateValueChoose,
                      selectedValue: currentlySelectedValue,
                    )))
          }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: HMSTitleText(
                text: "TO",
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                lineHeight: 16,
                letterSpacing: 0.4,
              ),
            ),
            Container(
                height: 24,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: widget.chipColor ?? HMSThemeColors.primaryDefault),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/participants.svg",
                          height: 16,
                          width: 16,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceMediumEmphasis,
                              BlendMode.srcIn),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Selector<MeetingStore, dynamic>(
                            selector: (_, meetingStore) =>
                                meetingStore.recipientSelectorValue,
                            builder: (_, currentValue, __) {
                              ///Here we set the currentValue based on meetingStore.recipientSelectorValue
                              ///This is to handle a case where a peer is selected but the peer leaves
                              ///So we set the chip selection again to "Choose a Recipient"
                              if (currentValue is HMSPeer) {
                                currentlySelectedValue = currentValue.name;
                              } else if (currentValue is HMSRole) {
                                currentlySelectedValue = currentValue.name;
                              } else if (currentValue is String) {
                                currentlySelectedValue = currentValue;
                              }

                              return HMSTitleText(
                                  text: currentlySelectedValue,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  lineHeight: 16,
                                  letterSpacing: 0.4,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                      HMSThemeColors.onPrimaryHighEmphasis);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: HMSThemeColors.onPrimaryHighEmphasis,
                          size: 12,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
