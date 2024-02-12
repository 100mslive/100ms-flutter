///Project imports
import 'package:hmssdk_flutter/src/model/polls/hms_poll_stats_question.dart';

///[HMSPollResultDisplay] class represents the poll results
class HMSPollResultDisplay {
  final List<HMSPollStatsQuestion>? questions;
  final int? totalDistinctUsers;
  final int? totalResponses;
  final int? votingUsers;

  HMSPollResultDisplay({
    this.questions,
    this.totalDistinctUsers,
    this.totalResponses,
    this.votingUsers,
  });

  factory HMSPollResultDisplay.fromMap(Map map) {
    return HMSPollResultDisplay(
      questions: map['questions'] != null
          ? (map['questions'] as List)
              .map((e) => HMSPollStatsQuestion.fromMap(e))
              .toList()
          : [],
      totalDistinctUsers: map['total_distinct_users'],
      totalResponses: map['total_responses'],
      votingUsers: map['voting_users'],
    );
  }
}
