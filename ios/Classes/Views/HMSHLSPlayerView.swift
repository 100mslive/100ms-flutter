//
//  HMSHLSPlayerView.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 23/05/23.
//

import Foundation
import HM

class HMSHLSPlayerView: NSObject, FlutterPlatformView{
    
    private let frame: CGRect
    private let viewIdentifier: Int64
    private let hlsURL: String?
    private let hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?
    private let isHLSStatsRequired: Bool
    private let showPlayerControls: Bool
    
    init(frame: CGRect, viewIdentifier: Int64, hlsURL: String?, hmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin?, isHLSStatsRequired: Bool, showPlayerControls: Bool) {
        self.frame = frame
        self.viewIdentifier = viewIdentifier
        self.hlsURL = hlsURL
        self.hmssdkFlutterPlugin = hmssdkFlutterPlugin
        self.isHLSStatsRequired = isHLSStatsRequired
        self.showPlayerControls = showPlayerControls
    }
    
    
    func view() -> UIView {
        <#code#>
    }
    
    
}
