//
//  HMSVirtualBackgroundAction.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 17/05/24.
//

import Foundation
import HMSSDK

internal protocol HMSVirtualBackgroundActionPluginProtocol {
    @available(iOS 15.0, *)
    var plugin: HMSVirtualBackgroundPlugin? { get }
}

class HMSVirtualBackgroundAction: HMSVirtualBackgroundActionPluginProtocol {

    internal var _plugin: Any?

    @available(iOS 15.0, *)
    internal var plugin: HMSVirtualBackgroundPlugin? {
        if _plugin == nil {
            _plugin = HMSVirtualBackgroundPlugin(backgroundImage: nil, blurRadius: 100)
        }
        return _plugin as? HMSVirtualBackgroundPlugin
    }

    internal func performActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "enable_virtual_background":
            enable(call, result)
        case "disable_virtual_background":
            disable(result)
        case "enable_blur_background":
            enableBlur(call, result)
        case "disable_blur_background":
            disableBlur(result)
        case "change_virtual_background":
            changeBackground(call, result)
        case "is_virtual_background_supported":
            isSupported(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func enable(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let image = arguments["image"] as? FlutterStandardTypedData
        else {
            HMSErrorLogger.returnArgumentsError("Image can't be null")
            return
        }

        if #available(iOS 15.0, *) {
            plugin?.backgroundImage = UIImage(data: image.data)
            plugin?.activate()
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }

    func disable(_ result: @escaping FlutterResult ) {
        if #available(iOS 15.0, *) {
            plugin?.deactivate()
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }

    func enableBlur(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let blurRadius = arguments["blur_radius"] as? Int
        else {
            HMSErrorLogger.returnArgumentsError("blur radius not found")
            return
        }

        if #available(iOS 15.0, *) {
            plugin?.backgroundImage = nil
            plugin?.activate()
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }

    func disableBlur(_ result: @escaping FlutterResult) {

        if #available(iOS 15.0, *) {
            plugin?.deactivate()
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)

    }

    func changeBackground(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        let arguments = call.arguments as! [AnyHashable: Any]

        guard let image = arguments["image"] as? FlutterStandardTypedData
        else {
            HMSErrorLogger.returnArgumentsError("Image can't be null")
            return
        }

        if #available(iOS 15.0, *) {
            plugin?.backgroundImage = UIImage(data: image.data)
        } else {
            HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
        }
        result(nil)
    }

    func isSupported(_ result: @escaping FlutterResult) {
        if #available(iOS 15.0, *) {
            result(HMSResultExtension.toDictionary(true, true))
        } else {
            result(HMSResultExtension.toDictionary(true, false))
        }
    }
}
