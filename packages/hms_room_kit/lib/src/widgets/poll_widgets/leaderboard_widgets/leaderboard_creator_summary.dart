///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';

///[LeaderboardCreatorSummary] renders the creator quiz summary
class LeaderboardCreatorSummary extends StatelessWidget {
  final double? votedPercent;
  final String? votedDescription;
  final double? correctPercent;
  final String? correctDescription;
  final int? avgTimeInMilliseconds;
  final double? avgScore;

  const LeaderboardCreatorSummary(
      {super.key,
      this.votedPercent,
      this.votedDescription,
      this.correctPercent,
      this.correctDescription,
      this.avgTimeInMilliseconds,
      this.avgScore});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SummaryBox(
                  title: "VOTED",
                  subtitle: (votedPercent == null || votedDescription == null)
                      ? "-"
                      : "${votedPercent!.toStringAsFixed(2)}% ($votedDescription)"),
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
                      : "${correctPercent!.toStringAsFixed(2)}% ($correctDescription)"),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///This is only rendered if the time taken is significant
            if (avgTimeInMilliseconds != null && avgTimeInMilliseconds! > 0)
              Expanded(
                child: SummaryBox(
                    title: "AVG. TIME TAKEN",
                    subtitle: avgTimeInMilliseconds == null
                        ? "-"
                        : "${avgTimeInMilliseconds! / 1000}s"),
              ),

            ///This is only rendered if the time taken is significant
            if (avgTimeInMilliseconds != null && avgTimeInMilliseconds! > 0)
              const SizedBox(
                width: 10,
              ),
            Expanded(
              child: SummaryBox(
                  title: "AVG. SCORE",
                  subtitle: avgScore == null
                      ? "-"
                      : avgScore!.toStringAsPrecision(2)),
            )
          ],
        ),
      ],
    );
  }
}
