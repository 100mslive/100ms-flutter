import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class CreatePollForm extends StatefulWidget {
  final int questionNumber;
  final int totalQuestions;
  final HMSPollQuestionType questionType;
  const CreatePollForm(
      {super.key,
      required this.questionNumber,
      required this.totalQuestions,
      required this.questionType});

  @override
  State<CreatePollForm> createState() => _CreatePollFormState();
}

class _CreatePollFormState extends State<CreatePollForm> {
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
                    dropDownItems: HMSPollQuestionType.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: HMSTitleText(
                                text: e.name,
                                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                                fontWeight: FontWeight.w400,
                              ),  
                            ))
                        .toList(),
                    buttonStyleData: ButtonStyleData(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8,),decoration: BoxDecoration(
                      color: HMSThemeColors.surfaceBright,
                      borderRadius: BorderRadius.circular(8),
                    )),
                    dropdownStyleData: DropdownStyleData(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),decoration: BoxDecoration(
                      color: HMSThemeColors.surfaceBright,
                    )),
                    selectedValue: widget.questionType,
                    updateSelectedValue: (value) {}))
          ],
        ),
      ),
    );
  }
}
