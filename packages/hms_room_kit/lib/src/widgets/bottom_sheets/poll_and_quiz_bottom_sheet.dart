import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_form.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_quiz_selection_widget.dart';

class PollAndQuizBottomSheet extends StatelessWidget {
  const PollAndQuizBottomSheet({Key? key}) : super(key: key);

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
                  HMSTitleText(
                    text: "Polls and Quizzes",
                    fontSize: 20,
                    textColor: HMSThemeColors.onSurfaceHighEmphasis,
                  ),
                  const HMSCrossButton(),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Divider(
                  color: HMSThemeColors.borderDefault,
                  height: 5,
                ),
              ),

              ///Poll and Quiz selection buttons
              const PollQuizSelectionWidget(),

              const SizedBox(height: 24,),
              ///Poll or Quiz Section
              const PollForm()

            ],
          )),
    );
  }
}
