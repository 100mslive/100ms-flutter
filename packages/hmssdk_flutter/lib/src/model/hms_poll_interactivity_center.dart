// ignore_for_file: unused_field

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSPollInteractivityCenter {
  static void addPollUpdateListener({required HMSPollListener listener}) {
    PlatformService.addPollUpdateListener(listener);
  }

  static void removePollUpdateListener() {
    PlatformService.removePollUpdateListener();
  }

  static void quickStartPoll(
      {required HMSPollBuilder pollBuilder,
      required HMSActionResultListener hmsActionResultListener}) async {
    PlatformService.invokeMethod(PlatformMethod.quickStartPoll,
        arguments: {"poll_builder": pollBuilder.toMap(pollBuilder)});
  }
}

class HMSPollBuilder {
  late bool _answerHidden;
  late bool _canBeSkipped;
  late bool _canChangeResponse;
  late Duration _duration;
  late int _maxLength;
  late int _minLength;
  late bool _negativeMarking;
  late Map<String, bool?> _options;
  late String _title;
  late HMSPollQuestionType _type;
  late int _weight;

  set addOption(String option) {
    _options[option] = null;
  }

  set withAnswerHidden(bool answerHidden) {
    _answerHidden = answerHidden;
  }

  set withCanBeSkipped(bool canBeSkipped) {
    _canBeSkipped = canBeSkipped;
  }

  set withCanChangeResponse(bool canChangeResponse) {
    _canChangeResponse = canChangeResponse;
  }

  set withDuration(Duration duration) {
    _duration = duration;
  }

  set withMaxLength(int maxLength) {
    _maxLength = maxLength;
  }

  set withMinLength(int minLength) {
    _minLength = minLength;
  }

  set withTitle(String title) {
    _title = title;
  }

  set withWeight(int weight) {
    _weight = weight;
  }

  HMSPollBuilder addQuizOption(
      {required String option, required bool isCorrect}) {
    _options[option] = isCorrect;
    return this;
  }

  HMSPollBuilder build() {
    return this;
  }

  Map<String, dynamic> toMap(HMSPollBuilder pollBuilder) {
    Map<String, dynamic> data = {};

    data["answer_hidden"] = pollBuilder._answerHidden;
    data["can_be_skipped"] = pollBuilder._canBeSkipped;
    data["can_change_response"] = pollBuilder._canChangeResponse;
    data["duration"] = pollBuilder._duration.inMilliseconds;
    data["max_length"] = pollBuilder._maxLength;
    data["min_length"] = pollBuilder._minLength;
    data["negative_marking"] = pollBuilder._negativeMarking;
    data["options"] = pollBuilder._options;
    data["title"] = pollBuilder._title;
    data["type"] = HMSPollQuestionTypeValues.getStringFromHMSPollQuestionType(
        pollBuilder._type);
    data["weight"] = pollBuilder._weight;

    return data;
  }
}
