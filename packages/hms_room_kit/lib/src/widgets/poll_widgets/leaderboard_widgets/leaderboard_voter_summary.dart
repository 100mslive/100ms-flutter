///Package imports
library;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';

///[LeaderboardVoterSummary] renders the voter summary
class LeaderboardVoterSummary extends StatelessWidget {
  final String? rank;
  final int? points;
  final int? correctAnswers;
  final int? totalQuestions;
  final int? avgTimeInMilliseconds;
  final bool showYourRank;
  final bool showPoints;
  final int? questionsAttempted;

  const LeaderboardVoterSummary(
      {super.key,
      this.rank,
      this.points,
      this.correctAnswers,
      this.avgTimeInMilliseconds,
      this.totalQuestions,
      this.showYourRank = true,
      this.showPoints = true,
      this.questionsAttempted});

  ///[_setAnsweredProperty] returns the text to rendered based on the questionsAttempted and totalQuestions values
  String _setAnsweredProperty() {
    if (questionsAttempted == null || totalQuestions == null) {
      return "-";
    } else {
      return "${(questionsAttempted! / totalQuestions!) * 100}% ($questionsAttempted/$totalQuestions)";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: showYourRank
                  ? SummaryBox(
                      title: "YOUR RANK", subtitle: rank == null ? "-" : rank!)
                  : SummaryBox(
                      title: "ANSWERED", subtitle: _setAnsweredProperty()),
            ),

            ///This is only rendered is [showPoints] is true
            if (showPoints)
              const SizedBox(
                width: 10,
              ),
            if (showPoints)
              Expanded(
                child: SummaryBox(
                    title: "POINTS",
                    subtitle: points == null ? "-" : points.toString()),
              )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (avgTimeInMilliseconds != null && avgTimeInMilliseconds! > 0)
              Expanded(
                child: SummaryBox(
                    title: "TIME TAKEN",
                    subtitle: avgTimeInMilliseconds == null
                        ? "-"
                        : "${avgTimeInMilliseconds! / 1000} secs"),
              ),

            ///This is only rendered if time taken to answer the question is relevant
            if (avgTimeInMilliseconds != null && avgTimeInMilliseconds! > 0)
              const SizedBox(
                width: 10,
              ),
            Expanded(
              child: SummaryBox(
                  title: "CORRECT ANSWERS",
                  subtitle: (correctAnswers == null || totalQuestions == null)
                      ? "-"
                      : "$correctAnswers/$totalQuestions"),
            )
          ],
        ),
      ],
    );
  }
}
