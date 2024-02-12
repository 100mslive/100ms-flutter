///[HMSPollUserTrackingMode] is the mode based on which the app identifies the user
enum HMSPollUserTrackingMode { user_id, peer_id, username }

extension HMSPollUserTrackingModeValues on HMSPollUserTrackingMode {
  static HMSPollUserTrackingMode getHMSPollUserTrackingModeFromString(
      String pollTrackingMode) {
    switch (pollTrackingMode) {
      case "user_id":
        return HMSPollUserTrackingMode.user_id;
      case "peer_id":
        return HMSPollUserTrackingMode.peer_id;
      case "username":
        return HMSPollUserTrackingMode.username;
      default:
        return HMSPollUserTrackingMode.user_id;
    }
  }

  static String getStringFromHMSPollUserTrackingMode(
      HMSPollUserTrackingMode hmsPollUserTrackingMode) {
    switch (hmsPollUserTrackingMode) {
      case HMSPollUserTrackingMode.user_id:
        return "user_id";
      case HMSPollUserTrackingMode.peer_id:
        return "peer_id";
      case HMSPollUserTrackingMode.username:
        return "username";
      default:
        return "user_id";
    }
  }
}

///The [HMSPollCategory] enum categorizes whether a poll or quiz is being represented.
enum HMSPollCategory { poll, quiz }

extension HMSPollCategoryValues on HMSPollCategory {
  static HMSPollCategory getHMSPollCategoryFromString(String pollCategory) {
    switch (pollCategory) {
      case "poll":
        return HMSPollCategory.poll;
      case "quiz":
        return HMSPollCategory.quiz;
      default:
        return HMSPollCategory.poll;
    }
  }

  static String getStringFromHMSPollCategory(HMSPollCategory hmsPollCategory) {
    switch (hmsPollCategory) {
      case HMSPollCategory.poll:
        return "poll";
      case HMSPollCategory.quiz:
        return "quiz";
      default:
        return "poll";
    }
  }
}

///[HMSPollQuestionType] enum categorizes the type of question
enum HMSPollQuestionType { singleChoice, multiChoice, shortAnswer, longAnswer }

extension HMSPollQuestionTypeValues on HMSPollQuestionType {
  static HMSPollQuestionType getHMSPollQuestionTypeFromString(
      String pollQuestionType) {
    switch (pollQuestionType) {
      case "single_choice":
        return HMSPollQuestionType.singleChoice;
      case "multi_choice":
        return HMSPollQuestionType.multiChoice;
      case "short_answer":
        return HMSPollQuestionType.shortAnswer;
      case "long_answer":
        return HMSPollQuestionType.longAnswer;
      default:
        return HMSPollQuestionType.singleChoice;
    }
  }

  static String getStringFromHMSPollQuestionType(
      HMSPollQuestionType hmsPollQuestionType) {
    switch (hmsPollQuestionType) {
      case HMSPollQuestionType.singleChoice:
        return "single_choice";
      case HMSPollQuestionType.multiChoice:
        return "multi_choice";
      case HMSPollQuestionType.shortAnswer:
        return "short_answer";
      case HMSPollQuestionType.longAnswer:
        return "long_answer";
      default:
        return "single_choice";
    }
  }
}

///[HMSPollState] enum represents the different states a poll can be in.
enum HMSPollState { started, stopped, created }

extension HMSPollStateValues on HMSPollState {
  static HMSPollState getHMSPollStateFromString(String pollState) {
    switch (pollState) {
      case "started":
        return HMSPollState.started;
      case "stopped":
        return HMSPollState.stopped;
      case "created":
        return HMSPollState.created;
      default:
        return HMSPollState.created;
    }
  }

  static String getStringFromHMSPollState(HMSPollState hmsPollState) {
    switch (hmsPollState) {
      case HMSPollState.started:
        return "started";
      case HMSPollState.stopped:
        return "stopped";
      case HMSPollState.created:
        return "created";
      default:
        return "created";
    }
  }
}

///[HMSPollUpdateType] enum represents different types of updates that can occur in a poll.
enum HMSPollUpdateType { started, stopped, resultsupdated }

extension HMSPollUpdateTypeValues on HMSPollUpdateType {
  static HMSPollUpdateType getHMSPollUpdateTypeFromString(
      String pollUpdateType) {
    switch (pollUpdateType) {
      case "started":
        return HMSPollUpdateType.started;
      case "stopped":
        return HMSPollUpdateType.stopped;
      case "results_updated":
        return HMSPollUpdateType.resultsupdated;
      default:
        return HMSPollUpdateType.resultsupdated;
    }
  }
}

///[HMSPollListenerMethod] contains the [HMSPollListener] methods
enum HMSPollListenerMethod { onPollUpdate, unknown }

extension HMSPollListenerMethodValues on HMSPollListenerMethod {
  static HMSPollListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_poll_update':
        return HMSPollListenerMethod.onPollUpdate;
      default:
        return HMSPollListenerMethod.unknown;
    }
  }
}
