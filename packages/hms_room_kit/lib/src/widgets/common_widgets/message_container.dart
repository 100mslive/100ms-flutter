///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final String? senderName;
  final String date;
  final String role;
  const MessageContainer({
    Key? key,
    required this.message,
    required this.senderName,
    required this.date,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
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
                        maxWidth: role != "" ? width * 0.25 : width * 0.5),
                    child: HMSTitleText(
                      text: senderName ?? "Anonymous",
                      fontSize: 14,
                      letterSpacing: 0.1,
                      lineHeight: 20,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  HMSSubtitleText(
                    text: date,
                    textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                  ),
                ],
              ),
              if (HMSRoomLayout.chatData?.allowPinningMessages ?? true)
                Row(
                  children: [
                    if (role == "")
                      PopupMenuButton(
                        position: PopupMenuPosition.under,
                        color: HMSThemeColors.surfaceDefault,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        itemBuilder: (context) {
                          return List.generate(1, (index) {
                            return PopupMenuItem(
                              height: 52,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/pin.svg",
                                    height: 20,
                                    width: 20,
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceMediumEmphasis,
                                        BlendMode.srcIn),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  HMSTitleText(
                                    text: "Pin Message",
                                    fontSize: 14,
                                    lineHeight: 20,
                                    letterSpacing: 0.1,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                  )
                                ],
                              ),
                              onTap: () => context
                                  .read<MeetingStore>()
                                  .setSessionMetadataForKey(
                                      key: SessionStoreKeyValues
                                          .getNameFromMethod(SessionStoreKey
                                              .pinnedMessageSessionKey),
                                      metadata: "${senderName!}: $message"),
                            );
                          });
                        },
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                          height: 20,
                          width: 20,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceMediumEmphasis,
                              BlendMode.srcIn),
                        ),
                      )
                  ],
                )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SelectableLinkify(
            text: message,
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
    );
  }
}
