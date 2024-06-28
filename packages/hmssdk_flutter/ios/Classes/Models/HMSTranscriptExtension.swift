//
//  HMSTranscriptExtension.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 14/06/24.
//

import Foundation
import HMSSDK

class HMSTranscriptExtension{
    
    static func toDictionary(hmsTranscript: HMSTranscript) -> [String:Any?]{
        
        var args = [String:Any?]()
        
        args["start"] = hmsTranscript.start
        args["end"] = hmsTranscript.end
        args["transcript"] = hmsTranscript.transcript
        args["peer_id"] = hmsTranscript.peer.peerID
        args["peer_name"] = hmsTranscript.peer.name
        args["is_final"] = hmsTranscript.isFinal
        
        return args
    }
    
    static func getMapFromTranscriptionsStateList(transcriptionStates: [HMSTranscriptionState]?) -> [[String:Any?]]?{
        
        if let transcripts = transcriptionStates{
            var transcriptStates = [[String:Any?]]()
            
            transcripts.forEach{
                transcriptStates.append(getMapFromTranscriptionState(transcriptionState: $0))
            }
            return transcriptStates
        }else{
            return nil
        }
        
    }
    
    private static func getMapFromTranscriptionState(transcriptionState: HMSTranscriptionState) -> [String:Any?]{
        
        var args = [String:Any?]()
        
        if let startedAt = transcriptionState.startedAt{
            args["started_at"] = Int(startedAt.timeIntervalSince1970 * 1000)
        }
        
        if let stoppedAt = transcriptionState.stoppedAt{
            args["stopped_at"] = Int(stoppedAt.timeIntervalSince1970 * 1000)
        }
        
        if let updatedAt = transcriptionState.updatedAt{
            args["updated_at"] = Int(updatedAt.timeIntervalSince1970 * 1000)
        }
        
        args["state"] = getStringFromTranscriptionState(transcriptionState: transcriptionState.state)
        
        args["mode"] = transcriptionState.mode
        
        return args
    }
    
    private static func getStringFromTranscriptionState(transcriptionState: HMSTranscriptionStatus) -> String?{
        switch transcriptionState{
        case .failed:
            return "failed"
        case .started:
            return "started"
        case .stopped:
            return "stopped"
        case .starting:
            return "initialized"
        default:
            return nil
        }
    }
    
    
    
}
