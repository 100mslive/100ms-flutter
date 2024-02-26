///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_date_extension.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_result_display.dart';

///[HMSPoll] class represents poll
///
///This class encapsulates various properties and methods related to a poll, including its ID, title, anonymity status,
///category (poll or quiz), creator, duration, user tracking mode, question count, questions, result display settings,
///roles that can view responses, roles that can vote, start time, starter, current state, stop time, and stopper.
class HMSPoll {
  final String pollId;
  final String title;
  final bool anonymous;
  final HMSPollCategory category;
  final HMSPeer? createdBy;
  final Duration? duration;
  final HMSPollUserTrackingMode? pollUserTrackingMode;
  final int? questionCount;
  final List<HMSPollQuestion>? questions;
  final HMSPollResultDisplay? result;
  final List<HMSRole> rolesThatCanViewResponses;
  final List<HMSRole> rolesThatCanVote;
  final DateTime? startedAt;
  final HMSPeer? startedBy;
  final HMSPollState state;
  final DateTime? stoppedAt;
  final HMSPeer? stoppedBy;

  HMSPoll({
    required this.pollId,
    required this.title,
    required this.anonymous,
    required this.category,
    required this.createdBy,
    required this.duration,
    required this.pollUserTrackingMode,
    required this.questionCount,
    required this.questions,
    required this.result,
    required this.rolesThatCanViewResponses,
    required this.rolesThatCanVote,
    required this.startedAt,
    required this.startedBy,
    required this.state,
    required this.stoppedAt,
    required this.stoppedBy,
  });

  factory HMSPoll.fromMap(Map map) {
    return HMSPoll(
      pollId: map['poll_id'],
      title: map['title'],
      anonymous: map['anonymous'],
      category:
          HMSPollCategoryValues.getHMSPollCategoryFromString(map['category']),
      createdBy:
          map['created_by'] != null ? HMSPeer.fromMap(map['created_by']) : null,
      duration: map['duration'] != null
          ? Duration(milliseconds: map['duration'])
          : null,
      pollUserTrackingMode: map['mode'] != null
          ? HMSPollUserTrackingModeValues.getHMSPollUserTrackingModeFromString(
              map['mode'])
          : null,
      questionCount: map['question_count'],
      questions: map['questions'] != null
          ? (map['questions'] as List)
              .map((e) => HMSPollQuestion.fromMap(e))
              .toList()
          : null,
      result: map['result'] != null
          ? HMSPollResultDisplay.fromMap(map['result'])
          : null,
      rolesThatCanViewResponses: (map['roles_that_can_view_responses'] as List)
          .map((e) => HMSRole.fromMap(e))
          .toList(),
      rolesThatCanVote: (map['roles_that_can_vote'] as List)
          .map((e) => HMSRole.fromMap(e))
          .toList(),
      startedAt: map.containsKey("started_at")
          ? HMSDateExtension.convertDateFromEpoch(map['started_at'])
          : null,
      startedBy:
          map['started_by'] != null ? HMSPeer.fromMap(map['started_by']) : null,
      state: HMSPollStateValues.getHMSPollStateFromString(map['state']),
      stoppedAt: map['stopped_at'] != null
          ? HMSDateExtension.convertDateFromEpoch(map['stopped_at'])
          : null,
      stoppedBy:
          map['stopped_by'] != null ? HMSPeer.fromMap(map['stopped_by']) : null,
    );
  }
}
