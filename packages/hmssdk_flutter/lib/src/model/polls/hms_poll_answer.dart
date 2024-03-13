///Project imports
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';

///[HMSPollAnswer] class represents answer to poll questions
class HMSPollAnswer {
  final String? answerText;
  final Duration? duration;
  final int questionId;
  final HMSPollQuestionType questionType;
  final int? selectedOption;
  final List<int>? selectedOptions;
  final bool skipped;
  final bool update;

  HMSPollAnswer({
    this.answerText,
    this.duration,
    required this.questionId,
    required this.questionType,
    this.selectedOption,
    this.selectedOptions,
    required this.skipped,
    required this.update,
  });

  ///Method to get HMSPollAnswer from map
  factory HMSPollAnswer.fromMap(Map map) {
    return HMSPollAnswer(
      answerText: map['answer'],
      duration:
          map['duration'] != null ? Duration(seconds: map['duration']) : null,
      questionId: map['question_id'],
      questionType: HMSPollQuestionTypeValues.getHMSPollQuestionTypeFromString(
          map['question_type']),
      selectedOption: map['selected_option'],
      selectedOptions: map["selected_options"] != null
          ? List<int>.from(map['selected_options'])
          : null,
      skipped: map['skipped'],
      update: map['update'],
    );
  }

  ///Method to get map from HMSPollAnswer Object
  Map<String, dynamic> toMap() {
    return {
      'answer': answerText,
      'duration': duration?.inSeconds,
      'question_id': questionId,
      'question_type': questionType.toString(),
      'selected_option': selectedOption,
      'selected_options': selectedOptions,
      'skipped': skipped,
      'update': update,
    };
  }
}
