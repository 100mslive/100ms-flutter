///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/leaderboard_rankings.dart';

///[LeaderboardRankingsList] renders the rankings list
class LeaderboardRankingsList extends StatelessWidget {
  final int totalScore;
  final HMSPollStore pollStore;

  const LeaderboardRankingsList(
      {super.key, required this.totalScore, required this.pollStore});

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
              LeaderboardRankings(
                totalScore: totalScore,
                pollStore: pollStore,
                tileColor: HMSThemeColors.surfaceDim,
                showTopFivePeers: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
