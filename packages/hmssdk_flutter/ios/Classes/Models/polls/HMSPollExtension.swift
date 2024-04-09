//
//  File.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 18/01/24.
//

import Foundation
import HMSSDK

class HMSPollExtension {

    static func toDictionary(poll: HMSPoll) -> [String: Any?] {
        var map = [String: Any?]()

        map["anonymous"] = poll.anonymous
        map["category"] = getPollCategory(pollCategory: poll.category)

        if let createdBy = poll.createdBy {
            map["created_by"] = HMSPeerExtension.toDictionary(createdBy)
        }

        map["duration"] = poll.duration

        if let mode = poll.mode {
            map["mode"] = getPollUserTrackingMode(mode: mode)
        }

        map["poll_id"] = poll.pollID
        map["question_count"] = poll.questionCount

        let questions = poll.questions?.map { HMSPollQuestionExtension.toDictionary(question: $0) }
        map["questions"] = questions

        if let result = poll.result {
            map["result"] = HMSPollResultExtension.toDictionary(pollResult: result)
        }

        let rolesThatCanViewResponses = poll.rolesThatCanViewResponses.map { HMSRoleExtension.toDictionary($0) }
        map["roles_that_can_view_responses"] = rolesThatCanViewResponses

        let rolesThatCanVote = poll.rolesThatCanVote.map { HMSRoleExtension.toDictionary($0) }
        map["roles_that_can_vote"] = rolesThatCanVote

        if let startedAt = poll.startedAt {
            map["started_at"] = Int(startedAt.timeIntervalSince1970 * 1000)
        }

        if let startedBy = poll.startedBy {
            map["started_by"] = HMSPeerExtension.toDictionary(startedBy)
        }

        map["state"] = getPollState(state: poll.state)

        if let stoppedAt = poll.stoppedAt {
            map["stopped_at"] = Int(stoppedAt.timeIntervalSince1970 * 1000)
        }

        map["title"] = poll.title

        return map
    }

    private static func getPollCategory(pollCategory: HMSPollCategory) -> String? {
        switch pollCategory {
        case .poll:
            return "poll"
        case .quiz:
            return "quiz"
        default:
            return nil
        }
    }

    private static func getPollUserTrackingMode(mode: HMSPollUserTrackingMode) -> String? {
        switch mode {
        case .customerUserID:
            return "user_id"
        case .peerID:
            return "peer_id"
        case .userName:
            return "username"
        default:
            return nil
        }
    }

    private static func getPollState(state: HMSPollState) -> String? {
        switch state {
        case .created:
            return "created"
        case .started:
            return "started"
        case .stopped:
            return "stopped"
        default:
            return nil
        }
    }

    static func getPollUpdateType(updateType: HMSPollUpdateType) -> String? {
        switch updateType {
        case .started:
            return "started"
        case .stopped:
            return "stopped"
        case .resultsUpdated:
            return "results_updated"
        default:
            return nil
        }
    }
}
