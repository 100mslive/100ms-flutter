//
//  HMSPollLeaderboardEntryExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 20/02/24.
//

import Foundation
import HMSSDK

class HMSPollLeaderboardEntryExtension {

    static func toDictionary(hmsPollLeaderboardEntry: HMSPollLeaderboardEntry) -> [String: Any?] {

        var map = [String: Any?]()

        map["correct_responses"] = hmsPollLeaderboardEntry.correctResponses
        map["duration"] = hmsPollLeaderboardEntry.duration
        map["position"] = hmsPollLeaderboardEntry.position
        map["score"] = hmsPollLeaderboardEntry.score
        map["total_responses"] = hmsPollLeaderboardEntry.totalResponses
        map["peer"] = HMSPollResponsePeerInfoExtension.toDictionary(hmsPollResponsePeerInfo: hmsPollLeaderboardEntry.peer)

        return map
    }
}
