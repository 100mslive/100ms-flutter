///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_creation_widgets/create_poll_form.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/quiz_creation_widgets/create_quiz_form.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_creation_widgets/saved_question_widget.dart';

///[PollQuestionBottomSheet] renders the poll question form sheet
class PollQuestionBottomSheet extends StatefulWidget {
  final String pollName;
  final bool isPoll;
  final List<HMSRole>? rolesThatCanViewResponse;

  const PollQuestionBottomSheet(
      {Key? key,
      required this.pollName,
      required this.isPoll,
      this.rolesThatCanViewResponse})
      : super(key: key);

  @override
  State<PollQuestionBottomSheet> createState() =>
      _PollQuestionBottomSheetState();
}

class _PollQuestionBottomSheetState extends State<PollQuestionBottomSheet> {
  late HMSPollBuilder pollBuilder;
  bool _isQuestionValid = false;
  Map<HMSPollQuestionBuilder, bool> pollQuizQuestionBuilders = {};

  @override
  void initState() {
    ///Here we create a new poll builder object with single question
    pollBuilder = HMSPollBuilder();
    pollQuizQuestionBuilders[HMSPollQuestionBuilder()] = false;

    ///Setting the title of the poll
    pollBuilder.withTitle = widget.pollName;

    ///If hide vote count is true
    if (widget.rolesThatCanViewResponse != null) {
      pollBuilder.withRolesThatCanViewResponses =
          widget.rolesThatCanViewResponse!;
    }
    super.initState();
  }

  ///This function adds a new question builder
  void _addQuestion() {
    pollQuizQuestionBuilders[HMSPollQuestionBuilder()] = false;
    setState(() {});
  }

  void _deleteCallback(HMSPollQuestionBuilder pollQuestionBuilder) {
    pollQuizQuestionBuilders.remove(pollQuestionBuilder);
    setState(() {});
  }

  void _saveCallback(HMSPollQuestionBuilder pollQuestionBuilder) {
    pollQuizQuestionBuilders[pollQuestionBuilder] = true;
    _checkValidity();
    setState(() {});
  }

  void _editCallback(HMSPollQuestionBuilder pollQuestionBuilder) {
    pollQuizQuestionBuilders[pollQuestionBuilder] = false;
    _isQuestionValid = false;
    setState(() {});
  }

  void _checkValidity() {
    var isValid = true;
    pollQuizQuestionBuilders.forEach((key, value) {
      isValid &= value;
    });
    _isQuestionValid = isValid;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Top bar
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 16,
                              color: HMSThemeColors.onSurfaceHighEmphasis,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: HMSTitleText(
                              text: widget.pollName,
                              fontSize: 20,
                              textColor: HMSThemeColors.onSurfaceHighEmphasis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        HMSCrossButton(),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 16),
                  child: Divider(
                    color: HMSThemeColors.borderDefault,
                    height: 5,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///List to render poll form
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pollQuizQuestionBuilders.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: pollQuizQuestionBuilders.values
                                      .elementAt(index)
                                  ? SavedQuestionWidget(
                                      questionNumber: index,
                                      totalQuestions:
                                          pollQuizQuestionBuilders.length,
                                      pollQuestionBuilder:
                                          pollQuizQuestionBuilders.keys
                                              .elementAt(index),
                                      editCallback: _editCallback,
                                      isPoll: widget.isPoll)
                                  : widget.isPoll
                                      ? CreatePollForm(
                                          questionNumber: index,
                                          totalQuestions:
                                              pollQuizQuestionBuilders.length,
                                          questionType: pollQuizQuestionBuilders
                                              .keys
                                              .elementAt(index)
                                              .type,
                                          questionController:
                                              TextEditingController(
                                                  text: pollQuizQuestionBuilders
                                                      .keys
                                                      .elementAt(index)
                                                      .text),
                                          optionsTextController:
                                              pollQuizQuestionBuilders.keys
                                                  .elementAt(index)
                                                  .pollOptions
                                                  .map((e) =>
                                                      TextEditingController(
                                                          text: e))
                                                  .toList(),
                                          deleteQuestionCallback:
                                              _deleteCallback,
                                          questionBuilder:
                                              pollQuizQuestionBuilders.keys
                                                  .elementAt(index),
                                          savePollCallback: _saveCallback,
                                        )
                                      : CreateQuizForm(
                                          questionNumber: index,
                                          totalQuestions:
                                              pollQuizQuestionBuilders.length,
                                          questionController:
                                              TextEditingController(
                                                  text: pollQuizQuestionBuilders
                                                      .keys
                                                      .elementAt(index)
                                                      .text),
                                          optionsTextController:
                                              pollQuizQuestionBuilders.keys
                                                  .elementAt(index)
                                                  .quizOptions
                                                  .map((e) =>
                                                      TextEditingController(
                                                          text: e.text))
                                                  .toList(),
                                          deleteQuestionCallback:
                                              _deleteCallback,
                                          questionBuilder:
                                              pollQuizQuestionBuilders.keys
                                                  .elementAt(index),
                                          saveQuizCallback: _saveCallback,
                                        ),
                            )),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => _addQuestion(),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/add_option.svg",
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSurfaceMediumEmphasis,
                                    BlendMode.srcIn)),
                            const SizedBox(
                              width: 16,
                            ),
                            HMSSubheadingText(
                              text: "Add another question",
                              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all(
                                  HMSThemeColors.surfaceDim),
                              backgroundColor: _isQuestionValid
                                  ? MaterialStateProperty.all(
                                      HMSThemeColors.primaryDefault)
                                  : MaterialStateProperty.all(
                                      HMSThemeColors.primaryDisabled),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ))),
                          onPressed: () {
                            if (_isQuestionValid) {
                              pollQuizQuestionBuilders.forEach((key, value) {
                                if (value) {
                                  pollBuilder.addQuestion(key);
                                }
                              });
                              pollBuilder.withAnonymous = false;
                              pollBuilder.withCategory = widget.isPoll
                                  ? HMSPollCategory.poll
                                  : HMSPollCategory.quiz;
                              pollBuilder.withMode =
                                  HMSPollUserTrackingMode.user_id;

                              context
                                  .read<MeetingStore>()
                                  .quickStartPoll(pollBuilder);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Center(
                              child: HMSTitleText(
                            text: "Launch ${widget.isPoll ? "Poll" : "Quiz"}",
                            textColor: _isQuestionValid
                                ? HMSThemeColors.onPrimaryHighEmphasis
                                : HMSThemeColors.onPrimaryLowEmphasis,
                          )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 64,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
