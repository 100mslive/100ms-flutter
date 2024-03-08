///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HMSListenableButton] is a button that listens to the changes in the text field
///and changes the color of the button accordingly
///If the text field is empty, the button is disabled
///The button is disabled if the [isDisabled] property is set to true
///If the text field is not empty, the button is enabled
///
///The button takes following parameters:
///[width] - The width of the button
///[shadowColor] - The shadow color of the button
///[onPressed] - The function that is called when the button is pressed
///[childWidget] - The child widget of the button
///[textController] - The text controller of the text field
///[isDisabled] - The property that determines whether the button is disabled or not
class HMSListenableButton extends StatelessWidget {
  final double width;
  final Color? shadowColor;
  final Function() onPressed;
  final Widget childWidget;
  final TextEditingController textController;
  final bool isDisabled;

  const HMSListenableButton(
      {super.key,
      required this.width,
      this.shadowColor,
      required this.onPressed,
      required this.childWidget,
      required this.textController,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: textController,
          builder: (context, value, child) {
            return ElevatedButton(
                style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all(
                        shadowColor ?? HMSThemeColors.surfaceDim),
                    backgroundColor:
                        (textController.text.trim().isEmpty || isDisabled)
                            ? MaterialStateProperty.all(
                                HMSThemeColors.primaryDisabled)
                            : MaterialStateProperty.all(
                                HMSThemeColors.primaryDefault),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: onPressed,
                child: childWidget);
          }),
    );
  }
}
