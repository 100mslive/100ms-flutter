///Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///The[HMSPollAnswerResponse] class represents the poll answer
class HMSPollAnswerResponse {
  final bool correct;
  final HMSException? error;
  final int questionIndex;

  HMSPollAnswerResponse(this.error, this.questionIndex,
      {required this.correct});

  factory HMSPollAnswerResponse.fromMap(Map map) {
    return HMSPollAnswerResponse(
        map["error"] == null ? null : HMSException.fromMap(map["error"]),
        map["question_index"],
        correct: map["correct"]);
  }
}
