import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class HLSMeetingPage extends StatefulWidget {
  const HLSMeetingPage({Key? key}) : super(key: key);

  @override
  State<HLSMeetingPage> createState() => _HLSMeetingPageState();
}

class _HLSMeetingPageState extends State<HLSMeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              color: Color(0xffCC525F)),
                          child: SvgPicture.asset(
                            "assets/icons/leave_hls.svg",
                            color: Colors.white,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {},
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: defaultColor.withOpacity(0.1),
                                  border: Border.all(
                                      color: defaultColor, width: 0.2)),
                              child: SvgPicture.asset(
                                "assets/icons/hand.svg",
                                color: defaultColor,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: defaultColor.withOpacity(0.1),
                                  border: Border.all(
                                      color: defaultColor, width: 0.2)),
                              child: SvgPicture.asset(
                                "assets/icons/message_badge_off.svg",
                                color: defaultColor,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: defaultColor.withOpacity(0.1),
                                  border: Border.all(
                                      color: defaultColor, width: 0.2)),
                              child: SvgPicture.asset(
                                "assets/icons/camera.svg",
                                color: defaultColor,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: buttonColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/mic.svg",
                                  color: Colors.white,
                                  fit: BoxFit.scaleDown,
                                ),
                                SvgPicture.asset(
                                  "assets/icons/arrow.svg",
                                  color: Colors.white,
                                  fit: BoxFit.scaleDown,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Invite others to join the conversation",
                              style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.25),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Add other broadcasters, or priviliged viewers who can interact with you in real time",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: subHeadingColor,
                                  letterSpacing: 0.25),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {},
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: buttonColor),
                            child: SvgPicture.asset(
                              "assets/icons/mic_state_off.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                border:
                                    Border.all(color: defaultColor, width: 0.2),
                                color: defaultColor.withOpacity(0.1)),
                            child: SvgPicture.asset(
                              "assets/icons/cam_state_off.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ClipOval(
                              child: Material(
                                color: Colors.blue,
                                child: InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: SvgPicture.asset(
                                      "assets/icons/live.svg",
                                      color: defaultColor,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "GO LIVE",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                border:
                                    Border.all(color: defaultColor, width: 0.2),
                                color: defaultColor.withOpacity(0.1)),
                            child: SvgPicture.asset(
                              "assets/icons/screen_share.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                border:
                                    Border.all(color: defaultColor, width: 0.2),
                                color: defaultColor.withOpacity(0.1)),
                            child: SvgPicture.asset(
                              "assets/icons/more.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
