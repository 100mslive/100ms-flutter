//
//  HMSFlutterPlatformViewFactory.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Flutter
import HMSSDK
import UIKit

class HMSHLSVideoPlayerPlatformViewFactory: NSObject, FlutterPlatformViewFactory {

    let plugin: SwiftHmssdkFlutterPlugin

    init(plugin: SwiftHmssdkFlutterPlugin) {
        self.plugin = plugin
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {

        let arguments = args as! [String: AnyObject]

        return HMSHLSVideoPlayerController(url: arguments["url"] as! String,frame: frame)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
