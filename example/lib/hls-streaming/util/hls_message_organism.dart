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
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isLocalMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Flexible (
          child: Container(
            padding: role != ""
                ? EdgeInsets.symmetric(vertical: 8, horizontal: 10)
                : EdgeInsets.zero,
            decoration: role != ""
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: surfaceColor)
                : BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      senderName ?? "",
                      style: GoogleFonts.inter(
                          fontSize: 14.0,
                          color: defaultColor,
                          fontWeight: FontWeight.w600),
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
                SizedBox(
                  height: 10,
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
        ),
      ],
    );
  }
}
