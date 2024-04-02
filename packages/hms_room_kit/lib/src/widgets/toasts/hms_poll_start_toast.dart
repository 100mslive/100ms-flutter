///Dart imports
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/model/poll_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/poll_vote_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_button.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

class HMSPollStartToast extends StatelessWidget {
  final HMSPoll poll;
  final MeetingStore meetingStore;

  const HMSPollStartToast(
      {Key? key, required this.poll, required this.meetingStore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HMSToast(
      leading: SvgPicture.asset(
        "packages/hms_room_kit/lib/src/assets/icons/polls.svg",
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
            HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
      ),
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: HMSSubheadingText(
          text: poll.createdBy == null
              ? "Participant started a new ${poll.category == HMSPollCategory.poll ? "poll" : "quiz"}"
              : "${poll.createdBy?.name.substring(0, math.min(8, poll.createdBy?.name.length ?? 0)) ?? ""}${(poll.createdBy?.name.length ?? 0) > 8 ? "..." : ""} started a new ${poll.category == HMSPollCategory.poll ? "poll" : "quiz"}",
          textColor: HMSThemeColors.onSurfaceHighEmphasis,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          maxLines: 2,
        ),
      ),
      action: HMSToastButton(
        buttonTitle: poll.category == HMSPollCategory.poll ? "Vote" : "Answer",
        action: () {
          var pollStore = context.read<HMSPollStore>();
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: HMSThemeColors.surfaceDim,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              context: context,
              builder: (ctx) => ChangeNotifierProvider.value(
                  value: meetingStore,
                  child: ChangeNotifierProvider.value(
                    value: pollStore,
                    child: PollVoteBottomSheet(
                      isPoll: pollStore.poll.category == HMSPollCategory.poll,
                    ),
                  )));
          meetingStore.removeToast(HMSToastsType.pollStartedToast,
              data: poll.pollId);
        },
        height: 36,
        buttonColor: HMSThemeColors.secondaryDefault,
        textColor: HMSThemeColors.onSecondaryHighEmphasis,
      ),
      cancelToastButton: GestureDetector(
        onTap: () => meetingStore.removeToast(HMSToastsType.pollStartedToast,
            data: poll.pollId),
        child: Icon(
          Icons.close,
          color: HMSThemeColors.onSurfaceHighEmphasis,
          size: 24,
        ),
      ),
    );
  }
}
