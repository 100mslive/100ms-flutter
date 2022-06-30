import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

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
                      constraints: BoxConstraints(maxWidth: role!=""?60:width-50),
                      child: Text(
                        senderName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: defaultColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.4,
                          color: subHeadingColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                (role != "" || isLocalMessage)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: borderColor, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (isLocalMessage?"BY":"TO") + " YOU",
                                    style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        color: subHeadingColor,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: VerticalDivider(
                                      width: 5,
                                      color: borderColor,
                                    ),
                                  ),
                                  Text(
                                    role != ""?"PRIVATE ›":"EVERYONE",
                                    style: GoogleFonts.inter(
                                        fontSize: 10.0,
                                        color: defaultColor,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w400),
                                  ),
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
