//
//  HMSFlutterVideoPlayer.swift
//  hmssdk_flutter
//
//  Created by Govind on 01/02/23.
//

import UIKit
import HMSSDK
import AVFoundation
import AVKit

class HMSFlutterVideoPlayer: NSObject, FlutterPlatformView {

    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    private var url: String?
    // private var timerTest : Timer?
    // private var statMonitor: HMSHLSStatsMonitor?
    private var plugin: SwiftHmssdkFlutterPlugin

    init(url: String, plugin: SwiftHmssdkFlutterPlugin) {
        self.url = url
        self.plugin = plugin
        super.init()
    }

    func view() -> UIView {
        renderVideo()
    }

    private func renderVideo() -> UIView {
        let videoURL = URL(string: url!)
        player = AVPlayer(url: videoURL!)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.showsPlaybackControls = true
        if #available(iOS 14.2, *) {
            playerViewController?.canStartPictureInPictureAutomaticallyFromInline = true
        }
        playerViewController?.player?.play()
        // NotificationCenter.default.addObserver(self, selector: #selector(methodCall), name: NSNotification.Name("HMSFlutterVideoPlayer"), object: nil)
        return playerViewController!.view
    }

    deinit {
        playerViewController?.player?.pause()
        playerViewController?.player?.replaceCurrentItem(with: nil)
        player = nil
        playerViewController = nil
        // statMonitor = nil
        // timerTest = nil
        // NotificationCenter.default
        //   .removeObserver(self, name: NSNotification.Name("HMSFlutterVideoPlayer"), object: nil)
    }
    
    // @objc func methodCall(_ notification: Notification) {
    //     guard let method = notification.userInfo?["method"] as? String
    //     else {
    //         print(#function, " method not found")
    //         return
    //     }
    //     switch method {
    //     case "start_hls_stats":
    //         startStats()
    //     case "stop_hls_stats":
    //         stopStats()
    //     default:
    //         print(#function, " method not found")
    //     }
    // }
    
    // func startStats () {
    //     guard player != nil else { return }
        
    //     statMonitor = plugin.hmsSDK?.hlsStatsMonitor(player: player!)
    //     guard timerTest == nil else { return }

    //     timerTest =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    //         var dict = [
    //             "estimated_bandwidth": self.statMonitor?.estimatedBandwidth,
    //             "bitrate": self.statMonitor?.bitrate,
    //             "bytes_downloaded": self.statMonitor?.bytesDownloaded,
    //             "buffered_duration": self.statMonitor?.bufferedDuration,
    //             "distance_from_live_edge": self.statMonitor?.distanceFromLiveEdge,
    //             "dropped_frames": self.statMonitor?.droppedFrames,
    //             "video_size": self.statMonitor?.videoSize,
    //             "watch_duration": self.statMonitor?.watchDuration
    //         ] as [String: Any?]
            
    //         self.plugin.sendVideoPlayerStats(dict)
    //     }
    // }
    
    // func stopStats() {
    //     timerTest?.invalidate()
    //     timerTest = nil
    //     statMonitor = nil
    // }
}
