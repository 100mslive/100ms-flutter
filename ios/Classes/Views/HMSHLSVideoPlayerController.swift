//
//  HMSFlutterPlatformView.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 13/01/22.
//

import UIKit
import HMSSDK
import AVKit

class HMSHLSVideoPlayerController: NSObject, FlutterPlatformView {

    private let url: String
    private let frame: CGRect

    init(url: String,frame: CGRect) {

        self.url = url
        self.frame = frame
        super.init()
    }

    func view() -> UIView {
        renderPlayer()
    }

    private func renderPlayer() ->  UIView {
        let view = UIView()
        view.backgroundColor = .yellow
        view.contentMode = .scaleAspectFit
        let player = AVPlayer(url: URL(string:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true

        view.layer.insertSublayer(playerLayer,at: 0)
        view.layer.needsDisplayOnBoundsChange = true
        let pip = AVPictureInPictureController(playerLayer: playerLayer)
        player.play()
        pip?.startPictureInPicture()
        if #available(iOS 14.2, *) {
            pip?.canStartPictureInPictureAutomaticallyFromInline = true
        } else {
            // Fallback on earlier versions
        }

//        let controller = AVPlayerViewController()
//        controller.player = player
//        controller.view.frame.size.width = 100
//        controller.view.frame.size.height = 100
//        view.addSubview(controller.view)
//        player.playImmediately(atRate: 1)
        
        return view
    }

}
