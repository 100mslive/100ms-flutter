//
//  HMSFlutterPlatformViewFactory.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import Flutter
import HMSSDK
import UIKit

class HMSFlutterPlatformViewFactory: NSObject, FlutterPlatformViewFactory {

    let plugin: SwiftHmssdkFlutterPlugin

    init(plugin: SwiftHmssdkFlutterPlugin) {
        self.plugin = plugin
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {

        let arguments = args as! [String: AnyObject]

        return HMSFlutterPlatformView(frame: getFrame(from: arguments) ?? frame,
                                      viewIdentifier: viewId,
                                      videoContentMode: getMode(from: arguments),
                                      mirror: getMirror(from: arguments),
                                      disableAutoSimulcastLayerSelect: false,
                                      videoTrack: getVideoTrack(from: arguments))
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    // MARK: - Helper Functions

    private func getFrame(from arguments: [String: AnyObject]) -> CGRect? {
        guard let width = arguments["width"] as? Double,
              let height = arguments["height"] as? Double else {
                  return nil
              }
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    private func getMirror(from arguments: [String: AnyObject]) -> Bool {
        arguments["set_mirror"] as? Bool ?? false
    }

    private func getMode(from arguments: [String: AnyObject]) -> UIView.ContentMode {
        let scaleTypeInt = arguments["scale_type"] as? Int
        return getViewContentMode(scaleTypeInt)
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

    private func getVideoTrack(from arguments: [String: AnyObject]) -> HMSVideoTrack {

        let trackID = arguments["track_id"] as? String ?? ""

        if let videoTrack = HMSUtilities.getVideoTrack(for: trackID, in: plugin.hmsSDK!.room!) {
            return videoTrack
        }

        return plugin.hmsSDK!.localPeer!.videoTrack!
    }
}
