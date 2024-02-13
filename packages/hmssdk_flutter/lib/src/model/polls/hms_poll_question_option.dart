///[HMSPollQuestionOption] represents options for poll questions
class HMSPollQuestionOption {
  final int index;
  final String? text;
  final int voteCount;
  final int? weight;

  HMSPollQuestionOption(
      {required this.index,
      this.text,
      required this.voteCount,
      required this.weight});

  factory HMSPollQuestionOption.fromMap(Map map) {
    return HMSPollQuestionOption(
      index: map['index'],
      text: map['text'],
      voteCount: map['vote_count'],
      weight: map['weight'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'text': text,
      'vote_count': voteCount,
      'weight': weight,
    };
  }
}
