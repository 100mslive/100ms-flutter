import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';

class HMSPollAnswer {
  final String? answerText;
  final Duration duration;
  final int questionId;
  final HMSPollQuestionType questionType;
  final int selectedOption;
  final List<int>? selectedOptions;
  final bool skipped;
  final bool update;

  HMSPollAnswer({
    this.answerText,
    required this.duration,
    required this.questionId,
    required this.questionType,
    required this.selectedOption,
    this.selectedOptions,
    required this.skipped,
    required this.update,
  });

  factory HMSPollAnswer.fromMap(Map map) {
    return HMSPollAnswer(
      answerText: map['answer_text'],
      duration: Duration(milliseconds: map['duration']),
      questionId: map['question_id'],
      questionType:
          HMSPollQuestionTypeValues.getHMSPollQuestionTypeFromString(map['question_type']),
      selectedOption: map['selected_option'],
      selectedOptions: map['selected_options'],
      skipped: map['skipped'],
      update: map['update'],
    );
  }
}
