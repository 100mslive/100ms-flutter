import 'package:hmssdk_flutter/src/model/hms_poll_stats_question.dart';

class HMSPollResultDisplay {
  final List<HMSPollStatsQuestion> questions;
  final int totalDistinctUsers;
  final int totalResponses;
  final int votingUsers;

  HMSPollResultDisplay({
    required this.questions,
    required this.totalDistinctUsers,
    required this.totalResponses,
    required this.votingUsers,
  });

  factory HMSPollResultDisplay.fromMap(Map map) {
    return HMSPollResultDisplay(
      questions: map['questions'] != null
          ? (map['questions'] as List).map((e) => HMSPollStatsQuestion.fromMap(e)).toList()
          : [],
      totalDistinctUsers: map['total_distinct_users'],
      totalResponses: map['total_responses'],
      votingUsers: map['voting_users'],
    );
  }
}
