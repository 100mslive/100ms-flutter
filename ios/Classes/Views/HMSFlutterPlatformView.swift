//
//  HMSFlutterPlatformView.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 13/01/22.
//

import UIKit
import HMSSDK

class HMSFlutterPlatformView: NSObject, FlutterPlatformView {

    private let frame: CGRect
    private let viewIdentifier: Int64
    private let videoContentMode: UIView.ContentMode
    private let mirror: Bool
    private let disableAutoSimulcastLayerSelect: Bool
    private let videoTrack: HMSVideoTrack?
    private var videoView: HMSVideoView?

    init(frame: CGRect,
        viewIdentifier: Int64,
        videoContentMode: UIView.ContentMode,
        mirror: Bool,
        disableAutoSimulcastLayerSelect: Bool,
        videoTrack: HMSVideoTrack?) {

        self.frame = frame
        self.viewIdentifier = viewIdentifier
        self.videoContentMode = videoContentMode
        self.mirror = mirror
        self.disableAutoSimulcastLayerSelect = disableAutoSimulcastLayerSelect
        self.videoTrack = videoTrack
        super.init()
    }

    func view() -> UIView {
        renderVideo()
    }

    private func renderVideo() -> HMSVideoView {

        videoView = HMSVideoView(frame: frame)

        videoView?.videoContentMode = videoContentMode
        videoView?.mirror = mirror
        videoView?.disableAutoSimulcastLayerSelect = disableAutoSimulcastLayerSelect

        if let track = videoTrack {
            videoView?.setVideoTrack(track)
            NotificationCenter.default.addObserver(self, selector: #selector(captureSnapshot), name: NSNotification.Name(track.trackId), object: nil)
        } else {
            let errorMsg = "\(#function) Could not find video track to attach to Video View"
            print(errorMsg)
        }

        return videoView!
    }

    deinit {
        videoView?.setVideoTrack(nil)
        videoView = nil
        NotificationCenter.default
          .removeObserver(self, name: NSNotification.Name(videoTrack?.trackId ?? ""), object: nil)
    }

    @objc func captureSnapshot(_ notification: Notification) {

        guard let result = notification.userInfo?["result"] as? FlutterResult
        else {
            print(#function, " Result not found")
            return
        }

        guard let view = videoView
        else {
            print(#function, "Attached HMSVideoView not found")
            result(nil)
            return
        }

        guard let image = view.captureSnapshot()
        else {
            print(#function, "Could not capture snapshot of HMSVideoView")
            result(nil)
            return
        }

        guard let base64 = image.pngData()?.base64EncodedString() else {
            print(#function, "Could not create base64 encoded string of captured snapshot")
            result(nil)
            return
        }

        result(base64)
    }
}
