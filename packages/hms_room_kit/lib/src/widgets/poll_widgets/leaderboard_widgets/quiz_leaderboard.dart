import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_creator_summary.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_rankings.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_rankings_list.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_voter_summary.dart';
import 'package:provider/provider.dart';

class QuizLeaderboard extends StatefulWidget {
  final HMSPollStore pollStore;

  const QuizLeaderboard({super.key, required this.pollStore});

  @override
  State<QuizLeaderboard> createState() => _QuizLeaderboardState();
}

class _QuizLeaderboardState extends State<QuizLeaderboard> {
  int _totalScore = 0;

  ///[getTotalScore] returns the total score by adding the weight for each question
  void getTotalScore() {
    widget.pollStore.poll.questions?.forEach((element) {
      _totalScore += element.weight;
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalScore();
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

              Builder(builder: (context) {
                ///Poll creator flow
                if ((context
                        .read<MeetingStore>()
                        .localPeer
                        ?.role
                        .permissions
                        .pollWrite ??
                    false)) {
                  double? votedPercent, correctPercent;
                  String? votedDescription, correctDescription;
                  if (widget.pollStore.pollLeaderboardResponse?.summary !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse?.summary
                              ?.respondedPeersCount !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse?.summary
                              ?.totalPeersCount !=
                          0) {
                    votedPercent = ((widget.pollStore.pollLeaderboardResponse!
                                .summary!.respondedPeersCount! *
                            100) /
                        (widget.pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!));
                    votedDescription =
                        "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
                  }

                  if (widget.pollStore.pollLeaderboardResponse?.summary !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse?.summary
                              ?.respondedCorrectlyPeersCount !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse?.summary
                              ?.totalPeersCount !=
                          0) {
                    correctPercent = ((widget.pollStore.pollLeaderboardResponse!
                                .summary!.respondedCorrectlyPeersCount! *
                            100) /
                        (widget.pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!));
                    correctDescription =
                        "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedCorrectlyPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
                  }
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
                  var localPeerUserId =
                      context.read<MeetingStore>().localPeer?.customerUserId;
                  var index = widget.pollStore.pollLeaderboardResponse?.entries
                          ?.indexWhere((element) =>
                              element.peer?.userId == localPeerUserId) ??
                      -1;
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

              // /Here we load list of all the users
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
              if ((widget.pollStore.pollLeaderboardResponse!.summary
                          ?.totalPeersCount ??
                      0) >
                  5)
                GestureDetector(
                  onTap: () {
                    context.read<MeetingStore>().fetchLeaderboard(
                        widget.pollStore.poll,
                        count: 50,
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
