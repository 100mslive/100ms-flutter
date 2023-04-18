//
//  HMSCameraControlsAction.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 17/04/23.
//

import Foundation
import HMSSDK

class HMSCameraControlsAction {

    static func cameraControlsAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        guard let localPeer = hmsSDK?.localPeer,
        let localVideoTrack = localPeer.localVideoTrack()
        else {
            // TODO: add error log
            // result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Error in capturing image")))
            return
        }

        let arguments = call.arguments as? [AnyHashable: Any]

        let withFlash = arguments?["with_flash"] as? Bool ?? false

        localVideoTrack.captureImageAtMaxSupportedResolution(withFlash: false) { image in

            guard let capturedImage = image else {
                // TODO: add error log
                // result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Error in capturing image")))
                return
            }

            guard let data = capturedImage.jpegData(compressionQuality: 1.0) else {
                // TODO: add error log
                // result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Error in capturing image")))
                return
            }

            let filePath = getDocumentsDirectory().appendingPathComponent("hms_\(getTimeStamp()).jpg")

            do {
                try data.write(to: filePath)
            } catch {
                // TODO: add error log using error.localizedDescription
                // result.success(HMSResultExtension.toDictionary(false, HMSExceptionExtension.getError("Error in capturing image")))
            }

            result(HMSResultExtension.toDictionary(true, filePath.absoluteString))
        }
    }

    static private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    static private func getTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: Date())
    }
}
