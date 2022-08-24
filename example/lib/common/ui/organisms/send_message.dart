import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_shape.dart';

class SendMessageScreen extends StatelessWidget {
  final String message;
  final String? senderName;
  final String date;
  final String role;
  const SendMessageScreen({
    Key? key,
    required this.message,
    required this.senderName,
    required this.date,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0, left: 50, top: 15, bottom: 5),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 100),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 14, left: 14, right: 14, top: 5),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          (senderName ?? "") +
                              (role == "" ? "" : " (to " + role + ")"),
                          style: GoogleFonts.inter(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          message,
                          style: GoogleFonts.inter(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                  painter: CustomShape(
                Colors.green.shade300,
              )),
            ],
          ),
          Positioned(
            bottom: 2,
            right: 15,
            child: Text(
              date,
              style: GoogleFonts.inter(
                  fontSize: 10.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
