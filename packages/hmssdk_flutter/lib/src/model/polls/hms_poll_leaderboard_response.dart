import 'package:hmssdk_flutter/src/model/polls/hms_poll_leaderboard_entry.dart';
import 'package:hmssdk_flutter/src/model/polls/hms_poll_leaderboard_summary.dart';

class HMSPollLeaderboardResponse {
  final List<HMSPollLeaderboardEntry>? entries;
  final bool? hasNext;
  final HMSPollLeaderboardSummary? summary;

  HMSPollLeaderboardResponse(
      {required this.entries, required this.hasNext, required this.summary});

  factory HMSPollLeaderboardResponse.fromMap(Map map) {
    List<HMSPollLeaderboardEntry> peerEntryList = [];
    if (map["entries"] != null) {
      map["entries"].forEach((entry) {
        peerEntryList.add(HMSPollLeaderboardEntry.fromMap(entry));
      });
    }
    return HMSPollLeaderboardResponse(
        entries: map["entries"] == null ? null : peerEntryList,
        hasNext: map["has_next"],
        summary: map["summary"] == null
            ? null
            : HMSPollLeaderboardSummary.fromMap(map["summary"]));
  }
}
