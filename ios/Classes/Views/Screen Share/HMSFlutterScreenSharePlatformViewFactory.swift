//
//  HMSFlutterScreenSharePlatformViewFactory.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 15/06/22.
//

import Flutter
import HMSSDK
import UIKit


class HMSFlutterScreenSharePlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    
    let plugin: SwiftHmssdkFlutterPlugin

    init(plugin: SwiftHmssdkFlutterPlugin) {
        self.plugin = plugin
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        
        // TODO: pass in params for customizations
        return HMSFlutterScreenShareView()
    }
}
