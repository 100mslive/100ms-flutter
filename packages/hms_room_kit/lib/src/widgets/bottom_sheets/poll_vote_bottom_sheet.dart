///Dart imports
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/voting_flow_widgets/poll_result_card.dart';
import 'package:hms_room_kit/src/widgets/poll_widgets/voting_flow_widgets/poll_vote_card.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PollVoteBottomSheet extends StatelessWidget {
  const PollVoteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var hmsPollStore = context.read<HMSPollStore>();
    return FractionallySizedBox(
      heightFactor: 0.87,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          text: hmsPollStore.poll.title,
                          fontSize: 20,
                          textColor: HMSThemeColors.onSurfaceHighEmphasis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const LiveBadge(),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HMSCrossButton(),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 16),
                child: Divider(
                  color: HMSThemeColors.borderDefault,
                  height: 5,
                ),
              ),
              HMSTitleText(
                text:
                    "${hmsPollStore.poll.startedBy?.name.substring(0, math.min(15, hmsPollStore.poll.startedBy?.name.length ?? 0)) ?? ""} started a poll",
                textColor: HMSThemeColors.onSurfaceHighEmphasis,
                letterSpacing: 0.15,
              ),
              const SizedBox(
                height: 8,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hmsPollStore.poll.questions?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return hmsPollStore.poll.questions![index].voted
                        ? PollResultCard(
                            questionNumber: index,
                            totalQuestions:
                                hmsPollStore.poll.questions?.length ?? 0,
                            question: hmsPollStore.poll.questions![index],
                          )
                        : PollVoteCard(
                            questionNumber: index,
                            totalQuestions:
                                hmsPollStore.poll.questions?.length ?? 0,
                            question: hmsPollStore.poll.questions![index]);
                  }),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
