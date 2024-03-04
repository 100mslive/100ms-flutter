///Package imports
library;

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[PollQuizSelectionButton] widget renders the option with an icon and text side by side
///Used here for poll or quiz selection button
class PollQuizSelectionButton extends StatelessWidget {
  final bool isSelected;
  final String iconName;
  final String text;

  const PollQuizSelectionButton(
      {Key? key,
      required this.isSelected,
      required this.iconName,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: (MediaQuery.of(context).size.width - 48) / 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? HMSThemeColors.primaryDefault
              : HMSThemeColors.borderBright,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: HMSThemeColors.borderBright,
                  border: Border.all(
                    color: isSelected
                        ? HMSThemeColors.primaryDefault
                        : HMSThemeColors.borderBright,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "packages/hms_room_kit/lib/src/assets/icons/$iconName.svg",
                    fit: BoxFit.scaleDown,
                  ),
                )),
            const SizedBox(
              width: 16,
            ),
            HMSTitleText(
              text: text,
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
              letterSpacing: 0.15,
            ),
          ],
        ),
      ),
    );
  }
}
