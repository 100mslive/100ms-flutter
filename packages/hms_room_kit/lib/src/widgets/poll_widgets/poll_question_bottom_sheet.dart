import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/create_poll_form.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PollQuestionBottomSheet extends StatefulWidget {
  final String pollName;

  const PollQuestionBottomSheet({Key? key, required this.pollName})
      : super(key: key);

  @override
  State<PollQuestionBottomSheet> createState() => _PollQuestionBottomSheetState();
}

class _PollQuestionBottomSheetState extends State<PollQuestionBottomSheet> {

  List<HMSPollQuestionBuilder> questions = [];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: Column(
          children: [
            ///Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
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
                    HMSTitleText(
                      text: widget.pollName,
                      fontSize: 20,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                    ),
                  ],
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
            const CreatePollForm(questionNumber: 1, totalQuestions: 2, questionType: HMSPollQuestionType.singleChoice)
          ],
        ),
      ),
    );
  }
}
