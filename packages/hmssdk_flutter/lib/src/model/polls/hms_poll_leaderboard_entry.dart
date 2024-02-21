import 'package:hmssdk_flutter/src/model/polls/hms_poll_peer_info_response.dart';

class HMSPollLeaderboardEntry {
  final int? correctResponses;
  final Duration? duration;
  final int? position;
  final int? score;
  final int? totalResponses;
  final HMSPollResponsePeerInfo? peer;

  HMSPollLeaderboardEntry(
      {required this.correctResponses,
      required this.duration,
      required this.position,
      required this.score,
      required this.totalResponses,
      required this.peer});

  factory HMSPollLeaderboardEntry.fromMap(Map map) {
    return HMSPollLeaderboardEntry(
        correctResponses: map["correct_responses"],
        duration: map["duration"] == null
            ? null
            : Duration(milliseconds: map["duration"].toInt()),
        position: map["position"],
        score: map["score"],
        totalResponses: map["total_responses"],
        peer: map["peer"] == null
            ? null
            : HMSPollResponsePeerInfo.fromMap(map["peer"]));
  }
}
