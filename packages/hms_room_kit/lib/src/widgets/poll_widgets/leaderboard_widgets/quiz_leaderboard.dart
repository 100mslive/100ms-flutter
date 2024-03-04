///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_creator_summary.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_rankings.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_rankings_list.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_voter_summary.dart';

///[QuizLeaderboard] renders the quiz leaderboard
class QuizLeaderboard extends StatefulWidget {
  final HMSPollStore pollStore;

  const QuizLeaderboard({super.key, required this.pollStore});

  @override
  State<QuizLeaderboard> createState() => _QuizLeaderboardState();
}

class _QuizLeaderboardState extends State<QuizLeaderboard> {
  int _totalScore = 0;

  ///[_getTotalScore] returns the total score by adding the weight for each question
  void _getTotalScore() {
    widget.pollStore.poll.questions?.forEach((element) {
      _totalScore += element.weight;
    });
  }

  @override
  void initState() {
    super.initState();
    _getTotalScore();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      text: widget.pollStore.poll.title,
                      fontSize: 20,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  LiveBadge(
                    badgeColor: HMSThemeColors.secondaryDefault,
                    text: "ENDED",
                    width: 50,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Divider(
                  color: HMSThemeColors.borderDefault,
                  height: 5,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HMSTitleText(
                      text: "Participation Summary",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis),
                ],
              ),
              const SizedBox(
                height: 16,
              ),

              ///Here we check whether to render the creator leaderboard summary
              ///or voter leaderboard summary
              Builder(builder: (context) {
                ///Poll creator flow
                ///
                ///If the peer has poll write permissions then we render
                ///the creator summary else we render the voter summary
                if ((context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .pollWrite ??
                    false)) {
                  double? votedPercent, correctPercent;
                  String? votedDescription, correctDescription;

                  ///If respondedPeersCount is not null and totalPeersCount is not null and greater than 0
                  ///then only we assign values else we pass null values.
                  if (widget.pollStore.pollLeaderboardResponse?.summary
                              ?.respondedPeersCount !=
                          null &&
                      ((widget.pollStore.pollLeaderboardResponse?.summary
                                  ?.totalPeersCount ??
                              -1) >
                          0)) {
                    votedPercent = ((widget.pollStore.pollLeaderboardResponse!
                                .summary!.respondedPeersCount! *
                            100) /
                        (widget.pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!));
                    votedDescription =
                        "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
                  }

                  if (widget.pollStore.pollLeaderboardResponse?.summary
                              ?.respondedCorrectlyPeersCount !=
                          null &&
                      ((widget.pollStore.pollLeaderboardResponse?.summary
                                  ?.totalPeersCount ??
                              -1) >
                          0)) {
                    correctPercent = ((widget.pollStore.pollLeaderboardResponse!
                                .summary!.respondedCorrectlyPeersCount! *
                            100) /
                        (widget.pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!));
                    correctDescription =
                        "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedCorrectlyPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
                  }

                  ///Here we render the leaderboard creator summary
                  return LeaderboardCreatorSummary(
                    votedPercent: votedPercent,
                    votedDescription: votedDescription,
                    correctDescription: correctDescription,
                    correctPercent: correctPercent,
                    avgTimeInMilliseconds: widget
                        .pollStore
                        .pollLeaderboardResponse
                        ?.summary
                        ?.averageTime
                        ?.inMilliseconds,
                    avgScore: widget.pollStore.pollLeaderboardResponse!.summary!
                        .averageScore,
                  );
                } else {
                  ///Poll Voter flow
                  ///Here we fetch the entry of the local peer based on the [customerUserId]
                  var localPeerUserId =
                      context.read<MeetingStore>().localPeer?.customerUserId;
                  var index = widget.pollStore.pollLeaderboardResponse?.entries
                          ?.indexWhere((element) =>
                              element.peer?.userId == localPeerUserId) ??
                      -1;

                  ///If the peer details are not present we render empty SizedBox()
                  ///else we render [LeaderboardVoterSummary] widget
                  if (index != -1) {
                    var entry = widget
                        .pollStore.pollLeaderboardResponse?.entries?[index];
                    return LeaderboardVoterSummary(
                      rank:
                          "${entry?.position}/${widget.pollStore.pollLeaderboardResponse?.summary?.totalPeersCount}",
                      points: entry?.score,
                      correctAnswers: entry?.correctResponses,
                      totalQuestions: widget.pollStore.poll.questions?.length,
                      avgTimeInMilliseconds: entry?.duration?.inMilliseconds,
                    );
                  }
                  return const SizedBox();
                }
              }),
              const SizedBox(
                height: 24,
              ),
              LeaderboardRankings(
                  totalScore: _totalScore, pollStore: widget.pollStore),

              /// This is only rendered if the number of peers is greater than 5
              if ((widget.pollStore.pollLeaderboardResponse!.summary
                          ?.totalPeersCount ??
                      0) >
                  5)
                Container(
                  color: HMSThemeColors.surfaceDefault,
                  child: const Divider(
                    height: 5,
                  ),
                ),

              /// This is only rendered if the number of peers is greater than 5
              /// On tapping on viewAll button we render the full list of participant rankings.
              if ((widget.pollStore.pollLeaderboardResponse!.summary
                          ?.totalPeersCount ??
                      0) >
                  5)
                GestureDetector(
                  onTap: () {
                    context.read<MeetingStore>().fetchLeaderboard(
                        widget.pollStore.poll,
                        count: 200,
                        startIndex: 0);
                    var meetingStore = context.read<MeetingStore>();
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: HMSThemeColors.surfaceDim,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                        ),
                        context: context,
                        builder: (ctx) => ChangeNotifierProvider.value(
                            value: meetingStore,
                            child: LeaderboardRankingsList(
                                totalScore: _totalScore,
                                pollStore: widget.pollStore)));
                  },
                  child: Container(
                    color: HMSThemeColors.surfaceDefault,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              HMSSubheadingText(
                                  text: "View All",
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/right_arrow.svg",
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
