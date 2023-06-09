//
//  HMSHLSPlayerViewFactory.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 23/05/23.
//

import Foundation

import Flutter
import HMSSDK
import UIKit

class HMSHLSPlayerViewFactory: NSObject, FlutterPlatformViewFactory {

    let plugin: SwiftHmssdkFlutterPlugin

    init(plugin: SwiftHmssdkFlutterPlugin) {
        self.plugin = plugin
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {

        let arguments = args as? [String: AnyObject]

        let hlsUrl = arguments?["hls_url"] as? String
        let isHLSStatsRequired = arguments?["is_hls_stats_required"] as? Bool ?? false

        let showPlayerControls = arguments?["show_player_controls"] as? Bool ?? false
        

        //This instantiates an HMSHLSPlayerView object with the provided parameters.
        return HMSHLSPlayerView(frame: frame,
                                      viewIdentifier: viewId,
                                hlsURL: hlsUrl,
                                hmssdkFlutterPlugin: plugin,
                                isHLSStatsRequired: isHLSStatsRequired,
                                showPlayerControls: showPlayerControls
                                      )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
