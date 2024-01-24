import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:tuple/tuple.dart';

class CreatePollForm extends StatefulWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestionType questionType;
  final List<TextEditingController> optionsTextController;
  const CreatePollForm(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.questionType,required this.optionsTextController});

  @override
  State<CreatePollForm> createState() => _CreatePollFormState();
}

class _CreatePollFormState extends State<CreatePollForm> {
  late TextEditingController _questionController;

  List<Tuple2<String, HMSPollQuestionType>> getPollQuestionType() {
    return const [
      Tuple2("Single Choice", HMSPollQuestionType.singleChoice),
      Tuple2("Multiple Choice", HMSPollQuestionType.multiChoice)
    ];
  }

  @override
  void initState() {
    _questionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: HMSThemeColors.surfaceDefault,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HMSTitleText(
                text:
                    "QUESTION ${widget.questionNumber} OF ${widget.totalQuestions}",
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
            DropdownButtonHideUnderline(
                child: HMSDropDown(
                    dropDownItems: getPollQuestionType()
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
                    selectedValue: widget.questionType,
                    updateSelectedValue: (value) {})),
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
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    fillColor: HMSThemeColors.surfaceBright,
                    filled: true,
                    hintText: "e.g. Who will win the match?",
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
              text: "Options",
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
            ),

            const SizedBox(
              height: 8,
            ),

            Expanded(
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.optionsTextController.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                              controller:  widget.optionsTextController[index],
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  fillColor: HMSThemeColors.surfaceBright,
                                  filled: true,
                                  hintText: "Option ${index + 1}",
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
                          IconButton(
                              onPressed: () {
                                // setState(() {
                                //   widget.optionsTextController.removeAt(index);
                                // });
                              },
                              icon: const Icon(Icons.delete))
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
