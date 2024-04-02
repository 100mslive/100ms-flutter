import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class StartHLSBottomSheet extends StatefulWidget {
  @override
  const StartHLSBottomSheet({key}) : super(key: key);

  @override
  State<StartHLSBottomSheet> createState() => _StartHLSBottomSheetState();
}

class _StartHLSBottomSheetState extends State<StartHLSBottomSheet> {
  bool _isRecordingOn = false;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
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
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HMSTitleText(
                      text: "START STREAMING",
                      textColor: themeSubHeadingColor,
                      fontSize: 10,
                      lineHeight: 16,
                    ),
                    HMSTitleText(
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
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 5,
                color: dividerColor,
              ),
            ),
            SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/live.svg",
              colorFilter: ColorFilter.mode(themeDefaultColor, BlendMode.srcIn),
              width: 33,
            ),
            const SizedBox(
              height: 20,
            ),
            HMSTitleText(
              text: "HLS Streaming",
              textColor: themeDefaultColor,
              fontSize: 20,
              letterSpacing: 0.15,
              lineHeight: 24,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Stream directly from the browser using any device with multiple hosts and real-time messaging, all within this platform.",
              maxLines: 2,
              style: HMSTextStyle.setTextStyle(
                  color: themeSubHeadingColor,
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeSurfaceColor),
              height: 56,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                          colorFilter: ColorFilter.mode(
                              themeDefaultColor, BlendMode.srcIn),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        HMSTitleText(
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
            const SizedBox(
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
                        "packages/hms_room_kit/lib/src/assets/icons/live.svg",
                        colorFilter: ColorFilter.mode(
                            themeDefaultColor, BlendMode.srcIn),
                        width: 24,
                      ),
                      const SizedBox(
                        width: 11,
                      ),
                      HMSTitleText(
                          text: "Go Live", textColor: themeDefaultColor)
                    ],
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/info.svg",
                    colorFilter:
                        ColorFilter.mode(themeSubHeadingColor, BlendMode.srcIn),
                    width: 15,
                  ),
                  const SizedBox(
                    width: 18.5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 65,
                    child: Text(
                      "If recording has to be enabled later, streaming has to be stopped first.",
                      style: HMSTextStyle.setTextStyle(
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
    );
  }
}
