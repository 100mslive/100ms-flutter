class HMSPollQuestionOption {
  final bool optionCase;
  final int index;
  final String? text;
  final bool trim;
  final int voteCount;
  final int weight;

  HMSPollQuestionOption(
      {required this.optionCase,
      required this.index,
      this.text,
      required this.trim,
      required this.voteCount,
      required this.weight});

  factory HMSPollQuestionOption.fromMap(Map map) {
    return HMSPollQuestionOption(
      optionCase: map['case'],
      index: map['index'],
      text: map['text'],
      trim: map['trim'],
      voteCount: map['vote_count'],
      weight: map['weight'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case': optionCase,
      'index': index,
      'text': text,
      'trim': trim,
      'vote_count': voteCount,
      'weight': weight,
    };
  }
}
