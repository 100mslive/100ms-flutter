//
//  HMSAudioDeviceAction.swift
//  hmssdk_flutter
//
//  Created by Govind on 01/12/22.
//

import Foundation
import HMSSDK

class HMSAudioDeviceAction {
    static func audioActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        switch call.method {
        case "get_audio_devices_list":
            getAudioDeviceList(result, hmsSDK)

        case "switch_audio_output":
            switchAudioOutput(call, result, hmsSDK)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static private func getAudioDeviceList(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        var audioDevicesList = [String]()
        guard let availableAudioOutputDevices = hmsSDK?.getAudioOutputDeviceList()
        else {
            print(#function, "Could not find audio output devices list")
            return result(audioDevicesList)
        }
        for device in availableAudioOutputDevices {
            audioDevicesList.append(getAudioDeviceName(device))
        }
        result(audioDevicesList)
    }

    static private func switchAudioOutput(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK) {
        let arguments = call.arguments as! [AnyHashable: Any]

        guard let audioDeviceName = arguments["audio_device_name"] as? String
        else {
            result(HMSErrorExtension.getError("Invalid arguments passed in \(#function)"))
            return
        }
        do {
            try hmsSDK.switchAudioOutput(to: getAudioDeviceName(audioDeviceName))
        } catch {
            result(HMSErrorExtension.getError("Unable to switch audio output"))
            return
        }
        result(true)
    }

   static private func getAudioDeviceName(_ audioDevice: String) -> HMSAudioOutputDevice {
        switch audioDevice {
        case "EARPIECE":
            return HMSAudioOutputDevice.earpiece
        case "SPEAKER_PHONE":
            return HMSAudioOutputDevice.speaker
        default:
            return HMSAudioOutputDevice.speaker
        }
    }

    static private func getAudioDeviceName(_ audioDevice: HMSAudioOutputDevice) -> String {
         switch audioDevice {
         case .earpiece:
             return "EARPIECE"
         case .speaker:
             return "SPEAKER_PHONE"
         default:
             return "SPEAKER_PHONE"
         }
     }
}
