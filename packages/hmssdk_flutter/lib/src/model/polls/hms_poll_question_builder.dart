///Project imports
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';

///[HMSPollQuestionBuilder] is used to create questions for polls
///It contains getters and setters for poll question builder properties
class HMSPollQuestionBuilder {
  bool? _canSkip;
  bool? _canChangeResponse;
  String? _title;
  Duration? _duration;
  List<HMSPollQuizOption> _options = [];
  List<String> _pollOptions = [];
  String? _text;
  HMSPollQuestionType _type = HMSPollQuestionType.singleChoice;
  int? _weight;
  bool? _answerHidden;
  int? _maxLength;
  int? _minLength;

  set withCanSkip(bool canSkip) {
    _canSkip = canSkip;
  }

  set withText(String text) {
    _text = text;
  }

  set withTitle(String title) {
    _title = title;
  }

  set withDuration(Duration duration) {
    _duration = duration;
  }

  set withType(HMSPollQuestionType type) {
    _type = type;
  }

  set withWeight(int weight) {
    _weight = weight;
  }

  set withMaxLength(int maxLength) {
    _maxLength = maxLength;
  }

  set withMinLength(int minLength) {
    _minLength = minLength;
  }

  set withAnswerHidden(bool answerHidden) {
    _answerHidden = answerHidden;
  }

  set withCanChangeResponse(bool canChangeResponse) {
    _canChangeResponse = canChangeResponse;
  }

  set withOption(List<String> options) {
    _pollOptions = options;
  }

  set addQuizOption(List<HMSPollQuizOption> options) {
    _options = options;
  }

  List<String> get pollOptions => _pollOptions;

  List<HMSPollQuizOption> get quizOptions => _options;

  String? get title => _title;

  String? get text => _text;

  HMSPollQuestionType get type => _type;

  Map<String, dynamic> toMap() {
    return {
      'can_skip': _canSkip,
      'title': _title,
      'duration': _duration?.inMilliseconds,
      'options': _options.map((e) => e.toMap()).toList(),
      'poll_options': _pollOptions,
      'text': _text,
      'type': HMSPollQuestionTypeValues.getStringFromHMSPollQuestionType(_type),
      'weight': _weight,
      'answer_hidden': _answerHidden,
      'max_length': _maxLength,
      'min_length': _minLength,
      'can_change_response': _canChangeResponse,
    };
  }
}

class HMSPollQuizOption {
  final String text;
  bool _isCorrect = false;

  set isCorrect(bool isCorrect) {
    _isCorrect = isCorrect;
  }

  bool get isOptionCorrect => _isCorrect;

  HMSPollQuizOption({required this.text});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'is_correct': _isCorrect,
    };
  }
}
