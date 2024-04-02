///[HMSPollQuestionAnswer] class represents the answer to poll questions
class HMSPollQuestionAnswer {
  final bool hidden;
  final int? option;
  final List<int>? options;

  HMSPollQuestionAnswer({
    required this.hidden,
    this.option,
    this.options,
  });

  factory HMSPollQuestionAnswer.fromMap(Map map) {
    return HMSPollQuestionAnswer(
      hidden: map['hidden'] ?? false,
      option: map['option'],
      options: map['options']?.cast<int>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hidden': this.hidden,
      'option': this.option,
      'options': this.options,
    };
  }
}
