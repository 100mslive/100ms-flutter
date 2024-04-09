//
//  HMSPollLeaderboardResponseExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 20/02/24.
//

import Foundation
import HMSSDK

class HMSPollLeaderboardResponseExtension {

    static func toDictionary(pollLeaderboardResponse: HMSPollLeaderboardResponse?) -> [String: Any?]? {

        if let pollLeaderboardResponse {

            var map = [String: Any?]()
            var entryMap = [[String: Any?]]()

            for entry in pollLeaderboardResponse.entries {
                entryMap.append(HMSPollLeaderboardEntryExtension.toDictionary(hmsPollLeaderboardEntry: entry))
            }

            map["entries"] = entryMap
            map["has_next"] = pollLeaderboardResponse.hasNext
            map["summary"] = HMSPollLeaderboardSummaryExtension.toDictionary(hmsPollLeaderboardSummary: pollLeaderboardResponse.summary)

            return map
        } else {
            return nil
        }
    }

}
