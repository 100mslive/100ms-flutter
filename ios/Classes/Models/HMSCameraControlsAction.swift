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

        guard let localPeer = hmsSDK?.localPeer else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) An instance of Local Peer could not be found. Please check if a Room is joined.")))
            return
        }

        guard let localVideoTrack = localPeer.localVideoTrack()
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Video Track of Local Peer could not be found. Please check if the Local Peer has permission to publish video & video is unmuted currently.")))
            return
        }

        let arguments = call.arguments as? [AnyHashable: Any]

        let withFlash = arguments?["with_flash"] as? Bool ?? false

        localVideoTrack.captureImageAtMaxSupportedResolution(withFlash: withFlash) { image in

            guard let capturedImage = image else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not capture image of the Local Peer's Video Track.")))
                return
            }

            guard let data = capturedImage.jpegData(compressionQuality: 1.0) else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not compress image of the Local Peer's Video Track to jpeg data.")))
                return
            }

            let filePath = getDocumentsDirectory().appendingPathComponent("hms_\(getTimeStamp()).jpg")

            do {
                try data.write(to: filePath)
            } catch let error {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not write to disk the image data  of the Local Peer's Video Track. \(error.localizedDescription)")))
                return
            }

            result(HMSResultExtension.toDictionary(true, filePath.relativePath))
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
