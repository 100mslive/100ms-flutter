//
//  HMSNoiseCancellationController.swift
//  hmssdk_flutter
//
//  Created by Pushpam on 22/03/24.
//

import Foundation
import HMSSDK
import HMSNoiseCancellationModels

class HMSNoiseCancellationController {
    static var noiseCancellationController: HMSNoiseCancellationPlugin?

    static func noiseCancellationActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "enable_noise_cancellation":
            enable(result)
        case "disable_noise_cancellation":
            disable(result)
        case "is_noise_cancellation_enabled":
            isEnabled(result)
        case "is_noise_cancellation_available":
            isAvailable(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /**
     * [createPlugin] creates the noiseCancellationPlugin based on the parameter in audio track settings
     */
    static func createPlugin() {
        noiseCancellationController = {
            if let pathForNCModel = HMSNoiseCancellationModels.path(for: .smallFullBand) {
                 return HMSNoiseCancellationPlugin(modelPath: pathForNCModel, initialState: .enabled)
            } else {
                 assertionFailure("Noise cancellation model was not found")
            }
            return nil
       }()
    }

    /**
     * [enable] method enables noise cancellation for the user
     */
    private static func enable(_ result: @escaping FlutterResult) {
        if let controller = noiseCancellationController {
            do {
                try controller.enable()
                result(nil)
            } catch {
                print("An error occurred: \(error)")
            }
        } else {
            HMSErrorLogger.logError(#function, "Noise cancellation controller is not initialised. Please enable noise cancellation in audio track settings while initialising HMSSDK", "NULL_ERROR")
        }
    }

    /**
     * [disable] method disables noise cancellation for the user
     */
    private static func disable(_ result: @escaping FlutterResult) {
        if let controller = noiseCancellationController {
            do {
                try controller.disable()
                result(nil)
            } catch {
                print("An error occurred: \(error)")
            }
        } else {
            HMSErrorLogger.logError(#function, "Noise cancellation controller is not initialised. Please enable noise cancellation in audio track settings while initialising HMSSDK", "NULL_ERROR")
        }
    }

    /**
     * [isEnabled] method returns whether noise cancellation is enabled or not
     */
    private static func isEnabled(_ result: @escaping FlutterResult) {
        if let controller = noiseCancellationController {
                let isNoiseCancellationEnabled = controller.isEnabled()
            result(HMSResultExtension.toDictionary(true, isNoiseCancellationEnabled))
        } else {
            HMSErrorLogger.logError(#function, "Noise cancellation controller is not initialised. Please enable noise cancellation in audio track settings while initialising HMSSDK", "NULL_ERROR")
        }
    }

    /**
     * [isAvailable] method returns whether noise cancellation is available in the room
     */
    private static func isAvailable(_ result: @escaping FlutterResult) {
        if let controller = noiseCancellationController {
            let isNoiseCancellationAvailable = controller.isNoiseCancellationAvailable
            result(HMSResultExtension.toDictionary(true, isNoiseCancellationAvailable))
        } else {
            HMSErrorLogger.logError(#function, "Noise cancellation controller is not initialised. Please enable noise cancellation in audio track settings while initialising HMSSDK", "NULL_ERROR")
        }
    }

}
