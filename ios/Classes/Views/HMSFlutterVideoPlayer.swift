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
    init(url: String) {
        self.url = url
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
        return playerViewController!.view
    }

    deinit {
        player = nil
        playerViewController = nil
    }
}
