///Package imports
library;

import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[SummaryBox] renders the summary box in the leaderboard summary widget
class SummaryBox extends StatelessWidget {
  final String title;
  final String subtitle;

  const SummaryBox({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: HMSThemeColors.surfaceDefault),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HMSTitleText(
              text: title,
              textColor: HMSThemeColors.onSurfaceMediumEmphasis,
              fontSize: 10,
              letterSpacing: 1.5,
              lineHeight: 16,
            ),
            HMSTitleText(
              text: subtitle,
              textColor: HMSThemeColors.onSurfaceHighEmphasis,
              letterSpacing: 0.15,
            )
          ],
        ),
      ),
    );
  }
}
