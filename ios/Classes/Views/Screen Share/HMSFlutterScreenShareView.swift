//
//  HMSFlutterScreenShareView.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 15/06/22.
//

import UIKit
import HMSSDK
import Flutter
import ReplayKit

class HMSFlutterScreenShareView: NSObject, FlutterPlatformView {
    
    private var _view: UIView
    
    override init() {
        let frame = CGRect(x: 0, y:0, width: 64, height: 64)
        _view = UIView(frame: frame)
        super.init()
        // TODO: take in frames from client
        
        let systemBroadcastPicker = RPSystemBroadcastPickerView(frame: frame)
        systemBroadcastPicker.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        // TODO: take in param from client
        systemBroadcastPicker.preferredExtension = "live.100ms.flutter.FlutterBroadcastUploadExtension"
        systemBroadcastPicker.showsMicrophoneButton = false
        
        for view in systemBroadcastPicker.subviews {
            if let button = view as? UIButton {
                
                if #available(iOS 13.0, *) {
                    let configuration = UIImage.SymbolConfiguration(pointSize: 24)
                    let image = UIImage(systemName: "rectangle.on.rectangle", withConfiguration: configuration)?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
                    button.setImage(image, for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        _view.addSubview(systemBroadcastPicker)
    }
    
    func view() -> UIView {
        return _view
    }
}
