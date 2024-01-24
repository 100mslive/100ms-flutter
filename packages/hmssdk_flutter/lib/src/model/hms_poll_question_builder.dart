import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';

class HMSPollQuestionBuilder {
  late bool _canSkip;
  late bool _withCanChangeResponse;
  late String _title;
  late Duration _duration;
  late List<HMSPollQuizOption> _options;
  late List<String> _pollOptions;
  late String _text;
  late HMSPollQuestionType _type;
  late int _weight;
  late bool _answerHidden;
  late int _maxLength;
  late int _minLength;

  set withCanSkip(bool canSkip) {
    _canSkip = canSkip;
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

  set withMinLenght(int minLength) {
    _minLength = minLength;
  }

  set withAnswerHidden(bool answerHidden) {
    _answerHidden = answerHidden;
  }

  set withCanChangeResponse(bool canChangeResponse) {
    _withCanChangeResponse = canChangeResponse;
  }

  set addOption(List<String> options) {
    _pollOptions.addAll(options);
  }

  set addQuizOption(List<HMSPollQuizOption> options) {
    _options.addAll(options);
  }

  Map<String,dynamic> toMap(){
    return {
      'can_skip': _canSkip,
      'title': _title,
      'duration': _duration.inMilliseconds,
      'options': _options,
      'poll_options': _pollOptions,
      'text': _text,
      'type': HMSPollQuestionTypeValues.getStringFromHMSPollQuestionType(_type),
      'weight': _weight,
      'answer_hidden': _answerHidden,
      'max_length': _maxLength,
      'min_length': _minLength,
      'can_change_response': _withCanChangeResponse,
    };
  }
}

class HMSPollQuizOption{
  final String text;
  final bool isCorrect;

  HMSPollQuizOption({required this.text, required this.isCorrect});

  Map<String,dynamic> toMap(){
    return {
      'text': text,
      'is_correct': isCorrect,
    };
  }
}
