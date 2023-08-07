import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final bool isLocalMessage;
  final String? senderName;
  final String date;
  final String role;
  const MessageContainer({
    Key? key,
    required this.isLocalMessage,
    required this.message,
    required this.senderName,
    required this.date,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: isLocalMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width - (role == "" ? 80 : 60),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: themeSurfaceColor),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
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
                                maxWidth:
                                    role != "" ? width * 0.25 : width * 0.5),
                            child: HMSTitleText(
                              text: senderName ?? "Anonymous",
                              fontSize: 14,
                              letterSpacing: 0.1,
                              lineHeight: 20,
                              textColor: themeDefaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          HMSSubtitleText(
                              text: date, textColor: themeSubHeadingColor),
                        ],
                      ),
                      (role != "" || isLocalMessage)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: role != ""
                                          ? Border.all(
                                              color: borderColor, width: 1)
                                          : const Border.symmetric()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (role != "PRIVATE")
                                          Text(
                                            (isLocalMessage ? "" : "TO"),
                                            style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                color: themeSubHeadingColor,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        (isLocalMessage || (role == "PRIVATE"))
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  "|",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      color: borderColor,
                                                      letterSpacing: 1.5,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                        role != ""
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: isLocalMessage
                                                            ? width * 0.25
                                                            : width * 0.15),
                                                    child: Text(
                                                      "${role.toUpperCase()} ",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          color:
                                                              themeDefaultColor,
                                                          letterSpacing: 1.5,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
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
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    options: const LinkifyOptions(humanize: false),
                    style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: themeDefaultColor,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w400),
                    linkStyle: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: hmsdefaultColor,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            if (role == "")
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: PopupMenuButton(
                  color: themeSurfaceColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (context) {
                    return List.generate(1, (index) {
                      return PopupMenuItem(
                        child: Text(
                          'Pin Message',
                          style: TextStyle(
                              color: HMSThemeColors.onSurfaceHighEmphasis),
                        ),
                        onTap: () => context
                            .read<MeetingStore>()
                            .setSessionMetadataForKey(
                                key: SessionStoreKeyValues.getNameFromMethod(
                                    SessionStoreKey.pinnedMessageSessionKey),
                                metadata: "${senderName!}: $message"),
                      );
                    });
                  },
                  child: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/more.svg",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
