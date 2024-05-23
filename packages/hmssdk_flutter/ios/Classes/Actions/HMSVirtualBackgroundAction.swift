//
//  HMSVirtualBackgroundAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 17/05/24.
//

import Foundation
import HMSSDK

class HMSVirtualBackgroundAction{
    
    @available(iOS 15.0, *)
    private static var virtualBackgroundPlugin: HMSVirtualBackgroundPlugin?
    
    static func virtualBackgroundActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "enable_virtual_background":
            enableVirtualBackground(call,result)
        case "disable_virtual_background":
            disableVirtualBackground(result)
        case "enable_blur_background":
            enableBlurBackground(call,result)
        case "disable_blur_background":
            disableBlurBackground(result)
        case "change_virtual_background":
            changeBackground(call, result)
        case "is_virtual_background_supported":
            isSupported(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    @available(iOS 15.0, *)
    static func getPlugin() -> HMSVirtualBackgroundPlugin?{
        virtualBackgroundPlugin = HMSVirtualBackgroundPlugin(backgroundImage: nil,blurRadius: 100)
        return virtualBackgroundPlugin
    }
    
    static func enableVirtualBackground(_ call: FlutterMethodCall, _ result: @escaping FlutterResult){
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let image = arguments["image"] as? FlutterStandardTypedData
        else{
            HMSErrorLogger.returnArgumentsError("Image can't be null")
            return
        }
        
        if #available(iOS 15.0, *) {
            virtualBackgroundPlugin?.backgroundImage = UIImage(data: image.data)
            virtualBackgroundPlugin?.activate()
        }else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }
    
    static func disableVirtualBackground(_ result: @escaping FlutterResult){
        if #available(iOS 15.0, *) {
            virtualBackgroundPlugin?.deactivate()
        }else{
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }
    
    static func enableBlurBackground(_ call: FlutterMethodCall,_ result: @escaping FlutterResult){
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let blurRadius = arguments["blur_radius"] as? Int
        else{
            HMSErrorLogger.returnArgumentsError("blur radius not found")
            return
        }
        
        if #available(iOS 15.0, *) {
            virtualBackgroundPlugin?.backgroundImage = nil
            virtualBackgroundPlugin?.activate()
        }else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }
    
    static func disableBlurBackground(_ result: @escaping FlutterResult){
        
        if #available(iOS 15.0, *) {
            virtualBackgroundPlugin?.deactivate()
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }

    }
    
    static func changeBackground(_ call: FlutterMethodCall, _ result: @escaping FlutterResult){
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let image = arguments["image"] as? FlutterStandardTypedData
        else{
            HMSErrorLogger.returnArgumentsError("Image can't be null")
            return
        }
        
        if #available(iOS 15.0, *) {
            virtualBackgroundPlugin?.backgroundImage = UIImage(data: image.data)
        }else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }
    
    static func isSupported(_ result: @escaping FlutterResult){
        if #available(iOS 15.0, *) {
            result(HMSResultExtension.toDictionary(true,true))
        }else {
            result(HMSResultExtension.toDictionary(true,false))
        }
    }
}
