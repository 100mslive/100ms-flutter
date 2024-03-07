///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[PollVoteCard] renders the vote card for polls
class PollVoteCard extends StatefulWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestion question;
  final bool isPoll;
  final DateTime? startTime;
  final Function? updatePage;
  final Function? setPageSize;

  const PollVoteCard(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.question,
      required this.isPoll,
      this.startTime,
      this.updatePage,
      this.setPageSize});

  @override
  State<PollVoteCard> createState() => _PollVoteCardState();
}

class _PollVoteCardState extends State<PollVoteCard> {
  HMSPollQuestionOption? selectedOption;
  List<HMSPollQuestionOption> selectedOptions = [];
  bool isPollAnswerValid = false;
  bool _isAnswered = false;

  void resetPollAnswerValidity() {
    if (selectedOption != null || selectedOptions.isNotEmpty) {
      isPollAnswerValid = true;
    } else {
      isPollAnswerValid = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.setPageSize != null) {
      widget.setPageSize!(widget.question.options.length);
    }
  }

  ///[setIsAnswered] function sets whether the question is answered or not
  void setIsAnswered(bool isQuestionAnswered) {
    setState(() {
      _isAnswered = isQuestionAnswered;
    });
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
                          "QUESTION ${widget.questionNumber + 1} OF ${widget.totalQuestions}: ",
                      textColor: HMSThemeColors.onSurfaceLowEmphasis,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      lineHeight: 16),
                  HMSTitleText(
                      fontSize: 10,
                      letterSpacing: 1.5,
                      lineHeight: 16,
                      text: Utilities.getQuestionType(widget.question.type),
                      textColor: HMSThemeColors.onSurfaceLowEmphasis)
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              HMSTitleText(
                text: widget.question.text,
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                maxLines: 3,
                fontWeight: FontWeight.w400,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.question.options.length,
                  itemBuilder: (BuildContext context, index) {
                    return Row(
                      children: [
                        Checkbox(
                            activeColor: HMSThemeColors.onSurfaceHighEmphasis,
                            checkColor: HMSThemeColors.surfaceDefault,
                            value: ((widget.question.type ==
                                    HMSPollQuestionType.singleChoice)
                                ? selectedOption ==
                                    widget.question.options[index]
                                : selectedOptions
                                    .contains(widget.question.options[index])),
                            shape: widget.question.type ==
                                    HMSPollQuestionType.singleChoice
                                ? const CircleBorder()
                                : const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                            onChanged: (value) {
                              if (value == true) {
                                if (widget.question.type ==
                                    HMSPollQuestionType.singleChoice) {
                                  selectedOption =
                                      widget.question.options[index];
                                } else if (widget.question.type ==
                                    HMSPollQuestionType.multiChoice) {
                                  selectedOptions
                                      .add(widget.question.options[index]);
                                }
                              } else {
                                if (widget.question.type ==
                                    HMSPollQuestionType.multiChoice) {
                                  selectedOptions
                                      .remove(widget.question.options[index]);
                                }
                              }
                              resetPollAnswerValidity();
                              setState(() {});
                            }),
                        Expanded(
                          child: HMSSubheadingText(
                              text: widget.question.options[index].text ?? "",
                              maxLines: 3,
                              textColor: HMSThemeColors.onSurfaceHighEmphasis),
                        )
                      ],
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HMSButton(
                      width: MediaQuery.of(context).size.width *
                          (widget.isPoll ? 0.21 : 0.30),
                      onPressed: () {
                        ///Here we check whether the poll/quiz Answer is valid and it's not answered yet
                        if (isPollAnswerValid && !_isAnswered) {
                          if (widget.question.type ==
                                  HMSPollQuestionType.singleChoice &&
                              selectedOption != null) {
                            context
                                .read<MeetingStore>()
                                .addSingleChoicePollResponse(
                                    context.read<HMSPollStore>().poll,
                                    widget.question,
                                    selectedOption!,
                                    timeTakenToAnswer: widget.isPoll
                                        ? null
                                        : widget.startTime != null
                                            ? (DateTime.now()
                                                .difference(widget.startTime!))
                                            : null);
                            selectedOption = null;
                          } else if (widget.question.type ==
                                  HMSPollQuestionType.multiChoice &&
                              selectedOptions.isNotEmpty) {
                            context
                                .read<MeetingStore>()
                                .addMultiChoicePollResponse(
                                    context.read<HMSPollStore>().poll,
                                    widget.question,
                                    selectedOptions,
                                    timeTakenToAnswer: widget.isPoll
                                        ? null
                                        : widget.startTime != null
                                            ? (DateTime.now()
                                                .difference(widget.startTime!))
                                            : null);
                            selectedOptions = [];
                          }
                          if (!widget.isPoll && widget.updatePage != null) {
                            widget.updatePage!(widget.totalQuestions);
                          }
                        }
                      },
                      buttonBackgroundColor: isPollAnswerValid || !_isAnswered
                          ? HMSThemeColors.primaryDefault
                          : HMSThemeColors.primaryDisabled,
                      childWidget: HMSTitleText(
                          text: widget.isPoll ? "Vote" : "Answer",
                          textColor: isPollAnswerValid || !_isAnswered
                              ? HMSThemeColors.onPrimaryHighEmphasis
                              : HMSThemeColors.onPrimaryLowEmphasis))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
