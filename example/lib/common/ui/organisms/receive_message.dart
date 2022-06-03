import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/chat_shape.dart';
import "dart:math" show pi;

class ReceiveMessageScreen extends StatelessWidget {
  final String message;
  final String? senderName;
  final String date;
  final String role;
  const ReceiveMessageScreen({
    Key? key,
    required this.message,
    required this.senderName,
    required this.date,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50.0, left: 10, top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 30),
          Flexible(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: CustomPaint(
            painter: CustomShape(Colors.blue.shade300),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              (senderName ?? "") + (role==""?"":" (to " + role + ")"),
                              style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            date,
                            style: GoogleFonts.inter(
                                fontSize: 10.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              message,
                              style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ))
        ],
      ),
    );
}
}
