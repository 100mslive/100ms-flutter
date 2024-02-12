import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PollResultCard extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestion question;
  final int totalVotes;
  final bool isVoteCountHidden;

  const PollResultCard(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.question,
      required this.totalVotes,
      required this.isVoteCountHidden});

  bool isSelectedOption(int index) {
    if (question.type == HMSPollQuestionType.singleChoice) {
      for (var response in question.myResponses) {
        if (index == response.selectedOption) {
          return true;
        }
      }
    } else if (question.type == HMSPollQuestionType.multiChoice) {
      for (var response in question.myResponses) {
        if (response.selectedOptions?.contains(index) ?? false) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
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
                      text:
                          "QUESTION ${questionNumber + 1} OF $totalQuestions: ",
                      textColor: HMSThemeColors.onSurfaceLowEmphasis,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      lineHeight: 16),
                  HMSTitleText(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      lineHeight: 16,
                      text: Utilities.getQuestionType(question.type),
                      textColor: HMSThemeColors.onSurfaceLowEmphasis)
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              HMSTitleText(
                text: question.text,
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                maxLines: 3,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: question.options.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: HMSSubheadingText(
                                    text: question.options[index].text ?? "",
                                    maxLines: 3,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis),
                              ),
                              if (isVoteCountHidden &&
                                  isSelectedOption(
                                      question.options[index].index))
                                Checkbox(
                                    activeColor:
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                    checkColor: HMSThemeColors.surfaceDefault,
                                    shape: const CircleBorder(),
                                    value: true,
                                    onChanged: (value) {}),
                              if (!isVoteCountHidden)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: HMSSubheadingText(
                                      text:
                                          "${question.options[index].voteCount.toString()} vote${question.options[index].voteCount > 1 ? "s" : ""}",
                                      textColor: HMSThemeColors
                                          .onSurfaceMediumEmphasis),
                                )
                            ],
                          ),
                          if (!isVoteCountHidden)
                            const SizedBox(
                              height: 8,
                            ),
                          if (!isVoteCountHidden)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 8,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: (question.options[index].voteCount),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: HMSThemeColors.primaryDefault,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      )),
                                  Expanded(
                                      flex: totalVotes -
                                          question.options[index].voteCount,
                                      child: Container(
                                          decoration: BoxDecoration(
                                        color: HMSThemeColors.surfaceBright,
                                        borderRadius: BorderRadius.circular(8),
                                      )))
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }),
              if (question.myResponses.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HMSTitleText(
                        text: "Voted",
                        textColor: HMSThemeColors.onSurfaceLowEmphasis)
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
