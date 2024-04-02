///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[LeaderBoardEntryWidget] renders the tile for each peer ranking
class LeaderBoardEntryWidget extends StatelessWidget {
  final HMSPollLeaderboardEntry entry;
  final HMSPollStore pollStore;
  final int totalScore;
  final Color? tileColor;

  const LeaderBoardEntryWidget(
      {super.key,
      required this.entry,
      required this.totalScore,
      required this.pollStore,
      this.tileColor});

  ///[_getPositionBadgeColor] returns the circleAvatar color based on the position
  ///of the peer in the rankings
  Color _getPositionBadgeColor() {
    switch (entry.position) {
      case 1:
        return const Color.fromRGBO(214, 149, 22, 1);
      case 2:
        return const Color.fromRGBO(62, 62, 62, 1);
      case 3:
        return const Color.fromRGBO(89, 59, 15, 1);
      default:
        return Colors.transparent;
    }
  }

  ///[_showTime] returns whether to show time or not
  bool _showTime() {
    return (entry.duration != null && entry.duration!.inSeconds > 0);
  }

  ///[_getFormattedTime] returns the formatted time, in the format 1m 23s meaning 1 minute and 23 seconds
  String _getFormattedTime() {
    String time = "";
    if (entry.duration == null) {
      return time;
    }
    var timeInMinutes = entry.duration!.inMinutes;
    if (timeInMinutes > 0) {
      time = timeInMinutes.toString();
      time += "m ";
    }

    var timeinSeconds = entry.duration!.inSeconds;
    time += (timeinSeconds % 60).toString();
    time += " s";

    return time;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: tileColor ?? HMSThemeColors.surfaceDefault,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 0,
      leading: CircleAvatar(
        radius: 12,
        backgroundColor: _getPositionBadgeColor(),
        child: HMSSubtitleText(
          text: entry.position.toString(),
          textColor: HMSThemeColors.baseWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
      title: HMSSubheadingText(
          text: entry.peer?.userName ?? "Participant",
          textColor: HMSThemeColors.onSurfaceHighEmphasis),
      subtitle: HMSSubtitleText(
          text: entry.totalResponses == 0
              ? "No response"
              : "${entry.score}/$totalScore points",
          textColor: HMSThemeColors.onSurfaceMediumEmphasis),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///If the position of peer is 1st we render the trophy
            if (entry.position == 1) const Text("🏆"),
            if (entry.position == 1)
              const SizedBox(
                width: 12,
              ),
            SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/tick_circle.svg",
              semanticsLabel: "tick",
            ),
            const SizedBox(
              width: 4,
            ),
            HMSSubtitleText(
                text:
                    "${entry.correctResponses}/${pollStore.poll.questions?.length}",
                textColor: HMSThemeColors.onSurfaceHighEmphasis),

            ///Below widgets are only rendered if the taken by the peer is significant
            if (_showTime())
              const SizedBox(
                width: 12,
              ),
            if (_showTime())
              SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/clock.svg",
                semanticsLabel: "clock",
                width: 12,
                height: 12,
              ),
            if (_showTime())
              const SizedBox(
                width: 4,
              ),
            if (_showTime())
              HMSSubtitleText(
                  text: _getFormattedTime(),
                  textColor: HMSThemeColors.onSurfaceHighEmphasis)
          ],
        ),
      ),
    );
  }
}
