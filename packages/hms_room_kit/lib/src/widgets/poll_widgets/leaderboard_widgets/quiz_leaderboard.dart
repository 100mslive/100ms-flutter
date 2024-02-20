import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/leaderboard_widgets/summary_box.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class QuizLeaderboard extends StatelessWidget {
  final HMSPoll poll;

  const QuizLeaderboard({super.key, required this.poll});

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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SummaryBox(title: "VOTED", subtitle: "90% (9/10)"),
                  SummaryBox(title: "CORRECT ANSWERS", subtitle: "80% (8/10)")
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SummaryBox(title: "AVG. TIME TAKEN", subtitle: "4 secs"),
                  SummaryBox(title: "AVG. SCORE", subtitle: "10")
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: HMSTitleText(text: "Leaderboard", textColor: HMSThemeColors.onSurfaceHighEmphasis)),
                HMSSubtitleText(text: "Based on score and time taken to cast the correct answer", textColor: HMSThemeColors.onSurfaceMediumEmphasis,maxLines: 2)
            ],
          ),
        ),
      ),
    );
  }
}
