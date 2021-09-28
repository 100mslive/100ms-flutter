//
//  HMSVideoViewFactory.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import Flutter
import HMSSDK

class  HMSVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    
    let messenger: FlutterBinaryMessenger
    let plugin: SwiftHmssdkFlutterPlugin
    
    init(messenger: FlutterBinaryMessenger, plugin: SwiftHmssdkFlutterPlugin) {
        self.messenger = messenger
        self.plugin = plugin
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        let arguments = args as! Dictionary<String, AnyObject>
        
        let isLocal = arguments["is_local"] as? Bool ?? true
        let peerId = arguments["peer_id"] as? String ?? ""
        let trackId = arguments["track_id"] as? String ?? ""
        
        let width = arguments["width"] as? Double ?? frame.size.width
        let height = arguments["height"] as? Double ?? frame.size.height
        
        let newFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let peer = plugin.getPeerById(peerId: peerId, isLocal: isLocal)
        return HMSVideoViewWidget(frame: newFrame,
                                  viewIdentifier: viewId,
                                  arguments: args,
                                  binaryMessenger: messenger,
                                  peer: peer,
                                  trackId: trackId)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}


class HMSVideoViewWidget: NSObject, FlutterPlatformView {
    
    private var args: Any?
    var timer = Timer()
    private var _view: UIView
    private var peer: HMSPeer?
    private var trackId: String
    var count: Int = 0
    let frame: CGRect
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger, peer: HMSPeer?, trackId: String) {
        
        self.args = args
        self.frame = frame
        self._view = UIView(frame: frame)
        self.peer = peer
        self.trackId = trackId
        super.init()
        createHMSVideoView()
    }
    
    func createHMSVideoView() {
        
        let videoView = HMSVideoView(frame: frame)
        
        // Find track using track id
        
        if let videoTrack = peer?.videoTrack {
            if videoTrack.trackId == trackId {
                videoView.setVideoTrack(videoTrack)
                _view.addSubview(videoView)
                print(#function, "attaching video track")
                return
            }
        }
        else if let auxilaryTracks = peer?.auxiliaryTracks {
            
            if let track = auxilaryTracks.first(where: {$0.trackId == self.trackId}) {
                if let videoTrack = track as? HMSVideoTrack {
                    videoView.setVideoTrack(videoTrack)
                    _view.addSubview(videoView)
                    print(#function, "attaching video track")
                    return
                }
            }
        }
        print(#function, "Error: Could not find video track to attach to view")
    }
    
    func view() -> UIView {
        return _view
    }
}
