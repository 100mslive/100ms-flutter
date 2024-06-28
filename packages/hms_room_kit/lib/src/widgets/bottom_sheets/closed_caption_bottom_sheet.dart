///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:provider/provider.dart';

///[EndServiceBottomSheet] is a bottom sheet that is used to render the bottom sheet to stop services
///It has following parameters:
///[bottomSheetTitleIcon] is the icon that is shown on the top left of the bottom sheet
/// [title] is the title of the bottom sheet
/// [subTitle] is the subtitle of the bottom sheet
/// [buttonText] is the text of the button
/// [onButtonPressed] is the function that is called when the button is pressed
/// [buttonColor] is the color of the button
class ClosedCaptionBottomSheet extends StatefulWidget {
  final Widget? bottomSheetTitleIcon;
  final Widget? title;
  final Widget? subTitle;
  final String? buttonText;
  final Function? onButtonPressed;
  final Color? buttonColor;

  const ClosedCaptionBottomSheet(
      {super.key,
      this.bottomSheetTitleIcon,
      this.title,
      this.subTitle,
      this.buttonText,
      this.onButtonPressed,
      this.buttonColor});

  @override
  State<ClosedCaptionBottomSheet> createState() =>
      _ClosedCaptionBottomSheetState();
}

class _ClosedCaptionBottomSheetState extends State<ClosedCaptionBottomSheet> {
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
          ? 0.30
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
                      widget.bottomSheetTitleIcon ?? const SizedBox(),
                      widget.bottomSheetTitleIcon ??
                          const SizedBox(
                            width: 8,
                          ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: widget.title ?? const SizedBox())
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HMSCrossButton(),
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
                          widget.buttonColor ?? HMSThemeColors.primaryDefault),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () {
                    if (widget.onButtonPressed != null) {
                      widget.onButtonPressed!();
                    }
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text: widget.buttonText ?? "",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis),
                    ),
                  )),
              const SizedBox(
                height: 16,
              ),
              widget.subTitle ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
