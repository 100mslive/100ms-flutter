///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_creation_widgets/poll_quiz_form.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_quiz_selection_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/poll_creation_widgets/poll_question_card.dart';

///[PollAndQuizBottomSheet] renders the poll and quiz creation UI
class PollAndQuizBottomSheet extends StatefulWidget {
  const PollAndQuizBottomSheet({Key? key}) : super(key: key);

  @override
  State<PollAndQuizBottomSheet> createState() => _PollAndQuizBottomSheetState();
}

class _PollAndQuizBottomSheetState extends State<PollAndQuizBottomSheet> {
  bool isPollSelected = true;

  void _updatePollQuizSelection(int index) {
    if (index == 0) {
      isPollSelected = true;
    } else {
      isPollSelected = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                if (context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .pollWrite ??
                    false)
                  PollQuizSelectionWidget(
                    updateSelectionCallback: _updatePollQuizSelection,
                  ),

                if (context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .pollWrite ??
                    false)
                  const SizedBox(
                    height: 24,
                  ),

                ///Poll or Quiz Section
                if ((context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .pollWrite ??
                    false))
                  PollQuizForm(isPoll: isPollSelected),

                ///This section shows all the previous polls
                ///which are either started or stopped
                if ((context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollRead ??
                        false) ||
                    (context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollWrite ??
                        false))
                  Selector<MeetingStore, int>(
                      selector: (_, meetingStore) =>
                          meetingStore.pollQuestions.length,
                      builder: (_, data, __) {
                        return data > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: HMSTitleText(
                                  text: "Previous Polls and Quizzes",
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  fontSize: 20,
                                  letterSpacing: 0.15,
                                ),
                              )
                            : const SizedBox();
                      }),

                if ((context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollRead ??
                        false) ||
                    ((context
                            .read<MeetingStore>()
                            .localPeer
                            ?.role
                            .permissions
                            .pollWrite ??
                        false)))
                  Selector<MeetingStore, Tuple2<int, List<HMSPollStore>>>(
                    selector: (_, meetingStore) => Tuple2(
                        meetingStore.pollQuestions.length,
                        meetingStore.pollQuestions),
                    builder: (_, data, __) {
                      if (data.item2.isEmpty &&
                          (!(context
                                  .read<MeetingStore>()
                                  .localPeer
                                  ?.role
                                  .permissions
                                  .pollWrite ??
                              true))) {
                        return Center(
                          child: HMSTitleText(
                              text: "No polls/quizzes started in this session",
                              textColor: HMSThemeColors.onPrimaryHighEmphasis),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.item1,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: data.item2[data.item1 - index - 1],
                                child: const PollQuestionCard());
                          },
                        );
                      }
                    },
                  ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          )),
    );
  }
}
