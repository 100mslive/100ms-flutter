///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[SavedQuestionWidget] widget renders the saved question UI
class SavedQuestionWidget extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestionBuilder pollQuestionBuilder;
  final Function editPollCallback;

  const SavedQuestionWidget(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.pollQuestionBuilder,
      required this.editPollCallback});

  String getQuestionType(HMSPollQuestionType questionType) {
    switch (questionType) {
      case HMSPollQuestionType.singleChoice:
        return "SINGLE CHOICE";
      case HMSPollQuestionType.multiChoice:
        return "MULTI CHOICE";
      default:
        return "SINGLE CHOICE";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HMSThemeColors.surfaceDefault,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                HMSTitleText(
                    text: "QUESTION ${questionNumber + 1} OF $totalQuestions: ",
                    textColor: HMSThemeColors.onSurfaceLowEmphasis,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    lineHeight: 16),
                HMSTitleText(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    lineHeight: 16,
                    text: getQuestionType(pollQuestionBuilder.type),
                    textColor: HMSThemeColors.onSurfaceLowEmphasis)
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  expandedAlignment: Alignment.centerLeft,
                  initiallyExpanded: true,
                  iconColor: HMSThemeColors.onSurfaceHighEmphasis,
                  collapsedIconColor: HMSThemeColors.onSurfaceHighEmphasis,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: HMSTitleText(
                    text: pollQuestionBuilder.text ?? "",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    fontWeight: FontWeight.w400,
                    maxLines: 3,
                  ),
                  children: pollQuestionBuilder.pollOptions
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: HMSSubheadingText(
                              text: e,
                              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                              maxLines: 3,
                            ),
                          ))
                      .toList()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // HMSEmbeddedButton(
                //   onTap: () => {},
                //   // widget.deleteQuestionCallback(widget.questionBuilder),
                //   isActive: true,
                //   onColor: HMSThemeColors.surfaceDefault,
                //   child: SvgPicture.asset(
                //     "packages/hms_room_kit/lib/src/assets/icons/delete_poll.svg",
                //     colorFilter: ColorFilter.mode(
                //         HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                //     fit: BoxFit.scaleDown,
                //   ),
                // ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(
                            HMSThemeColors.secondaryDefault),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () {
                      editPollCallback(pollQuestionBuilder);
                    },
                    child: HMSTitleText(
                        text: "Edit",
                        textColor: HMSThemeColors.onSecondaryHighEmphasis))
              ],
            )
          ],
        ),
      ),
    );
  }
}
