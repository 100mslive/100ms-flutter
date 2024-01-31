//
//  HMSPollAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 19/01/24.
//

import Foundation
import HMSSDK

class HMSPollAction{
    
    static func pollActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        switch call.method{
        case "quick_start_poll":
            quickStartPoll(call, result, hmsSDK)
            break
        case "add_single_choice_poll_response":
            addSingleChoicePollResponse(call, result, hmsSDK)
            break
        case "add_multi_choice_poll_response":
            addMultiChoicePollResponse(call, result, hmsSDK)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func quickStartPoll(_ call: FlutterMethodCall,_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        
        let arguments = call.arguments as? [AnyHashable: Any]
        
        guard let pollBuilderMap = arguments?["poll_builder"] as? [String:Any?] else{
            result(HMSErrorExtension.getError("No pollBuilder found in \(#function)"))
            return
        }
        
        if let hmsSDK{
            guard let pollBuilder = HMSPollBuilderExtension.toHMSPollBuilder(pollBuilderMap, hmsSDK)
            else{
                HMSErrorLogger.returnArgumentsError("pollBuilder parsing failed")
                return
            }
            
            hmsSDK.interactivityCenter.quickStartPoll(with: (pollBuilder), completion: {_ , error in
                if let error = error {
                    result(HMSErrorExtension.toDictionary(error))
                } else {
                    result(nil)
                }})
        } else{
            result(HMSErrorExtension.getError("hmsSDK is nil in \(#function)"))
            return
        }
        
    }
    
    
    static private func addSingleChoicePollResponse(_ call: FlutterMethodCall,_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        
        let arguments = call.arguments as? [AnyHashable: Any]
        
        guard let pollId = arguments?["poll_id"] as? String,
              let index = arguments?["question_index"] as? Int,
              let answer = arguments?["answer"] as? [String:Any?]
        else {
            HMSErrorLogger.returnArgumentsError("Invalid arguments")
            return
        }
        
        if let optionIndex = answer["index"] as? Int {
            
            hmsSDK?.interactivityCenter.fetchPollList(state: .started){ polls,error in
                
                if let error = error{
                    result(HMSErrorExtension.toDictionary(error))
                }else{
                    if let poll = polls?.first(where: {$0.pollID == pollId}){
                        
                        hmsSDK?.interactivityCenter.fetchPollQuestions(poll: poll){ pollWithQuestions, error in
                                
                            if let error = error{
                                result(HMSErrorExtension.toDictionary(error))
                            }else{
                                if let question = pollWithQuestions?.questions?[index]{
                                    
                                    if let optionSelected = question.options?[optionIndex - 1]{
                                        let response = HMSPollResponseBuilder(poll: poll)
                                        response.addResponse(for: question, options: [optionSelected])
                                        hmsSDK?.interactivityCenter.add(response: response){ pollResult, error in
                                            
                                            if let error = error{
                                                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                                            }else{
                                                var pollResults = [[String: Any?]]()
                                                
                                                pollResult?.forEach{
                                                    pollResults.append(HMSPollAnswerResponseExtension.toDictionary(pollAnswerResponse: $0))
                                                }
                                                var map = [String:Any?]()
                                                map["result"] = pollResults
                                                result(HMSResultExtension.toDictionary(true, map))
                                            }
                                        }
                                    }else{
                                        HMSErrorLogger.returnArgumentsError("No option found at given index")
                                    }
                                    
                                }else{
                                    HMSErrorLogger.returnArgumentsError("No question found at given index")
                                }
                            }
                            
                        }
                        
                    }else{
                        HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
                        return
                    }
                }
            }
            
            
        } else {
            HMSErrorLogger.returnArgumentsError("Invalid option index")
            return
        }
    }
    
    
    static private func addMultiChoicePollResponse(_ call: FlutterMethodCall,_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?){
        
        let arguments = call.arguments as? [AnyHashable: Any]
        
        guard let pollId = arguments?["poll_id"] as? String,
              let index = arguments?["question_index"] as? Int,
              let answer = arguments?["answer"] as? [[String:Any?]]
        else {
            HMSErrorLogger.returnArgumentsError("Invalid arguments")
            return
        }
                    
        hmsSDK?.interactivityCenter.fetchPollList(state: .started){ polls,error in
            
            if let error = error{
                result(HMSErrorExtension.toDictionary(error))
            }else{
                if let poll = polls?.first(where: {$0.pollID == pollId}){
                    
                    hmsSDK?.interactivityCenter.fetchPollQuestions(poll: poll){ pollWithQuestions, error in
                            
                        if let error = error{
                            result(HMSErrorExtension.toDictionary(error))
                        }else{
                            if let question = pollWithQuestions?.questions?[index]{
                                
                                var selectedOptions = [HMSPollQuestionOption]()
                                answer.forEach{
                                    if let optionIndex = $0["index"] as? Int{
                                        if let option = question.options?[optionIndex - 1] as? HMSPollQuestionOption{
                                            selectedOptions.append(option)
                                        }else{
                                            HMSErrorLogger.returnArgumentsError("Invalid option index")
                                            return
                                        }
                                    }else{
                                        HMSErrorLogger.returnArgumentsError("Invalid index")
                                        return
                                    }
                                }
                                let response = HMSPollResponseBuilder(poll: poll)
                                response.addResponse(for: question, options: selectedOptions)
                                hmsSDK?.interactivityCenter.add(response: response){ pollResult, error in
                                    
                                    if let error = error{
                                        result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                                    }else{
                                        var pollResults = [[String: Any?]]()
                                        
                                        pollResult?.forEach{
                                            pollResults.append(HMSPollAnswerResponseExtension.toDictionary(pollAnswerResponse: $0))
                                        }
                                        var map = [String:Any?]()
                                        map["result"] = pollResults
                                        result(HMSResultExtension.toDictionary(true, map))
                                    }
                                }
                            }else{
                                HMSErrorLogger.returnArgumentsError("No question found at given index")
                                return
                            }
                        }
                        
                    }
                    
                }else{
                    HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
                    return
                }
            }
        }
    }
}
