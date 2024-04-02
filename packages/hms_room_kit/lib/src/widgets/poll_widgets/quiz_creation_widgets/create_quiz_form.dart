///Package imports
library;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[CreateQuizForm] widget renders the poll creation form
class CreateQuizForm extends StatefulWidget {
  final int questionNumber;
  final int totalQuestions;
  final TextEditingController questionController;
  final TextEditingController pointWeightageController;
  final List<TextEditingController> optionsTextController;
  final HMSPollQuestionBuilder questionBuilder;
  final Function deleteQuestionCallback;
  final Function saveQuizCallback;
  const CreateQuizForm(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.optionsTextController,
      required this.questionController,
      required this.questionBuilder,
      required this.deleteQuestionCallback,
      required this.saveQuizCallback,
      required this.pointWeightageController});

  @override
  State<CreateQuizForm> createState() => _CreatePollFormState();
}

class _CreatePollFormState extends State<CreateQuizForm> {
  late TextEditingController _questionController;
  late List<TextEditingController> _optionsTextController;
  late TextEditingController _pointWeightageController;
  final _numberOnlyFormatter = FilteringTextInputFormatter.digitsOnly;

  ///Quiz variables
  HMSPollQuizOption? _correctOption;
  List<HMSPollQuizOption>? _correctOptions = [];

  @override
  void initState() {
    ///Here we initialise the quesetion controller with
    ///the value passed from widget. It's empty when a fresh poll is created
    ///while it has `text` value when it's being edited
    _questionController = widget.questionController;

    _pointWeightageController = widget.pointWeightageController;
    _setWeight(widget.pointWeightageController.text);

    ///Here options text controller gets initialised.
    ///If controllers are passed on to the widget then we just
    ///assign those controllers to _optionsTextController
    if (widget.optionsTextController.isEmpty) {
      _optionsTextController = [
        TextEditingController(),
        TextEditingController()
      ];
    } else {
      _optionsTextController = widget.optionsTextController;
    }

    if (widget.questionBuilder.type == HMSPollQuestionType.singleChoice) {
      int index = widget.questionBuilder.quizOptions
          .indexWhere((element) => element.isOptionCorrect);
      if (index != -1) {
        _correctOption = widget.questionBuilder.quizOptions[index];
      }
    } else if (widget.questionBuilder.type == HMSPollQuestionType.multiChoice) {
      _correctOptions = widget.questionBuilder.quizOptions
          .where((element) => element.isOptionCorrect)
          .toList();
    }
    super.initState();
  }

  @override
  void dispose() {
    ///Here we dispose the question and options controller
    _questionController.dispose();
    for (var element in _optionsTextController) {
      element.dispose();
    }
    super.dispose();
  }

  ///This adds a new option controller
  void _addOption() {
    _optionsTextController.add(TextEditingController());
    setState(() {});
  }

  ///This function checks whether the poll is valid or not
  ///This is checked before launching the poll
  bool _isQuizValid() {
    bool areOptionsFilled = _optionsTextController.length >= 2;
    areOptionsFilled = _pointWeightageController.text.isNotEmpty;
    for (var optionController in _optionsTextController) {
      areOptionsFilled = areOptionsFilled && (optionController.text.isNotEmpty);
    }
    if (widget.questionBuilder.type == HMSPollQuestionType.singleChoice) {
      areOptionsFilled = areOptionsFilled && (_correctOption != null);
    } else if (widget.questionBuilder.type == HMSPollQuestionType.multiChoice) {
      areOptionsFilled =
          areOptionsFilled && (_correctOptions?.isNotEmpty ?? false);
    }
    return (areOptionsFilled && _questionController.text.isNotEmpty);
  }

  ///This function set's the text for the question
  void _setText(String text) {
    widget.questionBuilder.withText = text.trim();
  }

  ///This function set's the weight for the question
  void _setWeight(String text) {
    if (text.isEmpty) {
      return;
    }
    widget.questionBuilder.withWeight = int.parse(text.trim());
  }

  ///This function save the poll option
  void _saveQuizOption(String option, int index) {
    _optionsTextController[index].text = option.trim();
  }

  ///This function saves the option and also fires a callback
  ///to save the question
  void saveQuestion() {
    List<HMSPollQuizOption> quizOptions = [];
    for (var option in _optionsTextController) {
      var quizOption = HMSPollQuizOption(text: option.text);
      quizOption.isCorrect =
          widget.questionBuilder.type == HMSPollQuestionType.singleChoice
              ? _correctOption?.text == option.text
              : _isCorrectAnswer(option.text);
      quizOptions.add(quizOption);
    }
    widget.questionBuilder.addQuizOption = quizOptions;
    if (_isQuizValid()) {
      widget.saveQuizCallback(widget.questionBuilder);
    }
  }

  ///This function updates the poll type selection
  void _updateQuizType(HMSPollQuestionType questionType) {
    widget.questionBuilder.withType = questionType;
    setState(() {});
  }

  bool _isCorrectAnswer(String optionText) {
    if (_correctOptions != null) {
      for (var option in _correctOptions!) {
        if (option.text == optionText) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            HMSTitleText(
                text:
                    "QUESTION ${widget.questionNumber + 1} OF ${widget.totalQuestions}",
                textColor: HMSThemeColors.onSurfaceLowEmphasis,
                fontSize: 10,
                letterSpacing: 1.5,
                lineHeight: 16),
            const SizedBox(
              height: 8,
            ),
            HMSSubheadingText(
              text: "Question Type",
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
            ),
            const SizedBox(
              height: 8,
            ),

            ///Dropdown for poll type
            DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: Utilities.getQuestionTypeForPollQuiz()
                        .map((e) => DropdownMenuItem(
                              value: e.item2,
                              child: HMSTitleText(
                                text: e.item1,
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                fontWeight: FontWeight.w400,
                              ),
                            ))
                        .toList(),
                    buttonStyleData: ButtonStyleData(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: HMSThemeColors.surfaceBright,
                          borderRadius: BorderRadius.circular(8),
                        )),
                    dropdownStyleData: DropdownStyleData(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: HMSThemeColors.surfaceBright,
                        )),
                    selectedValue: widget.questionBuilder.type,
                    updateSelectedValue: (value) {
                      _updateQuizType(value);
                    })),
            const SizedBox(
              height: 8,
            ),
            HMSSubheadingText(
              text: "Question",
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
            ),
            const SizedBox(
              height: 8,
            ),

            ///Textfield for setting the question
            SizedBox(
              height: 48,
              child: TextField(
                cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                style: HMSTextStyle.setTextStyle(
                    color: HMSThemeColors.onSurfaceHighEmphasis),
                controller: _questionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) {
                  _setText(value);
                  setState(() {});
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    fillColor: HMSThemeColors.surfaceBright,
                    filled: true,
                    hintText: "e.g. Solve for 2x + ½ = 21",
                    hintStyle: HMSTextStyle.setTextStyle(
                        color: HMSThemeColors.onSurfaceLowEmphasis,
                        height: 1.5,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w400),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide:
                            BorderSide(color: HMSThemeColors.primaryDefault)),
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            const SizedBox(
              height: 8,
            ),

            ///Divider
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Divider(
                height: 5,
                color: HMSThemeColors.borderBright,
              ),
            ),

            HMSSubheadingText(
              text: "Select one of the radio button to mark the correct answer",
              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              maxLines: 2,
            ),

            const SizedBox(
              height: 8,
            ),

            ///Here we set the options
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _optionsTextController.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                activeColor:
                                    HMSThemeColors.onSurfaceHighEmphasis,
                                checkColor: HMSThemeColors.surfaceDefault,
                                value: (widget.questionBuilder.type ==
                                        HMSPollQuestionType.singleChoice)
                                    ? (_optionsTextController[index].text ==
                                        _correctOption?.text)
                                    : _isCorrectAnswer(
                                        _optionsTextController[index].text),
                                shape: widget.questionBuilder.type ==
                                        HMSPollQuestionType.singleChoice
                                    ? const CircleBorder()
                                    : const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                onChanged: (value) {
                                  if (value == true &&
                                      _optionsTextController[index]
                                          .text
                                          .isNotEmpty) {
                                    if (widget.questionBuilder.type ==
                                        HMSPollQuestionType.singleChoice) {
                                      _correctOption = HMSPollQuizOption(
                                          text: _optionsTextController[index]
                                              .text);
                                      _correctOption?.isCorrect = true;
                                    } else if (widget.questionBuilder.type ==
                                        HMSPollQuestionType.multiChoice) {
                                      var selectedOption = HMSPollQuizOption(
                                          text: _optionsTextController[index]
                                              .text);
                                      selectedOption.isCorrect = true;
                                      _correctOptions?.add(selectedOption);
                                    }
                                  } else {
                                    if (widget.questionBuilder.type ==
                                        HMSPollQuestionType.multiChoice) {
                                      _correctOptions?.removeWhere((element) =>
                                          element.text ==
                                          _optionsTextController[index].text);
                                    }
                                  }

                                  setState(() {});
                                }),
                            const SizedBox(
                              width: 4,
                            )
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextField(
                              cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.words,
                              style: HMSTextStyle.setTextStyle(
                                  color: HMSThemeColors.onSurfaceHighEmphasis),
                              controller: _optionsTextController[index],
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                _saveQuizOption(value, index);
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  fillColor: HMSThemeColors.surfaceBright,
                                  filled: true,
                                  hintText: "Option ${index + 1}",
                                  hintStyle: HMSTextStyle.setTextStyle(
                                      color:
                                          HMSThemeColors.onSurfaceLowEmphasis,
                                      height: 1.5,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      borderSide: BorderSide(
                                          color:
                                              HMSThemeColors.primaryDefault)),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none)),
                            ),
                          ),
                        ),
                        if (_optionsTextController.length > 2)
                          IconButton(
                              onPressed: () {
                                if (_correctOption?.text ==
                                    _optionsTextController[index].text) {
                                  _correctOption = null;
                                }
                                _optionsTextController.removeAt(index);
                                _isQuizValid();
                                setState(() {});
                              },
                              icon: SvgPicture.asset(
                                  "packages/hms_room_kit/lib/src/assets/icons/delete_poll.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      HMSThemeColors.onSurfaceLowEmphasis,
                                      BlendMode.srcIn)))
                      ],
                    ),
                  );
                }),
            if (_optionsTextController.length < 8)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _addOption();
                  },
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
                        text: "Add an option",
                        textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Divider(
                height: 5,
                color: HMSThemeColors.borderBright,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HMSSubheadingText(
                    text: "Point Weightage",
                    textColor: HMSThemeColors.onSurfaceMediumEmphasis),
                SizedBox(
                  width: 88,
                  height: 48,
                  child: TextField(
                    cursorColor: HMSThemeColors.onSurfaceHighEmphasis,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    inputFormatters: [_numberOnlyFormatter],
                    keyboardType: TextInputType.number,
                    style: HMSTextStyle.setTextStyle(
                        color: HMSThemeColors.onSurfaceHighEmphasis),
                    controller: _pointWeightageController,
                    onChanged: (value) {
                      _setWeight(value);
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        fillColor: HMSThemeColors.surfaceBright,
                        filled: true,
                        hintStyle: HMSTextStyle.setTextStyle(
                            color: HMSThemeColors.onSurfaceLowEmphasis,
                            height: 1.5,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                color: HMSThemeColors.primaryDefault)),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            ///Save the question
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (widget.totalQuestions > 1)
                //   HMSEmbeddedButton(
                //     onTap: () =>
                //     widget.deleteQuestionCallback(widget.questionBuilder),
                //     isActive: true,
                //     onColor: HMSThemeColors.surfaceDefault,
                //     child: SvgPicture.asset(
                //       "packages/hms_room_kit/lib/src/assets/icons/delete_poll.svg",
                //       colorFilter: ColorFilter.mode(
                //           HMSThemeColors.onSurfaceHighEmphasis,
                //           BlendMode.srcIn),
                //       fit: BoxFit.scaleDown,
                //     ),
                //   ),
                // const SizedBox(
                //   width: 8,
                // ),
                ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: (_questionController.text.isNotEmpty)
                            ? MaterialStateProperty.all(
                                HMSThemeColors.secondaryDefault)
                            : MaterialStateProperty.all(
                                HMSThemeColors.secondaryDim),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () {
                      saveQuestion();
                    },
                    child: HMSTitleText(
                        text: "Save",
                        textColor: _isQuizValid()
                            ? HMSThemeColors.onSecondaryHighEmphasis
                            : HMSThemeColors.onSecondaryLowEmphasis))
              ],
            )
          ],
        ),
      ),
    );
  }
}
