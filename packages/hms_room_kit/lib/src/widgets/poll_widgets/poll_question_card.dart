///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/live_badge.dart';

///[PollQuestionCard] widget renders the cards for poll which are either started, ended, created or are in draft
class PollQuestionCard extends StatelessWidget {
  const PollQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        decoration: BoxDecoration(
          color: HMSThemeColors.surfaceDefault,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HMSTitleText(
                      text: context.read<HMSPollStore>().poll.title,
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      letterSpacing: 0.15,
                      maxLines: 3,
                    ),
                  ),
                  Selector<HMSPollStore, HMSPollState>(
                      selector: (_, hmsPollStore) => hmsPollStore.poll.state,
                      builder: (_, pollState, __) {
                        return pollState == HMSPollState.stopped
                            ? LiveBadge(
                                text: "ENDED",
                                badgeColor: HMSThemeColors.surfaceBrighter,
                                width: 50,
                              )
                            : const LiveBadge();
                      })
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HMSButton(
                      width: 75,
                      onPressed: () {},
                      childWidget: HMSTitleText(
                          text: "View",
                          textColor: HMSThemeColors.onSurfaceHighEmphasis))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
