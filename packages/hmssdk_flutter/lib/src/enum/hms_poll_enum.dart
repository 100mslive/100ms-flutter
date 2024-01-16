enum HMSPollUserTrackingMode{
  user_id,
  peer_id,
  username
}

extension HMSPollUserTrackingModeValues on HMSPollUserTrackingMode{

    static HMSPollUserTrackingMode getHMSPollUserTrackingModeFromString(String pollTrackingMode){
      switch(pollTrackingMode){
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

    static String getStringFromHMSPollUserTrackingMode(HMSPollUserTrackingMode hmsPollUserTrackingMode){
      switch(hmsPollUserTrackingMode){
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

enum HMSPollCategory{
  poll,
  quiz
}

extension HMSPollCategoryValues on HMSPollCategory{

  static HMSPollCategory getHMSPollCategoryFromString(String pollCategory){
    switch(pollCategory){
      case "poll":
        return HMSPollCategory.poll;
      case "quiz":
        return HMSPollCategory.quiz;
      default:
        return HMSPollCategory.poll;
    }
  }

  static String getStringFromHMSPollCategory(HMSPollCategory hmsPollCategory){
    switch(hmsPollCategory){
      case HMSPollCategory.poll:
        return "poll";
      case HMSPollCategory.quiz:
        return "quiz";
      default:
        return "poll";
    }
  }
}