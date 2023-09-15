///Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///[EndServiceBottomSheet] is a bottom sheet that is used to render the bottom sheet to stop services
///It has following parameters:
///[bottomSheetTitleIcon] is the icon that is shown on the top left of the bottom sheet
/// [title] is the title of the bottom sheet
/// [subTitle] is the subtitle of the bottom sheet
/// [buttonText] is the text of the button
/// [onButtonPressed] is the function that is called when the button is pressed
/// [buttonColor] is the color of the button
class EndServiceBottomSheet extends StatelessWidget {
  final Widget? bottomSheetTitleIcon;
  final Widget? title;
  final Widget? subTitle;
  final String? buttonText;
  final Function? onButtonPressed;
  final Color? buttonColor;

  const EndServiceBottomSheet(
      {super.key,
      this.bottomSheetTitleIcon,
      this.title,
      this.subTitle,
      this.buttonText,
      this.onButtonPressed,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.25,
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
                      bottomSheetTitleIcon ?? const SizedBox(),
                      const SizedBox(
                        width: 8,
                      ),
                      title ?? const SizedBox()
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
                height: 8,
              ),
              subTitle ?? const SizedBox(),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(HMSThemeColors.surfaceDim),
                      backgroundColor: MaterialStateProperty.all(
                          buttonColor ?? HMSThemeColors.alertErrorDefault),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ))),
                  onPressed: () {
                    if (onButtonPressed != null) {
                      onButtonPressed!();
                    }
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: 48,
                    child: Center(
                      child: HMSTitleText(
                          text: buttonText ?? "",
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
