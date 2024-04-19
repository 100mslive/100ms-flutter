library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[RefreshStreamBottomSheet] is a bottom sheet that is used to render the bottom sheet to refresh the stream
class RefreshStreamBottomSheet extends StatefulWidget {
  const RefreshStreamBottomSheet({super.key});

  @override
  State<RefreshStreamBottomSheet> createState() =>
      _RefreshStreamBottomSheetState();
}

class _RefreshStreamBottomSheetState extends State<RefreshStreamBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
      decoration: BoxDecoration(
        color: HMSThemeColors.surfaceDim,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
        child: Container(
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/end_warning.svg",
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.alertErrorDefault, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      HMSTitleText(
                        text: "Playback Error",
                        textColor: HMSThemeColors.alertErrorDefault,
                        letterSpacing: 0.15,
                        fontSize: 20,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              HMSSubheadingText(
                text:
                    "Something went wrong with the stream. Please tap on ‘Refresh Stream’ to retry.",
                maxLines: 3,
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
                          HMSThemeColors.primaryDefault),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () {
                    HMSHLSPlayerController.start();
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text: "Refresh Stream",
                          textColor: HMSThemeColors.baseWhite),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
