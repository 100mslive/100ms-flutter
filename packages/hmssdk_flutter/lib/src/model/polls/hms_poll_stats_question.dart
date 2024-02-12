///Project imports
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';

///The [HMSPollStatsQuestion] class represents statistics for a single question in a poll.
class HMSPollStatsQuestion {
  final int attemptedTimes;
  final int? correct;
  final List<int> options;
  final HMSPollQuestionType type;
  final int skipped;

  HMSPollStatsQuestion({
    required this.attemptedTimes,
    this.correct,
    required this.options,
    required this.type,
    required this.skipped,
  });

  factory HMSPollStatsQuestion.fromMap(Map map) {
    return HMSPollStatsQuestion(
      attemptedTimes: map['attempted_times'],
      correct: map['correct'],
      options: map['options'] != null
          ? (map['options'] as List).map((e) => e as int).toList()
          : [],
      type: HMSPollQuestionTypeValues.getHMSPollQuestionTypeFromString(
          map['question_type']),
      skipped: map['skipped'],
    );
  }
}
