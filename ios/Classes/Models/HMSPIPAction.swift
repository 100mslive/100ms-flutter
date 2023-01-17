//
//  HMSPIPAction.swift
//  hmssdk_flutter
//
//  Created by Govind on 12/01/23.
//

import Foundation
import HMSSDK
import AVKit
import SwiftUI

@available(iOS 15.0, *)
class HMSPIPAction {
    static var pipVideoCallViewController: UIViewController?
    static var pipController: AVPictureInPictureController?
    static var model: PiPModel?
    static func pipAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?, _ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {
        switch call.method {
        case "setup_pip":
            setupPIP(call, result, hmsSDK, swiftHmssdkFlutterPlugin)

        case "start_pip":
            startPIP()

        case "stop_pip":
            stopPIP()
            
        case "is_pip_available":
            isPIPAvailable(result)
        
        case "is_pip_active":
            isPIPActive(result)
            
        case "change_track_pip":
            changeTrack(call, result, hmsSDK)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func setupPIP(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?,_ swiftHmssdkFlutterPlugin: SwiftHmssdkFlutterPlugin) {
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            result(HMSErrorExtension.getError("\(#function) PIP is not supported"))
            return }
        
        guard let uiView = UIApplication.shared.keyWindow?.rootViewController?.view else {
            result(HMSErrorExtension.getError("\(#function) Failed to setup PIP"))
            return }
            
        let pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
        
        self.pipVideoCallViewController = pipVideoCallViewController
           
        model = PiPModel()
        model!.track = hmsSDK?.localPeer?.videoTrack
        model!.pipViewEnabled = true
    
        
        let controller = UIHostingController(rootView: PiPView(model: model!))
        
        pipVideoCallViewController.view.addConstrained(subview: controller.view)
                
        let arguments = call.arguments as! [AnyHashable: Any]
    
        if let width = arguments["width"] as? Double, let height = arguments["height"] as? Double {
            pipVideoCallViewController.preferredContentSize = CGSize(width: width, height: height)
        } else {
            pipVideoCallViewController.preferredContentSize = CGSize(width: uiView.frame.size.width, height: uiView.frame.size.height) 
        }
        
        let pipContentSource = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: uiView,
            contentViewController: pipVideoCallViewController)
       
        pipController = AVPictureInPictureController(contentSource: pipContentSource)
        
        pipController?.delegate = swiftHmssdkFlutterPlugin
        
        if let autoEnterPIP = arguments["auto_enter_pip"] as? Bool {
            pipController?.canStartPictureInPictureAutomaticallyFromInline = autoEnterPIP
        }

        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil, queue: .main) { [self] _ in
            stopPIP()
        }
        result(nil)
    }
    
    static func startPIP() {
        pipController?.startPictureInPicture()
    }
    
    static func stopPIP() {
        pipController?.stopPictureInPicture()
    }
    
    static func disposePIP() {
        model?.pipViewEnabled = false
        model?.track = nil
        model = nil
        pipController = nil
        pipVideoCallViewController = nil
    }
    
    static func isPIPAvailable(_ result: @escaping FlutterResult) {
        if(AVPictureInPictureController.isPictureInPictureSupported()){
            result(true)
        } else { result(false) }
    }
    
    static func isPIPActive(_ result: @escaping FlutterResult) {
        if(pipController != nil && pipController!.isPictureInPictureActive){
            result(true)
        } else { result(false) }
    }
    
    static func changeTrack(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getVideoTrack(for: trackID, in: (hmsSDK?.room)!),
              let width = arguments["width"] as? Double,
              let height = arguments["height"] as? Double
        else {
            result(HMSErrorExtension.getError("\(#function) Unable to find track ID or width and height missing"))
            return
        }
        model?.track = track
        
        pipVideoCallViewController!.preferredContentSize = CGSize(width: width, height: height)
        
    }
    
}

extension SwiftHmssdkFlutterPlugin: AVPictureInPictureControllerDelegate {
    
    public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }
    
    public func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }
    
    public func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, failedToStartPictureInPictureWithError error: Error) {
        print(#function, error)
    }
    
    public func pictureInPictureControllerWillStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        print(#function)
    }
    
    public func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        print(#function)
    }
}


extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
