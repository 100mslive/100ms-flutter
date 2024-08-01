///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_utilities_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[MessageContainer] is a widget that is used to render the message container
class MessageContainer extends StatelessWidget {
  final HMSMessage message;
  final bool isHLSChat;
  final DateFormat formatter = DateFormat('hh:mm a');

  MessageContainer({Key? key, required this.message, this.isHLSChat = false})
      : super(key: key);

  String sender(HMSMessageRecipient? hmsMessageRecipient) {
    if (hmsMessageRecipient == null) return "";
    if ((hmsMessageRecipient.recipientPeer != null) &&
        (hmsMessageRecipient.recipientRoles == null)) {
      if (hmsMessageRecipient.recipientPeer is HMSLocalPeer) {
        return "to You (DM)";
      } else {
        return "to ${hmsMessageRecipient.recipientPeer?.name} (DM)";
      }
    } else if ((hmsMessageRecipient.recipientPeer == null) &&
        (hmsMessageRecipient.recipientRoles != null)) {
      return "to ${hmsMessageRecipient.recipientRoles?.first.name} (Group)";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isHLSChat
              ? sender(message.hmsMessageRecipient) != ""
                  ? HMSThemeColors.backgroundDefault
                  : HMSThemeColors.backgroundDim
              : sender(message.hmsMessageRecipient) != ""
                  ? HMSThemeColors.surfaceDefault
                  : HMSThemeColors.surfaceDim,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: sender(message.hmsMessageRecipient) == ""
                                ? width * 0.25
                                : width * 0.5),
                        child: HMSTitleText(
                          text: message.sender?.name ?? "Anonymous",
                          fontSize: 14,
                          letterSpacing: 0.1,
                          lineHeight: 20,
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: width * 0.5),
                        child: HMSSubtitleText(
                            text: sender(message.hmsMessageRecipient),
                            textColor: HMSThemeColors.onSurfaceMediumEmphasis),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HMSSubtitleText(
                        text: formatter.format(message.time),
                        textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          var meetingStore = context.read<MeetingStore>();
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: HMSThemeColors.surfaceDim,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                            ),
                            context: context,
                            builder: (ctx) => ChangeNotifierProvider.value(
                                value: meetingStore,
                                child: ChatUtilitiesBottomSheet(
                                  message: message,
                                )),
                          );
                        },
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceMediumEmphasis,
                              BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              SelectableLinkify(
                text: message.message.trim().toString(),
                onOpen: (link) async {
                  Uri url = Uri.parse(link.url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                options: const LinkifyOptions(humanize: false),
                style: HMSTextStyle.setTextStyle(
                    fontSize: 14.0,
                    color: HMSThemeColors.onSurfaceHighEmphasis,
                    height: 20 / 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.w400),
                linkStyle: HMSTextStyle.setTextStyle(
                    fontSize: 14.0,
                    color: HMSThemeColors.primaryDefault,
                    letterSpacing: 0.25,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
