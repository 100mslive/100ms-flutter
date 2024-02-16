import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_answer_response.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

abstract class HMSPollInteractivityCenter {
  ///[addPollUpdateListener] adds the poll update listener to send
  ///the poll events to the application
  ///**Parameters**:
  ///
  ///**listener** - [listener]
  static void addPollUpdateListener({required HMSPollListener listener}) {
    PlatformService.addPollUpdateListener(listener);
  }

  ///[removePollUpdateListener] removes the poll update listener
  ///Thus the application no longer receives poll events
  static void removePollUpdateListener() {
    PlatformService.removePollUpdateListener();
  }

  ///[quickStartPoll] starts a quick poll with supplied arguments
  ///
  ///**Parameters**:
  ///
  ///**pollBuilder** - [pollBuilder] is an object of HMSPollBuilder containing the poll configurations
  ///
  ///**hmsActionResultListener** - [hmsActionResultListener] is a callback whose [HMSActionResultListener.onSuccess] will be called when the action completes successfully.
  ///
  ///**Returns**
  ///
  /// Future<dynamic> - A Future representing the asynchronous operation. It will return either null if the operation is successful, or an [HMSException] if an error occurs.
  ///
  ///Refer [Quick Start Poll](Add docs link here)
  static void quickStartPoll({required HMSPollBuilder pollBuilder}) async {
    PlatformService.invokeMethod(PlatformMethod.quickStartPoll,
        arguments: {"poll_builder": pollBuilder.toMap()});
  }

  ///[addSingleChoicePollResponse] method is used to answer a single choice poll
  ///
  ///**Parameters**
  ///
  ///**hmsPoll** - [hmsPoll] object for the poll that is being answered
  ///
  ///**pollQuestion** - [pollQuestion] object for the question that is being answered
  ///
  ///**optionSelected** - [optionSelected] object for the option that is selected
  ///
  ///**peer** - [peer] who is answering the poll
  ///
  ///**Returns**
  ///
  /// Future<dynamic> - A Future representing the asynchronous operation. It will return either null if the operation is successful, or an [HMSException] if an error occurs.
  ///
  ///Refer [addSingleChoicePollResponse](Add docs link here)
  static Future<dynamic> addSingleChoicePollResponse(
      {required HMSPoll hmsPoll,
      required HMSPollQuestion pollQuestion,
      required HMSPollQuestionOption optionSelected,
      HMSPeer? peer}) async {
    int questionIndex =
        hmsPoll.questions?.indexWhere((element) => element == pollQuestion) ??
            -1;
    if (questionIndex == -1) {
      return HMSException(
          message: "Question not found",
          description:
              "Question passed above does not match any question in the poll",
          action: "Please pass correct question",
          isTerminal: false);
    }
    var result = await PlatformService.invokeMethod(
        PlatformMethod.addSingleChoicePollResponse,
        arguments: {
          "poll_id": hmsPoll.pollId,
          "question_index": questionIndex,
          "user_id": peer?.customerUserId,
          "answer": optionSelected.toMap()
        });

    if (result != null) {
      if (result["success"]) {
        if (result["data"]["result"] != null) {
          var data = result["data"]["result"];
          List<HMSPollAnswerResponse> pollResponses = [];
          data.forEach((response) {
            if (response != null) {
              pollResponses.add(HMSPollAnswerResponse.fromMap(response));
            }
          });
          return pollResponses;
        }
      } else {
        if (result["data"]["error"] != null) {
          return HMSException.fromMap(result["data"]["error"]);
        }
      }
    }
  }

  /// [stopPoll] method is used to stop a poll.
  ///
  ///**Parameters**
  ///
  ///**poll** - [poll] object representing the poll to be stopped.
  ///
  ///**Returns**
  ///
  ///Future<dynamic> - A Future representing the asynchronous operation. It will return either null if the operation is successful, or an [HMSException] if an error occurs.
  ///
  ///Refer [stopPoll](Add docs link here)
  static Future<dynamic> stopPoll({required HMSPoll poll}) async {
    var result = await PlatformService.invokeMethod(PlatformMethod.stopPoll,
        arguments: {"poll_id": poll.pollId});

    if (result != null) {
      if (result["error"] != null) {
        return HMSException.fromMap(result["error"]);
      } else {
        return null;
      }
    }
  }

  ///[addMultiChoicePollResponse] method is used to answer a single choice poll
  ///
  ///**Parameters**
  ///
  ///**hmsPoll** - [hmsPoll] object for the poll that is being answered
  ///
  ///**pollQuestion** - [pollQuestion] object for the question that is being answered
  ///
  ///**optionsSelected** - [optionsSelected] list containing objects for the options selected
  ///
  ///**peer** - [peer] who is answering the poll
  ///
  ///Refer [addSingleChoicePollResponse](Add docs link here)
  static Future<dynamic> addMultiChoicePollResponse(
      {required HMSPoll hmsPoll,
      required HMSPollQuestion pollQuestion,
      required List<HMSPollQuestionOption> optionsSelected,
      HMSPeer? peer}) async {
    int questionIndex =
        hmsPoll.questions?.indexWhere((element) => element == pollQuestion) ??
            -1;
    if (questionIndex == -1) {
      HMSException(
          message: "Question not found",
          description:
              "Question passed above does not match any question in the poll",
          action: "Please pass correct question",
          isTerminal: false);
      return;
    }
    var optionsSelectedMap = optionsSelected.map((e) => e.toMap()).toList();
    var result = await PlatformService.invokeMethod(
        PlatformMethod.addMultiChoicePollResponse,
        arguments: {
          "poll_id": hmsPoll.pollId,
          "question_index": questionIndex,
          "user_id": peer?.customerUserId,
          "answer": optionsSelectedMap
        });

    if (result != null) {
      if (result["success"]) {
        if (result["data"]["result"] != null) {
          var data = result["data"]["result"];
          List<HMSPollAnswerResponse> pollResponses = [];
          data.forEach((response) {
            if (response != null) {
              pollResponses.add(HMSPollAnswerResponse.fromMap(response));
            }
          });
          return pollResponses;
        }
      } else {
        if (result["data"]["error"] != null) {
          return HMSException.fromMap(result["data"]["error"]);
        }
      }
    }
  }
}

///[HMSPollBuilder] is used to create polls
///It contains getters and setters for poll builder properties
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
    _rolesThatCanViewResponse = rolesThatCanViewResponses;
  }

  set withRolesThatCanVote(List<HMSRole> rolesThatCanVote) {
    if (_rolesThatCanVote == null) {
      _rolesThatCanVote = [];
    }
    _rolesThatCanVote = rolesThatCanVote;
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
