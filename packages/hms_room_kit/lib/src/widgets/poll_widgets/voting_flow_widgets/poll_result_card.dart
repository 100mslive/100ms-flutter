import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PollResultCard extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestion question;
  final int totalVotes;

  const PollResultCard(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.question,
      required this.totalVotes});
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
                              HMSSubheadingText(
                                  text: question.options[index].text ?? "",
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis),
                              HMSSubheadingText(
                                  text:
                                      "${question.options[index].voteCount.toString()} vote${question.options[index].voteCount > 1 ? "s" : ""}",
                                  textColor:
                                      HMSThemeColors.onSurfaceMediumEmphasis)
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 8,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                    flex: (question.options[index].voteCount),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: HMSThemeColors.primaryDefault,
                                        borderRadius: BorderRadius.circular(8),
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
              if (question.voted)
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
