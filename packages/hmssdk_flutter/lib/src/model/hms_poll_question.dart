import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/hms_poll_answer.dart';
import 'package:hmssdk_flutter/src/model/hms_poll_question_answer.dart';
import 'package:hmssdk_flutter/src/model/hms_poll_question_option.dart';

class HMSPollQuestion {
  final int? answerLongMinLength;
  final int? answerShortMinLength;
  final bool canChangeResponse;
  final bool canSkip;
  final HMSPollQuestionAnswer? correctAnswer;
  final Duration duration;
  final List<HMSPollAnswer> myResponses;
  final bool negative;
  final List<HMSPollQuestionOption> options;
  final int questionId;
  final String text;
  final int total;
  final HMSPollQuestionType type;
  final int weight;
  final bool voted;

  HMSPollQuestion({
    required this.options,
    required this.questionId,
    required this.text,
    required this.type,
    required this.weight,
    required this.total,
    required this.voted,
    this.answerLongMinLength,
    this.answerShortMinLength,
    required this.canChangeResponse,
    required this.canSkip,
    this.correctAnswer,
    required this.duration,
    required this.myResponses,
    required this.negative,
  });

  factory HMSPollQuestion.fromMap(Map map) {
    return HMSPollQuestion(
      answerLongMinLength: map['answer_long_min_length'],
      answerShortMinLength: map['answer_short_min_length'],
      canChangeResponse: map['can_change_response'],
      canSkip: map['can_skip'],
      correctAnswer: map['correct_answer'] != null
          ? HMSPollQuestionAnswer.fromMap(map['correct_answer'])
          : null,
      
      ///TODO: Complete duration mapping
      duration: Duration(milliseconds: map['duration']),
      myResponses: map['my_responses'] != null
          ? (map['my_responses'] as List)
              .map((e) => HMSPollAnswer.fromMap(e))
              .toList()
          : [],
      negative: map['negative'],
      options: map['options'] != null
          ? (map['options'] as List)
              .map((e) => HMSPollQuestionOption.fromMap(e))
              .toList()
          : [],
      questionId: map['question_id'],
      text: map['text'],
      total: map['total'],
      type: HMSPollQuestionTypeValues.getHMSPollQuestionTypeFromString(
          map['type']),
      weight: map['weight'],
      voted: map['voted'],
    );
  }
}
