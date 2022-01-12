//
//  HMSVideoViewFactory.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import Flutter
import HMSSDK
import UIKit

class  HMSVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    
    let messenger: FlutterBinaryMessenger
    let plugin: SwiftHmssdkFlutterPlugin
    
    init(messenger: FlutterBinaryMessenger, plugin: SwiftHmssdkFlutterPlugin) {
        self.messenger = messenger
        self.plugin = plugin
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        let arguments = args as! Dictionary<String, AnyObject>
        
        let peerID = arguments["peer_id"] as? String ?? ""
        let trackId = arguments["track_id"] as? String ?? ""
        let mirror = arguments["set_mirror"] as? Bool ?? false
        let scaleTypeInt = arguments["scale_type"] as? Int
        let scaleType = getViewContentMode(scaleTypeInt)
        let width = arguments["width"] as? Double ?? frame.size.width
        let height = arguments["height"] as? Double ?? frame.size.height
        
        let newFrame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let peer = plugin.getPeer(by: peerID)
        
        return HMSVideoViewWidget(frame: newFrame,
                                  viewIdentifier: viewId,
                                  arguments: args,
                                  binaryMessenger: messenger,
                                  peer: peer,
                                  trackId: trackId,
                                  mirror: mirror,
                                  scaleType: scaleType)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    private func getViewContentMode(_ type: Int?) -> UIView.ContentMode {
        switch type {
        case 0:
            return .scaleAspectFit
        case 1:
            return .scaleAspectFill
        case 2:
            return .center
        default:
            return .scaleAspectFill
        }
    }
}


class HMSVideoViewWidget: NSObject, FlutterPlatformView {
    
    private var args: Any?
    var timer = Timer()
    private var _view: UIView
    private var peer: HMSPeer?
    private var trackId: String
    private var mirror: Bool
    private var scaleType: UIView.ContentMode
    var count: Int = 0
    let frame: CGRect
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger, peer: HMSPeer?, trackId: String, mirror: Bool, scaleType: UIView.ContentMode) {
        
        self.args = args
        self.frame = frame
        self._view = UIView(frame: frame)
        self.peer = peer
        self.trackId = trackId
        self.mirror = mirror
        self.scaleType = scaleType
        super.init()
        createHMSVideoView()
    }
    
    func createHMSVideoView() {
        
        let videoView = HMSVideoView(frame: frame)
        
        // Find track using track id
        
        if let auxilaryTracks = peer?.auxiliaryTracks {
            if let track = auxilaryTracks.first(where: {$0.trackId == self.trackId}) {
                if let videoTrack = track as? HMSVideoTrack {
                    videoView.videoContentMode = scaleType
                    videoView.mirror = mirror
                    videoView.setVideoTrack(videoTrack)
                    _view.addSubview(videoView)
                    return
                }
            }
        }
        
        if let videoTrack = peer?.videoTrack {
            if videoTrack.trackId == trackId {
                videoView.videoContentMode = scaleType
                videoView.mirror = mirror
                videoView.setVideoTrack(videoTrack)
                _view.addSubview(videoView)
                return
            }
        }
    }
    
    func view() -> UIView {
        return _view
    }
}
