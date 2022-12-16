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
    
    let registrar: FlutterPluginRegistrar

    init(registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return NativeVideoViewController(frame: frame, viewId: viewId, registrar: registrar)
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
