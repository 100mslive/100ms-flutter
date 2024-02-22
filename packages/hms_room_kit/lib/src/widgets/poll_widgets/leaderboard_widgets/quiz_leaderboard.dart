import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_entry_widget.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';

class QuizLeaderboard extends StatelessWidget {
  final HMSPollStore pollStore;

  const QuizLeaderboard({super.key, required this.pollStore});

  int getTotalScore() {
    int pollScore = 0;

    pollStore.poll.questions?.forEach((element) {
      pollScore += element.weight;
    });

    return pollScore;
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
                    text: pollStore.poll.title,
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
              if (pollStore.pollLeaderboardResponse?.summary != null &&
                  pollStore.pollLeaderboardResponse?.summary
                          ?.respondedPeersCount !=
                      null &&
                  pollStore.pollLeaderboardResponse?.summary?.totalPeersCount !=
                      0) {
                votedPercent = ((pollStore.pollLeaderboardResponse!.summary!
                                .respondedPeersCount! *
                            100) /
                        (pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!))
                    .toStringAsFixed(2);
                votedDescription =
                    "${pollStore.pollLeaderboardResponse!.summary!.respondedPeersCount!}/${pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
              }

              if (pollStore.pollLeaderboardResponse?.summary != null &&
                  pollStore.pollLeaderboardResponse?.summary
                          ?.respondedCorrectlyPeersCount !=
                      null &&
                  pollStore.pollLeaderboardResponse?.summary?.totalPeersCount !=
                      0) {
                correctPercent = ((pollStore.pollLeaderboardResponse!.summary!
                                .respondedCorrectlyPeersCount! *
                            100) /
                        (pollStore.pollLeaderboardResponse!.summary!
                            .totalPeersCount!))
                    .toStringAsFixed(2);
                correctDescription =
                    "${pollStore.pollLeaderboardResponse!.summary!.respondedCorrectlyPeersCount!}/${pollStore.pollLeaderboardResponse!.summary!.totalPeersCount!}";
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
                  if (pollStore.pollLeaderboardResponse?.summary?.averageTime !=
                          null &&
                      pollStore.pollLeaderboardResponse!.summary!.averageTime!
                              .inMilliseconds >
                          0)
                    Expanded(
                      child: SummaryBox(
                          title: "AVG. TIME TAKEN",
                          subtitle: pollStore.pollLeaderboardResponse?.summary
                                      ?.averageTime ==
                                  null
                              ? "-"
                              : "${pollStore.pollLeaderboardResponse!.summary!.averageTime!.inMilliseconds / 1000}s"),
                    ),
                  if (pollStore.pollLeaderboardResponse?.summary?.averageTime !=
                          null &&
                      pollStore.pollLeaderboardResponse!.summary!.averageTime!
                              .inMilliseconds >
                          0)
                    const SizedBox(
                      width: 10,
                    ),
                  Expanded(
                    child: SummaryBox(
                        title: "AVG. SCORE",
                        subtitle: pollStore.pollLeaderboardResponse?.summary
                                    ?.averageScore ==
                                null
                            ? "-"
                            : pollStore
                                .pollLeaderboardResponse!.summary!.averageScore!
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
                itemCount: pollStore.pollLeaderboardResponse!.entries!.length,
                itemBuilder: (context, index) {
                  return LeaderBoardEntryWidget(
                      entry: pollStore.pollLeaderboardResponse!.entries![index],
                      totalScore: getTotalScore());
                }),
            if (pollStore.pollLeaderboardResponse!.entries!.length > 5)
              Container(
                color: HMSThemeColors.surfaceDefault,
                child: const Divider(
                  height: 5,
                ),
              ),
            if (pollStore.pollLeaderboardResponse!.entries!.length > 5)
              GestureDetector(
                onTap: () {},
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
          ],
        ),
      ),
    );
  }
}
