//
//  HLSStreamViewController.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 24/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSStreamViewController : HMSHLSPlayerDelegate{
    
    private let hlsPlayer: HMSHLSPlayer?
    private let hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?
    
    init(hlsPlayer: HMSHLSPlayer?, hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?) {
        self.hlsPlayer = hlsPlayer
        self.hmssdkFlutterPlugin = hmssdkFlutterPlugin
    }
    
    func onPlaybackStateChanged(state: HMSHLSPlaybackState) {
        let data = [
            "event_name":"on_playback_state_changed",
            "data" : HMSHLSPlaybackStateExtension.toDictionary(state)
        ] as [String:Any?]
        
        guard let hmssdkFlutterPlugin else{
            HMSErrorLogger.logError(#function,"hmssdkFlutterPlugin is null","NULL_ERROR")
            return
        }
        hmssdkFlutterPlugin.hlsPlayerSink?(data)
    }
    
    func onCue(cue: HMSHLSCue) {
        let data = [
            "event_name":"on_cue",
            "data" : HMSHLSCueExtension.toDictionary(cue)
        ] as [String:Any?]
        
        guard let hmssdkFlutterPlugin else{
            HMSErrorLogger.logError(#function,"hmssdkFlutterPlugin is null","NULL_ERROR")
            return
        }
        hmssdkFlutterPlugin.hlsPlayerSink?(data)
        
    }
    
    func onPlaybackFailure(error: Error) {
        guard let error = error as? HMSHLSError else { return }
                
        if error.isTerminal {
            HMSErrorLogger.logError(#function,"Player has encountered a terminal error, we need to restart the player: \(error.localizedDescription)","PLAYBACK_TERMINAL_ERROR")
        }
        else {
            HMSErrorLogger.logError(#function,"Player has encountered an error, but it's non-fatal and player might recover \(error.localizedDescription)","PLAYBACK_ERROR")
        }

        let data = [
            "event_name" : "on_playback_failure",
            "data" : ["error":error.localizedDescription] as [String:String?]
        ] as [String:Any?]
        
        guard let hmssdkFlutterPlugin else{
            HMSErrorLogger.logError(#function,"hmssdkFlutterPlugin is null","NULL_ERROR")
            return
        }
        hmssdkFlutterPlugin.hlsPlayerSink?(data)
            
    }
    
}
