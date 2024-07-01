library;

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[ClosedCaptionControlBottomSheet] is a widget that displays the closed caption control bottom sheet
class ClosedCaptionControlBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;

  const ClosedCaptionControlBottomSheet(
      {super.key, required this.meetingStore});

  @override
  State<ClosedCaptionControlBottomSheet> createState() =>
      _ClosedCaptionControlBottomSheetState();
}

class _ClosedCaptionControlBottomSheetState
    extends State<ClosedCaptionControlBottomSheet> {
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
    return FractionallySizedBox(
      heightFactor: MediaQuery.of(context).orientation == Orientation.portrait
          ? 0.37
          : 0.45,
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
                      HMSTitleText(
                        text: "Closed Captions (CC)",
                        textColor: HMSThemeColors.onSecondaryHighEmphasis,
                        letterSpacing: 0.15,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const HMSCrossButton(),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(HMSThemeColors.surfaceDim),
                      backgroundColor: MaterialStateProperty.all(
                          HMSThemeColors.secondaryDefault),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () {
                    widget.meetingStore.toggleTranscriptionDisplay();
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text:
                              "${widget.meetingStore.isTranscriptionDisplayed ? "Hide" : "Show"} for Me",
                          textColor: HMSThemeColors.onSecondaryHighEmphasis),
                    ),
                  )),
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
                    widget.meetingStore.toggleTranscription();
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text: "Disable For Everyone",
                          textColor: HMSThemeColors.alertErrorBrighter),
                    ),
                  )),
              const SizedBox(
                height: 16,
              ),
              HMSSubheadingText(
                text:
                    "This will disable Closed Captions for everyone in this room. You can enable it again.",
                maxLines: 2,
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
