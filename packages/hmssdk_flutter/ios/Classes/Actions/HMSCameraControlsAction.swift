//
//  HMSCameraControlsAction.swift
//  hmssdk_flutter
//
//  Created by Yogesh Singh on 17/04/23.
//

import Foundation
import HMSSDK

class HMSCameraControlsAction {

    // MARK: - Available Actions

    /// The `cameraControlsAction` function is an action handler for camera controls that can be invoked.
    ///
    /// The function serves as a central point for handling Camera Control actions, routing them to the appropriate implementation.
    ///
    /// - Parameters:
    ///   - call: the Method call received from Flutter framework
    ///   - result: the Result to be passed to Flutter layer
    ///   - hmsSDK: an instance of current HMSSDK
    static func cameraControlsAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        // Switch statement to handle different camera control method calls that may be invoked
        switch call.method {
        case "capture_image_at_max_supported_resolution":
            captureImageAtMaxSupportedResolution(call, result, hmsSDK)

        case "is_flash_supported":
            isFlashSupported(result, hmsSDK)

        case "toggle_flash":
            toggleFlash(result, hmsSDK)

        // these method calls return FlutterMethodNotImplemented to indicate that the requested functionality is not yet implemented.
        case "is_tap_to_focus_supported", "is_zoom_supported":
            result(FlutterMethodNotImplemented)

        // If the method call does not match any of the above cases, also return FlutterMethodNotImplemented.
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Capture At Max Resolution

    /// The function captures an image of the local peer's video track at the maximum supported resolution
    ///
    /// It compresses it to JPEG data, saves it to disk, and returns the path of the saved image file as a success result.
    /// The function includes error handling to handle cases where the image capture, compression, or file write fails.
    /// - Parameters:
    ///   - call: the Method call received from Flutter framework
    ///   - result: the Result to be passed to Flutter layer
    ///   - hmsSDK: an instance of current HMSSDK
    static private func captureImageAtMaxSupportedResolution(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        guard let localPeer = hmsSDK?.localPeer else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) An instance of Local Peer could not be found. Please check if a Room is joined.")))
            return
        }

        guard let localVideoTrack = localPeer.localVideoTrack()
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Video Track of Local Peer could not be found. Please check if the Local Peer has permission to publish video & video is unmuted currently.")))
            return
        }

        // Extract the 'with_flash' argument from the Flutter method call arguments
        let arguments = call.arguments as? [AnyHashable: Any]
        let withFlash = arguments?["with_flash"] as? Bool ?? false

        // Capture the image of the Local Peer's Video Track at maximum supported resolution
        localVideoTrack.captureImageAtMaxSupportedResolution(withFlash: withFlash) { image in

            // If capturing the image failed, return an error result
            guard let capturedImage = image else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not capture image of the Local Peer's Video Track.")))
                return
            }

            // Compress the captured image to JPEG data
            guard let data = capturedImage.jpegData(compressionQuality: 1.0) else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not compress image of the Local Peer's Video Track to jpeg data.")))
                return
            }

            // Write the JPEG data to disk
            let filePath = getDocumentsDirectory().appendingPathComponent("hms_\(getTimeStamp()).jpg")
            do {
                try data.write(to: filePath)
            } catch let error {
                // If writing to disk failed, return an error result
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Could not write to disk the image data  of the Local Peer's Video Track. \(error.localizedDescription)")))
                return
            }

            // Return the path of the saved image file as a success result
            result(HMSResultExtension.toDictionary(true, filePath.relativePath))
        }
    }

    static private func isFlashSupported(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        guard let localPeer = hmsSDK?.localPeer else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) An instance of Local Peer could not be found. Please check if a Room is joined.")))
            return
        }

        guard let localVideoTrack = localPeer.localVideoTrack()
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Video Track of Local Peer could not be found. Please check if the Local Peer has permission to publish video & video is unmuted currently.")))
            return
        }

        localVideoTrack.modifyCaptureDevice { device in
            guard let device = device else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Device could not be found")))
                return
            }
            result(HMSResultExtension.toDictionary(true, device.isTorchModeSupported(.on)))
        }
    }

    static private func toggleFlash(_ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {

        guard let localPeer = hmsSDK?.localPeer else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) An instance of Local Peer could not be found. Please check if a Room is joined.")))
            return
        }

        guard let localVideoTrack = localPeer.localVideoTrack()
        else {
            result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Video Track of Local Peer could not be found. Please check if the Local Peer has permission to publish video & video is unmuted currently.")))
            return
        }

        localVideoTrack.modifyCaptureDevice { device in
            guard let device = device else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Device could not be found")))
                return
            }

            if device.isTorchModeSupported(.on) {
                device.torchMode = device.torchMode == .off ? .on : .off
                result(HMSResultExtension.toDictionary(true, nil))
            } else {
                result(HMSResultExtension.toDictionary(false, HMSErrorExtension.getError("\(#function) Flash is not supported for current facing camera, Also please ensure camera is turned ON")))
            }
        }
    }

    // MARK: - Helper Functions

    /// `getDocumentsDirectory` returns the URL of the location on the device's file system where the app can store files that are generated at runtime, such as user-generated content or application state.
    ///
    /// - Returns: the URL of the application's documents directory
    static private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    /// This `getTimeStamp` function returns the current time as a string in a specific format using a DateFormatter object.
    ///
    /// The function sets the timeStyle property of the DateFormatter to .medium, which formats the time as "hh:mm:ss a" (e.g. "12:34:56 PM").
    ///
    /// - Returns: the string represents the current time in the time zone of the device running the application.
    static private func getTimeStamp() -> String {
        let formatter = DateFormatter()

        formatter.timeStyle = .medium
        return formatter.string(from: Date())
    }
}
