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

class HMSPIPAction {
    static var pipVideoCallViewController: UIViewController?
    static var pipController: AVPictureInPictureController?
    
    static func pipAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
        case "setup_pip":
            setupPIP(call, result, hmsSDK)

        case "start_pip":
            startPIP()

        case "stop_pip":
            stopPIP()
            
        case "is_pip_available":
            isPIPAvailable(result)
        
        case "is_pip_active":
            isPIPActive(result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static func setupPIP(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        
        print(#function)
        
        guard #available(iOS 15.0, *) else {
            result(HMSErrorExtension.getError("iOS 15 or above is required"))
            return }
        
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            result(HMSErrorExtension.getError("PIP is not supported"))
            return }
        
        guard let uiView = UIApplication.shared.keyWindow?.visibleViewController?.view else {
            result(HMSErrorExtension.getError("Unable to setup PIP"))
            return }
        
        print(#function, "uiview", uiView, uiView.subviews)
                
        if(uiView.subviews.isEmpty){
            result(HMSErrorExtension.getError("Unable to setup PIP"))
            return
        }
        let scrollView = uiView.subviews[1] //uiView.subviews.first { $0.isKind(of: ChildClippingView.self) }
        
//        guard let scrollView = scrollView else { return }
        
        print(#function, "#1 scrollView: ", scrollView, uiView, uiView.subviews)
        
        let pipVideoCallViewController = AVPictureInPictureVideoCallViewController()
        
        self.pipVideoCallViewController = pipVideoCallViewController
        
        let model = PiPModel()
        model.track = hmsSDK?.remotePeers?.first?.videoTrack
        model.name = hmsSDK?.remotePeers?.first?.name
        model.isVideoActive = true
        model.pipViewEnabled = true
    
        
        let controller = UIHostingController(rootView: PiPView(model: model))
        
        pipVideoCallViewController.view.addConstrained(subview: controller.view)
        
        pipVideoCallViewController.preferredContentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        
        let pipContentSource = AVPictureInPictureController.ContentSource(
            activeVideoCallSourceView: scrollView,
            contentViewController: pipVideoCallViewController)
       
        pipController = AVPictureInPictureController(contentSource: pipContentSource)
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        if let autoEnterPIP = arguments["auto_enter_pip"] as? Bool {
            pipController?.canStartPictureInPictureAutomaticallyFromInline = autoEnterPIP
        }
//        pipController?.delegate = self
       
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil, queue: .main) { [self] _ in
            
            print(#function, " #2 didBecomeActiveNotification")
            stopPIP()
        }
        
        print(#function, "#3", scrollView, controller, pipVideoCallViewController, pipController!)
        result(nil)
    }
    
    static func startPIP() {
        pipController?.startPictureInPicture()
    }
    
    static func stopPIP() {
        pipController?.stopPictureInPicture()
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
}
