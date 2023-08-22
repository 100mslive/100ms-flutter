import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

class StopRecordingBottomSheet extends StatelessWidget {
  final MeetingStore meetingStore;
  const StopRecordingBottomSheet({super.key, required this.meetingStore});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.23,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/alert.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.alertErrorDefault, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      HMSTitleText(
                        text: "Stop Recording",
                        textColor: HMSThemeColors.alertErrorDefault,
                        letterSpacing: 0.15,
                        fontSize: 20,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: HMSThemeColors.onSurfaceHighEmphasis,
                          size: 24,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              HMSSubheadingText(
                text:
                    "Are you sure you want to stop recording? You\n can’t undo this action.",
                maxLines: 2,
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(HMSThemeColors.surfaceDim),
                      backgroundColor: MaterialStateProperty.all(
                          HMSThemeColors.alertErrorDefault),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () {
                    meetingStore.stopRtmpAndRecording();
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text: "Stop Recording",
                          textColor: HMSThemeColors.alertErrorBrighter),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
