//
//  HMSTranscriptionAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 14/06/24.
//

import Foundation
import HMSSDK

class HMSTranscriptionAction{
    
    static func transcriptionActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmssdk: HMSSDK?){
        switch call.method{
            case "start_real_time_transcription":
                startRealTimeTranscription(result, hmssdk)
            case "stop_real_time_transcription":
                stopRealTimeTranscription(result, hmssdk)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
    
    private static func startRealTimeTranscription(_ result: @escaping FlutterResult, _ hmssdk: HMSSDK?){

        hmssdk?.startTranscription(){ _, error in
            if let error = error{
                result(HMSErrorExtension.toDictionary(error))
            }else{
                result(nil)
            }
        }
    }
    
    
    private static func stopRealTimeTranscription(_ result: @escaping FlutterResult, _ hmssdk: HMSSDK?){
        hmssdk?.stopTranscription(){_, error in
            if let error = error{
                result(HMSErrorExtension.toDictionary(error))
            }else{
                result(nil)
            }
        }
    }
    
    
}
