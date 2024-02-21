import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_entry_widget.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

class QuizLeaderboard extends StatelessWidget {
  final HMSPoll poll;

  const QuizLeaderboard({super.key, required this.poll});

  int getTotalScore() {
    int pollScore = 0;

    poll.questions?.forEach((element) {
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
                    text: poll.title,
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
            Selector<MeetingStore, HMSPollLeaderboardSummary?>(
                selector: (_, meetingStore) =>
                    meetingStore.pollLeaderboardResponse?.summary,
                builder: (_, leaderBoardSummary, __) {
                  String? votedPercent,
                      votedDescription,
                      correctPercent,
                      correctDescription;
                  if (leaderBoardSummary != null &&
                      leaderBoardSummary.respondedPeersCount != null &&
                      leaderBoardSummary.totalPeersCount != null &&
                      leaderBoardSummary.totalPeersCount != 0) {
                    votedPercent =
                        ((leaderBoardSummary.respondedPeersCount! * 100) /
                                (leaderBoardSummary.totalPeersCount!))
                            .toStringAsFixed(2);
                    votedDescription =
                        "${leaderBoardSummary.respondedPeersCount!}/${leaderBoardSummary.totalPeersCount!}";
                  }

                  if (leaderBoardSummary != null &&
                      leaderBoardSummary.respondedCorrectlyPeersCount != null &&
                      leaderBoardSummary.totalPeersCount != null &&
                      leaderBoardSummary.totalPeersCount != 0) {
                    correctPercent =
                        ((leaderBoardSummary.respondedCorrectlyPeersCount! *
                                    100) /
                                (leaderBoardSummary.totalPeersCount!))
                            .toStringAsFixed(2);
                    correctDescription =
                        "${leaderBoardSummary.respondedCorrectlyPeersCount!}/${leaderBoardSummary.totalPeersCount!}";
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SummaryBox(
                            title: "VOTED",
                            subtitle: (votedPercent == null ||
                                    votedDescription == null)
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
            Selector<MeetingStore, HMSPollLeaderboardSummary?>(
                selector: (_, meetingStore) =>
                    meetingStore.pollLeaderboardResponse?.summary,
                builder: (_, leaderBoardSummary, __) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (leaderBoardSummary?.averageTime != null &&
                          leaderBoardSummary!.averageTime!.inMilliseconds > 0)
                        Expanded(
                          child: SummaryBox(
                              title: "AVG. TIME TAKEN",
                              subtitle: leaderBoardSummary.averageTime == null
                                  ? "-"
                                  : "${leaderBoardSummary.averageTime!.inMilliseconds / 1000}s"),
                        ),
                      if (leaderBoardSummary?.averageTime != null &&
                          leaderBoardSummary!.averageTime!.inMilliseconds > 0)
                        const SizedBox(
                          width: 10,
                        ),
                      Expanded(
                        child: SummaryBox(
                            title: "AVG. SCORE",
                            subtitle: leaderBoardSummary?.averageScore == null
                                ? "-"
                                : leaderBoardSummary!.averageScore!
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
                itemCount: context
                    .read<MeetingStore>()
                    .pollLeaderboardResponse!
                    .entries!
                    .length,
                itemBuilder: (context, index) {
                  return LeaderBoardEntryWidget(
                      entry: context
                          .read<MeetingStore>()
                          .pollLeaderboardResponse!
                          .entries![index],
                      totalScore: getTotalScore());
                }),
            if (context
                    .read<MeetingStore>()
                    .pollLeaderboardResponse!
                    .entries!
                    .length >
                5)
              Container(
                color: HMSThemeColors.surfaceDefault,
                child: const Divider(
                  height: 5,
                ),
              ),
            if (context
                    .read<MeetingStore>()
                    .pollLeaderboardResponse!
                    .entries!
                    .length >
                5)
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
