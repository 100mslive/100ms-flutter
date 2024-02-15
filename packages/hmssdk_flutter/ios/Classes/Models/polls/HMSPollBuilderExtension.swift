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
        }

        if let text = pollQuestion["text"] as? String {
            pollQuestionBuilder.withTitle(text)
        }

        if let duration = pollQuestion["duration"] as? Int {
            pollQuestionBuilder.withDuration(duration)
        }

        if let weight = pollQuestion["weight"] as? Int {
            pollQuestionBuilder.withWeight(weight: weight)
        }

        if let answerHidden = pollQuestion["answer_hidden"] as? Bool {
            pollQuestionBuilder.withAnswerHidden(answerHidden: answerHidden)
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
        }

        if let options = pollQuestion["options"] as? [[String: Any?]] {
            options.forEach { option in
                if let key = option["text"] as? String, let value = option["is_correct"] as? Bool{
                    pollQuestionBuilder.addQuizOption(with: key, isCorrect: value)
                }
            }
        }

        if let canChangeResponse = pollQuestion["can_change_response"] as? Bool{
            pollQuestionBuilder.withCanChangeResponse(canChangeResponse: canChangeResponse)
        }

        return pollQuestionBuilder
    }

    
}
