///Dart imports
import 'dart:math' as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/quiz_leaderboard.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/voting_flow_widgets/poll_result_card.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/voting_flow_widgets/poll_vote_card.dart';

///[PollVoteBottomSheet] renders the voting bottom sheet for polls
class PollVoteBottomSheet extends StatefulWidget {
  final bool isPoll;

  const PollVoteBottomSheet({super.key, required this.isPoll});

  @override
  State<PollVoteBottomSheet> createState() => _PollVoteBottomSheetState();
}

class _PollVoteBottomSheetState extends State<PollVoteBottomSheet> {
  late PageController quizController;

  @override
  void initState() {
    super.initState();
    context.read<MeetingStore>().addBottomSheet(context);
    if (!widget.isPoll) {
      quizController = PageController(initialPage: getInitialPage());
    }
  }

  int getInitialPage() {
    int initialPage = context
            .read<HMSPollStore>()
            .poll
            .questions
            ?.indexWhere((element) => element.myResponses.isEmpty) ??
        0;
    if (initialPage == -1) {
      return 0;
    }
    return initialPage;
  }

  @override
  void deactivate() {
    context.read<MeetingStore>().removeBottomSheet(context);
    super.deactivate();
  }

  void updatePage(int totalQuestions) {
    if (quizController.page != null) {
      if (quizController.page!.toInt() < totalQuestions - 1) {
        quizController.nextPage(
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn);
      } else {
        setState(() {});
      }
    }
  }

  bool areAllQuestionsAnswered(HMSPoll poll) {
    bool areQuestionsAnswered = true;
    poll.questions?.forEach((element) {
      areQuestionsAnswered =
          areQuestionsAnswered && element.myResponses.isNotEmpty;
    });
    return areQuestionsAnswered;
  }

  @override
  Widget build(BuildContext context) {
    var hmsPollStore = context.watch<HMSPollStore>();
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.4),
                        child: HMSTitleText(
                          text: hmsPollStore.poll.title,
                          fontSize: 20,
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Selector<HMSPollStore, HMSPollState>(
                          selector: (_, hmsPollStore) =>
                              hmsPollStore.poll.state,
                          builder: (_, state, __) {
                            return state == HMSPollState.started
                                ? const LiveBadge()
                                : LiveBadge(
                                    badgeColor: HMSThemeColors.secondaryDefault,
                                    text: "ENDED",
                                    width: 50,
                                  );
                          }),
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
              HMSTitleText(
                text: hmsPollStore.poll.createdBy == null
                    ? "Participant started a new ${hmsPollStore.poll.category == HMSPollCategory.poll ? "poll" : "quiz"}"
                    : "${hmsPollStore.poll.createdBy?.name.substring(0, math.min(15, hmsPollStore.poll.createdBy?.name.length ?? 0)) ?? ""} started a ${widget.isPoll ? "poll" : "quiz"}",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                letterSpacing: 0.15,
              ),
              const SizedBox(
                height: 8,
              ),
              Selector<HMSPollStore, HMSPoll>(
                  selector: (_, pollStore) => pollStore.poll,
                  builder: (_, poll, __) {
                    return (poll.category == HMSPollCategory.poll ||
                            areAllQuestionsAnswered(poll))
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: poll.questions?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, index) {
                              if ((poll.questions![index].myResponses
                                      .isNotEmpty) ||
                                  (poll.state == HMSPollState.stopped)) {
                                var totalVotes = 0;
                                for (var element
                                    in poll.questions![index].options) {
                                  totalVotes += element.voteCount;
                                }
                                var isVoteCountHidden = false;
                                if (poll.rolesThatCanViewResponses.isNotEmpty &&
                                    !poll.rolesThatCanViewResponses.contains(
                                        context
                                            .read<MeetingStore>()
                                            .localPeer
                                            ?.role)) {
                                  isVoteCountHidden = true;
                                }
                                return PollResultCard(
                                  questionNumber: index,
                                  totalQuestions: poll.questions?.length ?? 0,
                                  question: poll.questions![index],
                                  totalVotes: totalVotes,
                                  isVoteCountHidden: isVoteCountHidden,
                                  isPoll: poll.category == HMSPollCategory.poll,
                                  isPollEnded:
                                      poll.state == HMSPollState.stopped,
                                );
                              } else {
                                return PollVoteCard(
                                    questionNumber: index,
                                    totalQuestions: poll.questions?.length ?? 0,
                                    question: poll.questions![index],
                                    isPoll:
                                        poll.category == HMSPollCategory.poll);
                              }
                            })
                        : SizedBox(
                            height: 300,
                            child: PageView.builder(
                                controller: quizController,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PollVoteCard(
                                    questionNumber: index,
                                    totalQuestions: poll.questions?.length ?? 0,
                                    question: poll.questions![index],
                                    isPoll:
                                        poll.category == HMSPollCategory.poll,
                                    startTime: DateTime.now(),
                                    updatePage: updatePage,
                                  );
                                }),
                          );
                  }),
              Selector<HMSPollStore, HMSPollState>(
                  selector: (_, pollStore) => pollStore.poll.state,
                  builder: (_, pollState, __) {
                    ///End Poll is only shown when user has permission to end Poll and poll is not stopped.
                    return (pollState != HMSPollState.stopped &&
                            (context
                                    .read<MeetingStore>()
                                    .localPeer
                                    ?.role
                                    .permissions
                                    .pollWrite ??
                                false))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              HMSButton(
                                width: MediaQuery.of(context).size.width * 0.3,
                                onPressed: () {
                                  context
                                      .read<MeetingStore>()
                                      .stopPoll(hmsPollStore.poll);
                                },
                                childWidget: HMSTitleText(
                                    text:
                                        "End ${widget.isPoll ? "Poll" : "Quiz"}",
                                    textColor:
                                        HMSThemeColors.onPrimaryHighEmphasis),
                                buttonBackgroundColor:
                                    HMSThemeColors.alertErrorDefault,
                              ),
                            ],
                          )
                        : const SizedBox();
                  }),
              Selector<HMSPollStore, bool>(
                  selector: (_, hmsPollStore) =>
                      hmsPollStore.poll.state == HMSPollState.stopped,
                  builder: (_, isPollEnded, __) {
                    return (isPollEnded && !widget.isPoll)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              HMSButton(
                                width: MediaQuery.of(context).size.width * 0.50,
                                onPressed: () {
                                  var meetingStore =
                                      context.read<MeetingStore>();
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor:
                                          HMSThemeColors.surfaceDim,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16)),
                                      ),
                                      context: context,
                                      builder: (ctx) =>
                                          ChangeNotifierProvider.value(
                                              value: meetingStore,
                                              child: QuizLeaderboard(
                                                  pollStore: hmsPollStore)));
                                },
                                childWidget: HMSTitleText(
                                    text: "View Leaderboard",
                                    textColor:
                                        HMSThemeColors.onPrimaryHighEmphasis),
                                buttonBackgroundColor:
                                    HMSThemeColors.primaryDefault,
                              ),
                            ],
                          )
                        : const SizedBox();
                  })
            ],
          ),
        ),
      ),
    );
  }
}