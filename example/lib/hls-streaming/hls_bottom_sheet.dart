import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hms_button.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSBottomSheet extends StatefulWidget {
  final String meetingLink;

  HLSBottomSheet({required this.meetingLink});

  @override
  State<HLSBottomSheet> createState() => _HLSBottomSheetState();
}

class _HLSBottomSheetState extends State<HLSBottomSheet> {
  bool _isRecordingOn = false;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: borderColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: defaultColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HLSTitleText(
                        text: "START STREAMING",
                        textColor: subHeadingColor,
                        fontSize: 10,
                        lineHeight: 16,
                      ),
                      HLSTitleText(
                        text: "HLS",
                        textColor: defaultColor,
                        fontSize: 20,
                        letterSpacing: 0.15,
                        lineHeight: 24,
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Divider(
                  height: 5,
                  color: dividerColor,
                ),
              ),
              SvgPicture.asset(
                "assets/icons/live.svg",
                color: defaultColor,
                width: 33,
              ),
              SizedBox(
                height: 20,
              ),
              HLSTitleText(
                text: "HLS Streaming",
                textColor: defaultColor,
                fontSize: 20,
                letterSpacing: 0.15,
                lineHeight: 24,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Stream directly from the browser using any device with multiple hosts and real-time messaging, all within this platform.",
                maxLines: 2,
                style: GoogleFonts.inter(
                    color: subHeadingColor,
                    fontSize: 14,
                    height: 20 / 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: surfaceColor),
                height: 56,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/record.svg",
                            color: defaultColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          HLSTitleText(
                            text: "Record the stream",
                            textColor: defaultColor,
                            fontSize: 14,
                            letterSpacing: 0.25,
                            lineHeight: 20,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                              scale: 0.6,
                              transformHitTests: false,
                              child: CupertinoSwitch(
                                  activeColor: hmsdefaultColor,
                                  value: _isRecordingOn,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      _isRecordingOn = newValue;
                                    });
                                  }))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              HMSButton(
                  width: MediaQuery.of(context).size.width - 30,
                  onPressed: () => {
                        context.read<MeetingStore>().startHLSStreaming(
                            Constant.rtmpUrl, _isRecordingOn, false),
                        Navigator.pop(context)
                      },
                  childWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/live.svg",
                          color: defaultColor,
                          width: 24,
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        HLSTitleText(text: "Go Live", textColor: defaultColor)
                      ],
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/info.svg",
                      color: subHeadingColor,
                      width: 15,
                    ),
                    SizedBox(
                      width: 18.5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 65,
                      child: Text(
                        "If recording has to be enabled later, streaming has to be stopped first.",
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: subHeadingColor,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
