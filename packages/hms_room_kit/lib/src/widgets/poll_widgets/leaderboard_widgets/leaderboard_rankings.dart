///Dart imports
library;

import 'dart:math' as math;

////Package imports
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_entry_widget.dart';

///[LeaderboardRankings] renders the leaderboard rankings
class LeaderboardRankings extends StatefulWidget {
  final int totalScore;
  final HMSPollStore pollStore;
  final Color? tileColor;
  final bool showTopFivePeers;

  const LeaderboardRankings(
      {super.key,
      required this.totalScore,
      required this.pollStore,
      this.tileColor,
      this.showTopFivePeers = true});

  @override
  State<LeaderboardRankings> createState() => _LeaderboardRankingsState();
}

class _LeaderboardRankingsState extends State<LeaderboardRankings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.pollStore.pollLeaderboardResponse?.entries?.isNotEmpty ??
            false)
          Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: HMSTitleText(
                  text: "Leaderboard",
                  textColor: HMSThemeColors.onSurfaceHighEmphasis)),
        if (widget.pollStore.pollLeaderboardResponse?.entries?.isNotEmpty ??
            false)
          HMSSubtitleText(
              text: "Based on score and time taken to cast the correct answer",
              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              maxLines: 2),
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),

            ///If [showTopFivePeers] is true we show at max 5 peers
            ///else we show all the participants rankings
            itemCount: widget.showTopFivePeers
                ? math.min(5,
                    widget.pollStore.pollLeaderboardResponse!.entries!.length)
                : widget.pollStore.pollLeaderboardResponse!.entries!.length,
            itemBuilder: (context, index) {
              return LeaderBoardEntryWidget(
                entry:
                    widget.pollStore.pollLeaderboardResponse!.entries![index],
                totalScore: widget.totalScore,
                pollStore: widget.pollStore,
                tileColor: widget.tileColor,
              );
            }),
      ],
    );
  }
}
