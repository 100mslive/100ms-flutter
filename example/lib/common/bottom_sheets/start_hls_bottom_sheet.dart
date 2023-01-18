import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_button.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class StartHLSBottomSheet extends StatefulWidget {
  final Key? key;
  StartHLSBottomSheet({this.key}) : super(key: key);

  @override
  State<StartHLSBottomSheet> createState() => _StartHLSBottomSheetState();
}

class _StartHLSBottomSheetState extends State<StartHLSBottomSheet> {
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
                        color: hmsWhiteColor,
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
                      TitleText(
                        text: "START STREAMING",
                        textColor: themeSubHeadingColor,
                        fontSize: 10,
                        lineHeight: 16,
                      ),
                      TitleText(
                        text: "HLS",
                        textColor: themeDefaultColor,
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
                color: themeDefaultColor,
                width: 33,
              ),
              SizedBox(
                height: 20,
              ),
              TitleText(
                text: "HLS Streaming",
                textColor: themeDefaultColor,
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
                    color: themeSubHeadingColor,
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
                    color: themeSurfaceColor),
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
                            color: themeDefaultColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TitleText(
                            text: "Record the stream",
                            textColor: themeDefaultColor,
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
                        context
                            .read<MeetingStore>()
                            .startHLSStreaming(_isRecordingOn, false),
                        Navigator.pop(context)
                      },
                  childWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/live.svg",
                          color: themeDefaultColor,
                          width: 24,
                        ),
                        SizedBox(
                          width: 11,
                        ),
                        TitleText(text: "Go Live", textColor: themeDefaultColor)
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
                      color: themeSubHeadingColor,
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
                            color: themeSubHeadingColor,
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
