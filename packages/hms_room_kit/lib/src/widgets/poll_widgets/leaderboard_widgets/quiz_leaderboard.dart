import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_entry_widget.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';

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
              String? votedPercent,
                  votedDescription,
                  correctPercent,
                  correctDescription;
              if (widget.pollStore.pollLeaderboardResponse?.summary != null &&
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
                            .totalPeersCount!))
                    .toStringAsFixed(2);
                votedDescription =
                    "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
              }

              if (widget.pollStore.pollLeaderboardResponse?.summary != null &&
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
                            .totalPeersCount!))
                    .toStringAsFixed(2);
                correctDescription =
                    "${widget.pollStore.pollLeaderboardResponse!.summary!.respondedCorrectlyPeersCount!}/${widget.pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SummaryBox(
                        title: "VOTED",
                        subtitle:
                            (votedPercent == null || votedDescription == null)
                                ? "-"
                                : "$votedPercent% ($votedDescription)"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SummaryBox(
                        title: "CORRECT ANSWERS",
                        subtitle: (correctPercent == null ||
                                correctDescription == null)
                            ? "-"
                            : "$correctPercent% ($correctDescription)"),
                  )
                ],
              );
            }),
            const SizedBox(
              height: 10,
            ),
            Builder(builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.pollStore.pollLeaderboardResponse?.summary
                              ?.averageTime !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse!.summary!
                              .averageTime!.inMilliseconds >
                          0)
                    Expanded(
                      child: SummaryBox(
                          title: "AVG. TIME TAKEN",
                          subtitle: widget.pollStore.pollLeaderboardResponse
                                      ?.summary?.averageTime ==
                                  null
                              ? "-"
                              : "${widget.pollStore.pollLeaderboardResponse!.summary!.averageTime!.inMilliseconds / 1000}s"),
                    ),
                  if (widget.pollStore.pollLeaderboardResponse?.summary
                              ?.averageTime !=
                          null &&
                      widget.pollStore.pollLeaderboardResponse!.summary!
                              .averageTime!.inMilliseconds >
                          0)
                    const SizedBox(
                      width: 10,
                    ),
                  Expanded(
                    child: SummaryBox(
                        title: "AVG. SCORE",
                        subtitle: widget.pollStore.pollLeaderboardResponse
                                    ?.summary?.averageScore ==
                                null
                            ? "-"
                            : widget.pollStore.pollLeaderboardResponse!.summary!
                                .averageScore!
                                .toStringAsFixed(2)),
                  )
                ],
              );
            }),
            const SizedBox(
              height: 24,
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: HMSTitleText(
                    text: "Leaderboard",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis)),
            HMSSubtitleText(
                text:
                    "Based on score and time taken to cast the correct answer",
                textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                maxLines: 2),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    widget.pollStore.pollLeaderboardResponse!.entries!.length,
                itemBuilder: (context, index) {
                  return LeaderBoardEntryWidget(
                    entry: widget
                        .pollStore.pollLeaderboardResponse!.entries![index],
                    totalScore: _totalScore,
                    pollStore: widget.pollStore,
                  );
                }),

            ///Here we load list of all the users
            // if (widget.pollStore.pollLeaderboardResponse!.entries!.length > 5)
            //   Container(
            //     color: HMSThemeColors.surfaceDefault,
            //     child: const Divider(
            //       height: 5,
            //     ),
            //   ),
            // if (widget.pollStore.pollLeaderboardResponse!.entries!.length > 5)
            //   GestureDetector(
            //     onTap: () {},
            //     child: Container(
            //       color: HMSThemeColors.surfaceDefault,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 16, vertical: 12),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             Row(
            //               children: [
            //                 HMSSubheadingText(
            //                     text: "View All",
            //                     textColor:
            //                         HMSThemeColors.onSurfaceHighEmphasis),
            //                 Padding(
            //                   padding: const EdgeInsets.only(left: 4.0),
            //                   child: SvgPicture.asset(
            //                       "packages/hms_room_kit/lib/src/assets/icons/right_arrow.svg",
            //                       width: 24,
            //                       height: 24,
            //                       colorFilter: ColorFilter.mode(
            //                           HMSThemeColors.onSurfaceHighEmphasis,
            //                           BlendMode.srcIn)),
            //                 ),
            //               ],
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
