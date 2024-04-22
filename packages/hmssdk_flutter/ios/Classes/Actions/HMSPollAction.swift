//
//  HMSPollAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 19/01/24.
//

import Foundation
import HMSSDK

class HMSPollAction {

    static func pollActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ polls: [HMSPoll]?) {
        switch call.method {
        case "quick_start_poll":
            quickStartPoll(call, result, hmsSDK)
            break
        case "add_single_choice_poll_response":
            addSingleChoicePollResponse(call, result, hmsSDK, polls)
            break
        case "add_multi_choice_poll_response":
            addMultiChoicePollResponse(call, result, hmsSDK, polls)
            break
        case "stop_poll":
            stopPoll(call, result, hmsSDK, polls)
        case "fetch_leaderboard":
            fetchLeaderboard(call, result, hmsSDK, polls)
        case "fetch_poll_list":
            fetchPollList(call, result, hmsSDK)
        case "fetch_poll_questions":
            fetchPollQuestions(call, result, hmsSDK)
        case "get_poll_results":
            getPollResults(call, result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func quickStartPoll(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let pollBuilderMap = arguments?["poll_builder"] as? [String: Any?] else {
            result(HMSErrorExtension.getError("No pollBuilder found in \(#function)"))
            return
        }

        if let hmsSDK {
            guard let pollBuilder = HMSPollBuilderExtension.toHMSPollBuilder(pollBuilderMap, hmsSDK)
            else {
                HMSErrorLogger.returnArgumentsError("pollBuilder parsing failed")
                return
            }

            hmsSDK.interactivityCenter.quickStartPoll(with: (pollBuilder), completion: {_, error in
                if let error = error {
                    result(HMSErrorExtension.toDictionary(error))
                } else {
                    result(nil)
                }})
        } else {
            result(HMSErrorExtension.getError("hmsSDK is nil in \(#function)"))
            return
        }

    }

    static private func addSingleChoicePollResponse(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ currentPolls: [HMSPoll]?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let pollId = arguments?["poll_id"] as? String,
              let index = arguments?["question_index"] as? Int,
              let answer = arguments?["answer"] as? [String: Any?]
        else {
            HMSErrorLogger.returnArgumentsError("Invalid arguments")
            return
        }

        let timeTakenToAnswer = arguments?["time_taken_to_answer"] as? Int

        if let optionIndex = answer["index"] as? Int {

            if let poll = currentPolls?.first(where: {$0.pollID == pollId}) {

                if let question = poll.questions?[index] {

                    if let optionSelected = question.options?[optionIndex - 1] {
                        let response = HMSPollResponseBuilder(poll: poll)
                        response.addResponse(for: question, options: [optionSelected], duration: timeTakenToAnswer)
                        hmsSDK?.interactivityCenter.add(response: response) { pollResult, error in

                            if let error = error {
                                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                            } else {
                                var pollResults = [[String: Any?]]()

                                pollResult?.forEach {
                                    pollResults.append(HMSPollAnswerResponseExtension.toDictionary(pollAnswerResponse: $0))
                                }
                                var map = [String: Any?]()
                                map["result"] = pollResults
                                result(HMSResultExtension.toDictionary(true, map))
                            }
                        }
                    } else {
                        HMSErrorLogger.returnArgumentsError("No option found at given index")
                    }

                } else {
                    HMSErrorLogger.returnArgumentsError("No question found at given index")
                }

            } else {
                HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
                return
            }
        } else {
            HMSErrorLogger.returnArgumentsError("Invalid option index")
            return
        }
    }

    static private func addMultiChoicePollResponse(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ currentPolls: [HMSPoll]?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let pollId = arguments?["poll_id"] as? String,
              let index = arguments?["question_index"] as? Int,
              let answer = arguments?["answer"] as? [[String: Any?]]
        else {
            HMSErrorLogger.returnArgumentsError("Invalid arguments")
            return
        }

        let timeTakenToAnswer = arguments?["time_taken_to_answer"] as? Int

        if let poll = currentPolls?.first(where: {$0.pollID == pollId}) {

            if let question = poll.questions?[index] {
                var selectedOptions = [HMSPollQuestionOption]()
                answer.forEach {
                    if let optionIndex = $0["index"] as? Int {
                        if let option = question.options?[optionIndex - 1] as? HMSPollQuestionOption {
                            selectedOptions.append(option)
                        } else {
                            HMSErrorLogger.returnArgumentsError("Invalid option index")
                            return
                        }
                    } else {
                        HMSErrorLogger.returnArgumentsError("Invalid index")
                        return
                    }
                }
                let response = HMSPollResponseBuilder(poll: poll)
                response.addResponse(for: question, options: selectedOptions, duration: timeTakenToAnswer)
                hmsSDK?.interactivityCenter.add(response: response) { pollResult, error in

                    if let error = error {
                        result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                    } else {
                        var pollResults = [[String: Any?]]()

                        pollResult?.forEach {
                            pollResults.append(HMSPollAnswerResponseExtension.toDictionary(pollAnswerResponse: $0))
                        }
                        var map = [String: Any?]()
                        map["result"] = pollResults
                        result(HMSResultExtension.toDictionary(true, map))
                    }
                }
            } else {
                HMSErrorLogger.returnArgumentsError("No question found at given index")
                return
            }
        } else {
            HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
            return
        }
    }

    static private func stopPoll(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ currentPolls: [HMSPoll]?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let pollId = arguments?["poll_id"] as? String
        else {
            HMSErrorLogger.returnArgumentsError("pollId can't be null")
            return
        }

        if let poll = currentPolls?.first(where: {
            $0.pollID == pollId
        }) {
            hmsSDK?.interactivityCenter.stop(poll: poll) {
                _, error in
                if let error = error {
                    result(HMSErrorExtension.toDictionary(error))
                } else {
                    result(nil)
                }
            }
        }
    }

    static private func fetchLeaderboard(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ currentPolls: [HMSPoll]?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let pollId = arguments?["poll_id"] as? String,
              let count = arguments?["count"] as? Int,
              let startIndex = arguments?["start_index"] as? Int,
              let includeCurrentPeer = arguments?["include_current_peer"] as? Bool
        else {
            HMSErrorLogger.returnArgumentsError("Either pollId, count, startIndex or includeCurrentPeer is null")
            return
        }

        if let poll = hmsSDK?.interactivityCenter.polls.first(where: {$0.pollID == pollId}) {
            hmsSDK?.interactivityCenter.fetchLeaderboard(for: poll, offset: startIndex, count: count, includeCurrentPeer: includeCurrentPeer) {
                pollLeaderboardResponse, error in

                if let error = error {
                    result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                } else {
                    result(HMSResultExtension.toDictionary(true, HMSPollLeaderboardResponseExtension.toDictionary(pollLeaderboardResponse: pollLeaderboardResponse)))
                }
            }
        } else {
            HMSErrorLogger.returnArgumentsError("No poll with given pollId found")
            return
        }
    }

    static private func fetchPollList(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        let arguments = call.arguments as? [AnyHashable: Any]

        guard let state = arguments?["poll_state"] as? String
        else {
            HMSErrorLogger.returnArgumentsError("state is null")
            return
        }

        if let state = getPollState(pollState: state) {
            hmsSDK?.interactivityCenter.fetchPollList(state: state) {
                pollList, error in

                if let error = error {
                    result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                } else {
                    var map = [[String: Any?]]()

                    pollList?.forEach {
                        map.append(HMSPollExtension.toDictionary(poll: $0))
                    }
                    result(HMSResultExtension.toDictionary(true, map))
                }
            }
        } else {
            HMSErrorLogger.logError(#function, "No poll state matched", "ARGUMENTS_ERROR")
            result(nil)
        }
    }

    private static func fetchPollQuestions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as? [AnyHashable: Any]

        guard let state = arguments?["poll_state"] as? String,
              let pollId = arguments?["poll_id"] as? String
        else {
            HMSErrorLogger.returnArgumentsError("pollId or state is null")
            return
        }

        if let state = getPollState(pollState: state) {
            hmsSDK?.interactivityCenter.fetchPollList(state: state) {
                pollList, error in

                if let error = error {
                    result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                } else {

                    if let poll = pollList?.first(where: {
                        $0.pollID == pollId
                    }) {
                        hmsSDK?.interactivityCenter.fetchPollQuestions(poll: poll) {
                            updatedPoll, error in

                            if let error = error {
                                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                            } else {
                                var map = [[String: Any?]]()
                                updatedPoll?.questions?.forEach {
                                    map.append(HMSPollQuestionExtension.toDictionary(question: $0))
                                }
                                result(HMSResultExtension.toDictionary(true, map))

                            }
                        }
                    } else {
                        HMSErrorLogger.logError(#function, "No poll with given pollId found", "NULL_ERROR")
                    }

                }
            }
        } else {
            HMSErrorLogger.logError(#function, "No poll state matched", "ARGUMENTS_ERROR")
            result(nil)
        }
    }

    private static func getPollResults(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as? [AnyHashable: Any]

        guard let state = arguments?["poll_state"] as? String,
              let pollId = arguments?["poll_id"] as? String
        else {
            HMSErrorLogger.returnArgumentsError("pollId or state is null")
            return
        }

        if let state = getPollState(pollState: state) {
            hmsSDK?.interactivityCenter.fetchPollList(state: state) {
                pollList, error in

                if let error = error {
                    result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                } else {

                    if let poll = pollList?.first(where: {
                        $0.pollID == pollId
                    }) {
                        hmsSDK?.interactivityCenter.fetchPollResult(for: poll) {
                            updatedPoll, error in

                            if let error = error {
                                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.toDictionary(error)))
                            } else {
                                if let updatedPoll {
                                    result(HMSResultExtension.toDictionary(true, HMSPollExtension.toDictionary(poll: updatedPoll)))
                                } else {
                                    HMSErrorLogger.logError(#function, "poll is NULL", "NULL_ERROR")
                                    result(nil)
                                    return
                                }

                            }
                        }
                    } else {
                        HMSErrorLogger.logError(#function, "No poll with given pollId found", "NULL_ERROR")
                    }

                }
            }
        } else {
            HMSErrorLogger.logError(#function, "No poll state matched", "ARGUMENTS_ERROR")
            result(nil)
        }
    }

    private static func getPollState(pollState: String?) -> HMSPollState? {
        guard let state = pollState else {
            return nil
        }

        switch state {
        case "created":
            return .created
        case "started":
            return .started
        case "stopped":
            return .stopped
        default:
            return nil
        }
    }

}
