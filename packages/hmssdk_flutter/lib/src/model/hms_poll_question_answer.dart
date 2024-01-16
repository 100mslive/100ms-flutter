class HMSPollQuestionAnswer {
  final bool caseSensitive;
  final bool emptySpaceTrimmed;
  final bool hidden;
  final int? option;
  final List<int>? options;
  final String text;


  HMSPollQuestionAnswer({
    required this.caseSensitive,
    required this.emptySpaceTrimmed,
    required this.hidden,
    this.option,
    this.options,
    required this.text,
  });

  factory HMSPollQuestionAnswer.fromMap(Map map) {
    return HMSPollQuestionAnswer(
      caseSensitive: map['case_sensitive'] ?? false,
      emptySpaceTrimmed: map['empty_space_trimmed'] ?? false,
      hidden: map['hidden'] ?? false,
      option: map['option'],
      options: map['options']?.cast<int>(),
      text: map['text'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case_sensitive': this.caseSensitive,
      'empty_space_trimmed': this.emptySpaceTrimmed,
      'hidden': this.hidden,
      'option': this.option,
      'options': this.options,
      'text': this.text,
    };
  }
}
