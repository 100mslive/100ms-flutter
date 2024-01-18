// ignore_for_file: unused_field

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/enum/hms_poll_enum.dart';
import 'package:hmssdk_flutter/src/model/hms_poll_question.dart';
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
        arguments: {"poll_builder": pollBuilder.toMap()});
  }
}

class HMSPollBuilder {
  late bool _anonymous;
  late Duration _duration;
  late HMSPollUserTrackingMode _mode;
  late HMSPollCategory _pollCategory;
  late String _pollId;
  late String _questionId;
  late List<HMSPollQuestion> _questions;
  late List<String>? _rolesThatCanViewResponses;
  late List<String>? _rolesThatCanVote;
  late String _title;

  set withAnonymous(bool anonymous) {
    _anonymous = anonymous;
  }

  set withDuration(Duration duration) {
    _duration = duration;
  }

  set withUserTrackingMode(HMSPollUserTrackingMode mode) {
    _mode = mode;
  }

  set withCategory(HMSPollCategory pollCategory) {
    _pollCategory = pollCategory;
  }

  set withPollId(String pollId) {
    _pollId = pollId;
  }

  set withRolesThatCanViewResponses(List<String> rolesThatCanViewResponses) {
    _rolesThatCanViewResponses = rolesThatCanViewResponses;
  }

  set withRolesThatCanVote(List<String> rolesThatCanVote) {
    _rolesThatCanVote = rolesThatCanVote;
  }

  set withTitle(String title) {
    _title = title;
  }

  Map<String, dynamic> toMap() {
    return {
      'anonymous': _anonymous,

      ///TODO: Complete duration mapping
      ///Check duration type
      'duration': _duration.inMilliseconds,

      'mode':
          HMSPollUserTrackingModeValues.getStringFromHMSPollUserTrackingMode(
              _mode),
      'poll_category':
          HMSPollCategoryValues.getStringFromHMSPollCategory(_pollCategory),
      'poll_id': _pollId,
      'questions': _questions.map((e) => e.toMap()).toList(),
      'roles_that_can_view_responses': _rolesThatCanViewResponses,
      'roles_that_can_vote': _rolesThatCanVote,
      'title': _title
    };
  }
}
