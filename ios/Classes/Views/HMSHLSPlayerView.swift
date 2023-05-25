//
//  HMSHLSPlayerView.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 23/05/23.
//

import Foundation
import HMSHLSPlayerSDK

class HMSHLSPlayerView: NSObject, FlutterPlatformView{
    
    private let frame: CGRect
    private let viewIdentifier: Int64
    private let hlsURL: String?
    private let hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?
    private let isHLSStatsRequired: Bool
    private let showPlayerControls: Bool
    private var hlsPlayer : HMSHLSPlayer?
    var statMonitor: HMSHLSStatsMonitor?
    private var hmsHLSStreamViewController : HMSHLSStreamViewController?
    
    init(frame: CGRect, viewIdentifier: Int64, hlsURL: String?, hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?, isHLSStatsRequired: Bool, showPlayerControls: Bool) {
        self.frame = frame
        self.viewIdentifier = viewIdentifier
        self.hlsURL = hlsURL
        self.hmssdkFlutterPlugin = hmssdkFlutterPlugin
        self.isHLSStatsRequired = isHLSStatsRequired
        self.showPlayerControls = showPlayerControls
    }
    
    
    
    func view() -> UIView {
        initialisePlayer()
    }
    
    private func initialisePlayer() -> UIView{
        
        hlsPlayer = HMSHLSPlayer()
        let playerViewController = hlsPlayer!.videoPlayerViewController(showsPlayerControls: showPlayerControls)
        if #available(iOS 14.2, *) {
            playerViewController.canStartPictureInPictureAutomaticallyFromInline = true
        }
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.view.frame = frame
        guard let hmssdkFlutterPlugin else{
            HMSErrorLogger.logError(#function,"hmssdkFlutterPlugin is null","NULL_ERROR")
            return playerViewController.view
        }
        
        /**
         * Here we start the player
         * We first check whether the user has passed the streamUrl or not
         * If not, we fetch the URL from SDK
         * else we use the URL sent by the user
         */
        if(hlsURL != nil){
            guard let hlsStreamURL =  URL(string: hlsURL!) else{
                HMSErrorLogger.logError(#function,"Cannot convert hlsURL to URL","PARSE_ERROR")
                return playerViewController.view
            }
            hlsPlayer?.play(hlsStreamURL)
        }
        else{
            if(hmssdkFlutterPlugin.hlsStreamUrl != nil){
                guard let hlsStreamURL =  URL(string: hmssdkFlutterPlugin.hlsStreamUrl!) else{
                    HMSErrorLogger.logError(#function,"hlsStreamURL not found","NULL_ERROR")
                    return playerViewController.view
                }
                hmsHLSStreamViewController = HMSHLSStreamViewController(hlsPlayer: hlsPlayer, hmssdkFlutterPlugin: hmssdkFlutterPlugin)
                hlsPlayer?.delegate = hmsHLSStreamViewController
                hlsPlayer?.play(hlsStreamURL)
                NotificationCenter.default.addObserver(self, selector: #selector(handleHLSPlayerOperations), name: NSNotification.Name(HMSHLSPlayerAction.HLS_PLAYER_METHOD), object: nil)
                
                if(isHLSStatsRequired){
                    HMSHLSStatsHandler.addHLSStatsListener(hlsPlayer, hmssdkFlutterPlugin)
                }
            }
        }
        
        
        return playerViewController.view
        
    }
    
    deinit {
        HMSHLSStatsHandler.removeHLSStatsListener()
        hlsPlayer = nil
    }
    
    @objc func handleHLSPlayerOperations(_ notification: Notification){
        switch notification.userInfo?[HMSHLSPlayerAction.METHOD_CALL] as? String? {
        case "start_hls_player":
            start()
        case "stop_hls_player":
            hlsPlayer?.stop()
            
        case "pause_hls_player":
            hlsPlayer?.pause()
            
        case "resume_hls_player":
            hlsPlayer?.resume()
            
        case "seek_to_live_position":
            hlsPlayer?.seekToLivePosition()
            
        case "seek_forward":
            hlsPlayer?.seekForward(seconds:TimeInterval(notification.userInfo!["seconds"] as! Int))
            
        case "seek_backward":
            hlsPlayer?.seekForward(seconds:TimeInterval(notification.userInfo!["seconds"] as! Int))
            
        case "set_hls_player_volume":
            hlsPlayer?.volume = notification.userInfo!["volume"] as! Int
            
        case "add_hls_stats_listener":
            addHLSStatsListener()
            
        case "remove_hls_stats_listener":
            removeHLSStatsListener()
        
        default:
            return
        }
    }
    
    private func start(){
        
        guard let hmssdkFlutterPlugin else{
            HMSErrorLogger.logError(#function,"hmssdkFlutterPlugin is null","NULL_ERROR")
            return
        }
        
        if(hmssdkFlutterPlugin.hlsStreamUrl != nil){
            guard let hlsStreamURL =  URL(string: hmssdkFlutterPlugin.hlsStreamUrl!) else{
                HMSErrorLogger.logError(#function,"hlsStreamURL not found","NULL_ERROR")
                return
            }
            hlsPlayer?.play(hlsStreamURL)
        }
    }
    
    private func addHLSStatsListener(){
        guard let hlsPlayer else{
            HMSErrorLogger.logError(#function,"hlsPlayer is null","NULL_ERROR")
            return
        }
        HMSHLSStatsHandler.addHLSStatsListener(hlsPlayer,hmssdkFlutterPlugin)
    }
    
    private func removeHLSStatsListener(){
        HMSHLSStatsHandler.removeHLSStatsListener()
    }
    
}
