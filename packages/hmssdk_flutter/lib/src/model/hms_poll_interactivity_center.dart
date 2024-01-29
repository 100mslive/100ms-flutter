// ignore_for_file: unused_field

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
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
      required HMSActionResultListener? hmsActionResultListener}) async {
    PlatformService.invokeMethod(PlatformMethod.quickStartPoll,
        arguments: {"poll_builder": pollBuilder.toMap()});
  }
}

class HMSPollBuilder {
  bool? _isAnonymous;
  Duration? _duration;
  late HMSPollUserTrackingMode _mode;
  late HMSPollCategory _pollCategory;
  String? _pollId;
  List<HMSPollQuestionBuilder> _questions = [];
  List<HMSRole>? _rolesThatCanViewResponse;
  List<HMSRole>? _rolesThatCanVote;
  late String _title;

  set withAnonymous(bool isAnonymous) {
    _isAnonymous = isAnonymous;
  }

  set withDuration(Duration duration) {
    _duration = duration;
  }

  set withMode(HMSPollUserTrackingMode userTrackingMode) {
    _mode = userTrackingMode;
  }

  set withCategory(HMSPollCategory pollCategory) {
    _pollCategory = pollCategory;
  }

  set withPollId(String pollId) {
    _pollId = pollId;
  }

  HMSPollBuilder addQuestion(HMSPollQuestionBuilder questionBuilder) {
    _questions.add(questionBuilder);
    return this;
  }

  set withRolesThatCanViewResponses(List<HMSRole> rolesThatCanViewResponses) {
    if (_rolesThatCanViewResponse == null) {
      _rolesThatCanViewResponse = [];
    }
    _rolesThatCanViewResponse?.addAll(rolesThatCanViewResponses);
  }

  set withRolesThatCanVote(List<HMSRole> rolesThatCanVote) {
    if (_rolesThatCanVote == null) {
      _rolesThatCanVote = [];
    }
    _rolesThatCanVote?.addAll(rolesThatCanVote);
  }

  set withTitle(String title) {
    _title = title;
  }

  List<HMSPollQuestionBuilder> get questions => _questions;

  HMSPollBuilder build() {
    return this;
  }

  Map<String, dynamic> toMap() {
    return {
      "anonymous": _isAnonymous,
      "duration": _duration?.inMilliseconds,
      "mode":
          HMSPollUserTrackingModeValues.getStringFromHMSPollUserTrackingMode(
              _mode),
      "poll_category":
          HMSPollCategoryValues.getStringFromHMSPollCategory(_pollCategory),
      "poll_id": _pollId,
      "questions": _questions.map((e) => e.toMap()).toList(),
      "roles_that_can_view_responses":
          _rolesThatCanViewResponse?.map((e) => e.name).toList(),
      "roles_that_can_vote": _rolesThatCanVote?.map((e) => e.name).toList(),
      "title": _title
    };
  }
}
