//
//  HMSFlutterVideoPlayerFactory.swift
//  hmssdk_flutter
//
//  Created by Govind on 01/02/23.
//

import Foundation
import HMSSDK
import UIKit

class HMSFlutterVideoPlayerFactory: NSObject, FlutterPlatformViewFactory {
    
    let plugin: SwiftHmssdkFlutterPlugin

    init(plugin: SwiftHmssdkFlutterPlugin) {
        self.plugin = plugin
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        let arguments = args as! [String: AnyObject]
        
        return HMSFlutterVideoPlayer(url: arguments["url"] as! String, plugin: plugin)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
