//
//  HMSPollBuilderExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 23/01/24.
//

import Foundation
import HMSSDK

class HMSPollBuilderExtension{
    
    static func toHMSPollBuilder(_ pollBuilderMap:[String:Any?]?, _ hmssdk:HMSSDK) -> HMSPollBuilder?{
        
        guard let pollBuilderMap = pollBuilderMap else{
            return nil
        }
        
        let pollBuilder = HMSPollBuilder()
        
        if let anonymous = pollBuilderMap["anonymous"] as? Bool{
            pollBuilder.withAnonymous(anonymous)
        }
        
        if let duration = pollBuilderMap["duration"] as? Int {
            pollBuilder.withDuration(duration)
        }

        if let mode = pollBuilderMap["mode"] as? String {
            pollBuilder.withUserTrackingMode(getPollUserTrackingModeFromString(mode))
        }
        
        if let pollCategory = pollBuilderMap["poll_category"] as? String {
            pollBuilder.withCategory(getPollCategoryFromString(pollCategory))
        }

        if let pollId = pollBuilderMap["poll_id"] as? String {
            pollBuilder.withPollID(pollId)
        }
        
        let availableRoles = hmssdk.roles
        if let rolesThatCanViewResponses = pollBuilderMap["roles_that_can_view_responses"] as? [String] {
            let roles = rolesThatCanViewResponses.compactMap { roleName in
                availableRoles.first { $0.name == roleName }
            }
            pollBuilder.withRolesThatCanViewResponses(roles)
        }

        if let rolesThatCanVote = pollBuilderMap["roles_that_can_vote"] as? [String] {
            let roles = rolesThatCanVote.compactMap { roleName in
                availableRoles.first { $0.name == roleName }
            }
            pollBuilder.withRolesThatCanVote(roles)
        }

        if let title = pollBuilderMap["title"] as? String {
            pollBuilder.withTitle(title)
        }
        
        if let questions = pollBuilderMap["questions"] as? [[String: Any?]]{
            
            questions.forEach{
                if let questionBuilder = getPollQuestionBuilder($0){
                    pollBuilder.addQuestion(with: questionBuilder)
                }
            }
            
        }
        return pollBuilder
    }
    
    private static func getPollCategoryFromString(_ pollCategory:String) -> HMSPollCategory{
        
        switch pollCategory{
        case "poll":
            return .poll
        case "quiz":
            return .quiz
        default:
            return .poll
        }
    }
    
    private static func getPollUserTrackingModeFromString(_ pollUserTrackingMode: String) -> HMSPollUserTrackingMode {
        switch pollUserTrackingMode {
        case "user_id":
            return .customerUserID
        case "peer_id":
            return .peerID
        case "username":
            return .userName
        default:
            return .customerUserID
        }
    }

    private static func getPollQuestionTypeFromString(_ pollQuestionType: String) -> HMSPollQuestionType {
        switch pollQuestionType {
        case "multi_choice":
            return .multipleChoice
        case "short_answer":
            return .shortAnswer
        case "long_answer":
            return .longAnswer
        case "single_choice":
            return .singleChoice
        default:
            return .singleChoice
        }
    }
    
    private static func getPollQuestionBuilder(_ pollQuestion: [String: Any?]?) -> HMSPollQuestionBuilder? {
        guard let pollQuestion = pollQuestion else {
            return nil
        }

        let pollQuestionBuilder = HMSPollQuestionBuilder()

        if let typeString = pollQuestion["type"] as? String{
            let type = getPollQuestionTypeFromString(typeString)
            pollQuestionBuilder.withType(type)
        } else {
            HMSErrorLogger.returnArgumentsError("type should not be null")
            return nil
        }


        if let canSkip = pollQuestion["can_skip"] as? Bool {
            pollQuestionBuilder.withCanBeSkipped(canSkip)
        } else {
            HMSErrorLogger.returnArgumentsError("canSkip should not be null")
        }

        if let text = pollQuestion["text"] as? String {
            pollQuestionBuilder.withTitle(text)
        } else {
            HMSErrorLogger.returnArgumentsError("text should not be null")
        }

        if let duration = pollQuestion["duration"] as? Int {
            pollQuestionBuilder.withDuration(duration)
        } else {
            HMSErrorLogger.returnArgumentsError("duration should not be null")
        }

        if let weight = pollQuestion["weight"] as? Int {
            pollQuestionBuilder.withWeight(weight: weight)
        } else {
            HMSErrorLogger.returnArgumentsError("weight should not be null")
        }

        if let answerHidden = pollQuestion["answer_hidden"] as? Bool {
            pollQuestionBuilder.withAnswerHidden(answerHidden: answerHidden)
        } else {
            HMSErrorLogger.returnArgumentsError("answerHidden should not be null")
        }

        if let maxLength = pollQuestion["max_length"] as? Int {
            pollQuestionBuilder.withMaxLength(maxLength: maxLength)
        }

        if let minLength = pollQuestion["min_length"] as? Int {
            pollQuestionBuilder.withMinLength(minLength: minLength)
        }

        if let pollOptions = pollQuestion["poll_options"] as? [String] {
            pollOptions.forEach { option in
                pollQuestionBuilder.addOption(with: option)
            }
        } else {
            HMSErrorLogger.returnArgumentsError("pollOptions should not be null")
        }

        if let options = pollQuestion["options"] as? [[String: Bool]] {
            options.forEach { option in
                if let key = option.keys.first, let value = option.values.first {
                    pollQuestionBuilder.addQuizOption(with: key, isCorrect: value)
                }
            }
        } else {
            HMSErrorLogger.returnArgumentsError("options should not be null")
        }

        if let canChangeResponse = pollQuestion["can_change_response"] as? Bool{
            pollQuestionBuilder.withCanChangeResponse(canChangeResponse: canChangeResponse)
        } else {
            HMSErrorLogger.returnArgumentsError("canChangeResponse should not be null")
            return nil
        }

        return pollQuestionBuilder
    }

    
}
