///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[PollResultCard] renders the results for polls
class PollResultCard extends StatelessWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestion question;
  final int totalVotes;
  final bool isVoteCountHidden;
  final bool isPoll;
  final bool isPollEnded;

  const PollResultCard(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.question,
      required this.totalVotes,
      required this.isVoteCountHidden,
      required this.isPoll,
      required this.isPollEnded});

  ///[_isSelectedOption] returns whether the option at given [index] is the selected option or not
  bool _isSelectedOption(int index) {
    ///If the question is a single choice question then we check whether option
    ///at given index is the selected option in [selectedOption]
    if (question.type == HMSPollQuestionType.singleChoice) {
      for (var response in question.myResponses) {
        if (index == response.selectedOption) {
          return true;
        }
      }
    } else if (question.type == HMSPollQuestionType.multiChoice) {
      ///If the question is multi choice, then we check whether the selectedOptions
      ///contains the given option index
      for (var response in question.myResponses) {
        if (response.selectedOptions?.contains(index) ?? false) {
          return true;
        }
      }
    }
    return false;
  }

  ///[_isMyOptionCorrect] returns whether your answer is correct or not
  bool _isMyOptionCorrect() {
    ///We check whether the responses by local peer is not empty
    ///If it's not then we check the type of the question i.e. single or multichoice
    ///
    ///In case of single choice we check whether the selectedOption is equal to the correct answer option
    ///
    ///In case of multi choice we check whether selectionOptions list contains the correct answer option
    ///A question is only marked correct iff a user selects all the correct options.
    if (question.myResponses.isNotEmpty) {
      if (question.type == HMSPollQuestionType.singleChoice) {
        if (question.correctAnswer?.option != null) {
          return question.correctAnswer?.option ==
              question.myResponses[0].selectedOption;
        }
      } else if (question.type == HMSPollQuestionType.multiChoice) {
        if (question.myResponses.length !=
            question.correctAnswer?.options?.length) {
          return false;
        }
        if (question.correctAnswer?.options != null) {
          for (var option in question.correctAnswer!.options!) {
            if (!(question.myResponses[0].selectedOptions?.contains(option) ??
                true)) {
              return false;
            }
          }
          return true;
        }
      }
    }
    return false;
  }

  ///[_isCorrectAnswer] returns whether the given option is correct or not
  ///This marks the correct options from list of options
  bool _isCorrectAnswer(HMSPollQuestionOption option) {
    if (question.type == HMSPollQuestionType.singleChoice) {
      return question.correctAnswer?.option == option.index;
    } else if (question.type == HMSPollQuestionType.multiChoice) {
      if (question.correctAnswer?.options != null) {
        return question.correctAnswer?.options?.contains(option.index) ?? false;
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

            ///If the poll is ended and it's a quiz
            ///and localpeer has answered the quiz
            ///then we show the border based on whether the answer
            ///is correct or not
            border: isPollEnded
                ? (isPoll || question.myResponses.isEmpty)
                    ? const Border()
                    : Border.all(
                        color: _isMyOptionCorrect()
                            ? HMSThemeColors.alertSuccess
                            : HMSThemeColors.alertErrorDefault)
                : null),
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
                              ///If the poll is ended and the option is a correct answer we show a tick
                              if (isPollEnded &&
                                  _isCorrectAnswer(question.options[index]))
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                      "packages/hms_room_kit/lib/src/assets/icons/tick_circle.svg",
                                      semanticsLabel: "tick",
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: HMSSubheadingText(
                                    text: question.options[index].text ?? "",
                                    maxLines: 3,
                                    textColor:
                                        HMSThemeColors.onSurfaceHighEmphasis),
                              ),

                              ///If it's not a poll and selected option show checkbox
                              ///If its a poll then only show when vote count is hidden
                              if ((!isPoll || isVoteCountHidden) &&
                                  _isSelectedOption(
                                      question.options[index].index))
                                isPoll
                                    ? SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/tick_circle.svg",
                                        semanticsLabel: "tick",
                                      )
                                    : HMSSubheadingText(
                                        text: "Your Answer",
                                        textColor: HMSThemeColors
                                            .onSurfaceMediumEmphasis),
                              if (!isVoteCountHidden && isPoll)
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
                          if (!isVoteCountHidden && isPoll)
                            const SizedBox(
                              height: 8,
                            ),
                          if (!isVoteCountHidden && isPoll)
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
                        text: isPoll ? "Voted" : "Answered",
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
