//
//  HMSPollLeaderboardSummaryExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 20/02/24.
//

import Foundation
import HMSSDK

class HMSPollLeaderboardSummaryExtension {

    static func toDictionary(hmsPollLeaderboardSummary: HMSPollLeaderboardSummary?) -> [String: Any?]? {

        if let hmsPollLeaderboardSummary {

            var map = [String: Any?]()

            map["average_score"] = hmsPollLeaderboardSummary.averageScore
            map["average_time"] = hmsPollLeaderboardSummary.averageTime
            map["responded_peers_count"] = hmsPollLeaderboardSummary.respondedPeersCount
            map["responded_correctly_peers_count"] = hmsPollLeaderboardSummary.respondedCorrectlyPeersCount
            map["total_peers_count"] = hmsPollLeaderboardSummary.totalPeersCount

            return map

        } else {
            return nil
        }

    }

}
