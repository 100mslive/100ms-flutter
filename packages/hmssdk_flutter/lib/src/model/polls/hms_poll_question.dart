///Project imports
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_answer.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_question_answer.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_question_option.dart';

///[HMSPollQuestion] class represents poll question
class HMSPollQuestion {
  final int questionId;
  final bool canSkip;
  final HMSPollQuestionAnswer? correctAnswer;
  final Duration duration;
  final List<HMSPollAnswer> myResponses;
  final List<HMSPollQuestionOption> options;
  final bool canChangeResponse;
  final String text;
  final HMSPollQuestionType type;
  final int weight;
  final bool voted;

  HMSPollQuestion(
      {required this.questionId,
      required this.options,
      required this.text,
      required this.type,
      required this.weight,
      required this.voted,
      required this.canSkip,
      this.correctAnswer,
      required this.duration,
      required this.myResponses,
      required this.canChangeResponse});

  factory HMSPollQuestion.fromMap(Map map) {
    return HMSPollQuestion(
      questionId: map["question_id"],
      canSkip: map['can_skip'],
      correctAnswer: map['correct_answer'] != null
          ? HMSPollQuestionAnswer.fromMap(map['correct_answer'])
          : null,
      duration: Duration(milliseconds: map['duration']),
      myResponses: map['my_responses'] != null
          ? (map['my_responses'] as List)
              .map((e) => HMSPollAnswer.fromMap(e))
              .toList()
          : [],
      options: map['options'] != null
          ? (map['options'] as List)
              .map((e) => HMSPollQuestionOption.fromMap(e))
              .toList()
          : [],
      text: map['text'],
      type: HMSPollQuestionTypeValues.getHMSPollQuestionTypeFromString(
          map['type']),
      weight: map['weight'],
      voted: map['voted'],
      canChangeResponse: map['can_change_response'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'can_skip': canSkip,
      'correct_answer': correctAnswer?.toMap(),
      'duration': duration.inMilliseconds,
      'my_responses': myResponses.map((e) => e.toMap()).toList(),
      'options': options.map((e) => e.toMap()).toList(),
      'text': text,
      'type': HMSPollQuestionTypeValues.getStringFromHMSPollQuestionType(type),
      'weight': weight,
      'voted': voted,
    };
  }
}
