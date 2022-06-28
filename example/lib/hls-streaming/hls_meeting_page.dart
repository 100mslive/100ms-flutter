import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/embedded_button.dart';
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
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      EmbeddedButton(
                        onTap: () => {},
                        width: 45,
                        height: 45,
                        offColor: Color(0xffCC525F),
                        onColor: Color(0xffCC525F),
                        isActive: false,
                        child: SvgPicture.asset(
                          "assets/icons/leave_hls.svg",
                          color: Colors.white,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Row(
                        children: [
                          EmbeddedButton(
                            onTap: () => {},
                            width: 45,
                            height: 45,
                            offColor: hintColor,
                            onColor: backgroundColor,
                            isActive: true,
                            child: SvgPicture.asset(
                              "assets/icons/hand.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          EmbeddedButton(
                            onTap: () => {},
                            width: 45,
                            height: 45,
                            offColor: hintColor,
                            onColor: backgroundColor,
                            isActive: true,
                            child: SvgPicture.asset(
                              "assets/icons/message_badge_off.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          EmbeddedButton(
                            onTap: () => {},
                            width: 45,
                            height: 45,
                            offColor: hintColor,
                            onColor: backgroundColor,
                            isActive: true,
                            child: SvgPicture.asset(
                              "assets/icons/camera.svg",
                              color: defaultColor,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        EmbeddedButton(
                          onTap: () => {},
                          width: 45,
                          height: 45,
                          offColor: hintColor,
                          onColor: backgroundColor,
                          isActive: false,
                          child: SvgPicture.asset(
                            "assets/icons/mic_state_off.svg",
                            color: defaultColor,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        EmbeddedButton(
                          onTap: () => {},
                          width: 45,
                          height: 45,
                          offColor: hintColor,
                          onColor: backgroundColor,
                          isActive: true,
                          child: SvgPicture.asset(
                            "assets/icons/cam_state_off.svg",
                            color: defaultColor,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blue,
                                child: SvgPicture.asset(
                                  "assets/icons/live.svg",
                                  color: defaultColor,
                                  fit: BoxFit.scaleDown,
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
                        EmbeddedButton(
                          onTap: () => {},
                          width: 45,
                          height: 45,
                          offColor: hintColor,
                          onColor: backgroundColor,
                          isActive: true,
                          child: SvgPicture.asset(
                            "assets/icons/screen_share.svg",
                            color: defaultColor,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        EmbeddedButton(
                          onTap: () => {},
                          width: 45,
                          height: 45,
                          offColor: hintColor,
                          onColor: backgroundColor,
                          isActive: true,
                          child: SvgPicture.asset(
                            "assets/icons/more.svg",
                            color: defaultColor,
                            fit: BoxFit.scaleDown,
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
