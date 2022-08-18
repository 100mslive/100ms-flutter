import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';

class HLSMessageOrganism extends StatelessWidget {
  final String message;
  final bool isLocalMessage;
  final String? senderName;
  final String date;
  final String role;
  const HLSMessageOrganism({
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
        width: width - 50,
        padding: (role != "" || isLocalMessage)
            ? EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            : EdgeInsets.symmetric(horizontal: 8),
        decoration: (role != "" || isLocalMessage)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: surfaceColor)
            : BoxDecoration(),
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
                      child: HLSTitleText(
                        text: senderName ?? "",
                        fontSize: 14,
                        letterSpacing: 0.1,
                        lineHeight: 20,
                        textColor: defaultColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    HLSSubtitleText(text: date, textColor: subHeadingColor),
                  ],
                ),
                (role != "" || isLocalMessage)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: role != ""
                                    ? Border.all(color: borderColor, width: 1)
                                    : Border.symmetric()),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (isLocalMessage ? "" : "TO YOU"),
                                    style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        color: subHeadingColor,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  isLocalMessage
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: Text(
                                            "|",
                                            style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                color: borderColor,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w600),
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
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.inter(
                                                    fontSize: 10.0,
                                                    color: defaultColor,
                                                    letterSpacing: 1.5,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Text(
                                              "›",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                  fontSize: 10.0,
                                                  color: defaultColor,
                                                  letterSpacing: 1.5,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox()
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              message,
              style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: defaultColor,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
