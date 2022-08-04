//
//  HMSTrackSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 04/08/22.
//

import Foundation
import HMSSDK

class HMSTrackSettingsExtension {
    static func toDictionary(_ hmssdk: HMSSDK) -> [String: Any] {
        
        let hmsTrackSettings = hmssdk.trackSettings
        var dict = [String: Any]()
        
        if let hmsVideoSettings = hmsTrackSettings.video {
            dict["video"] = HMSTrackSettingsExtension.toDictionary(hmsVideoSettings)
        }
        if let hmsAudioSettings = hmsTrackSettings.audio {
            dict["audio"] = HMSTrackSettingsExtension.toDictionary(hmsAudioSettings)
        }

        return dict
    }
    
    static func toDictionary(_ hmsVideoTrackSettings: HMSVideoTrackSettings) -> [String: Any] {

        var dict = [String: Any]()

        dict["codec"] = hmsVideoTrackSettings.codec
        dict["camera_facing"] = hmsVideoTrackSettings.cameraFacing
        dict["max_bitrate"] = hmsVideoTrackSettings.maxBitrate
        dict["max_frame_rate"] = hmsVideoTrackSettings.maxFrameRate
        dict["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsVideoTrackSettings.resolution)
        dict["simulcast_settings"] = hmsVideoTrackSettings.simulcastSettings
        dict["track_description"] = hmsVideoTrackSettings.trackDescription
        dict["video_plugins"] = hmsVideoTrackSettings.videoPlugins

        return dict
    }
    
    static func toDictionary(_ hmsAudioTrackSettings: HMSAudioTrackSettings) -> [String: Any] {

        var dict = [String: Any]()

        dict["track_description"] = hmsAudioTrackSettings.trackDescription
        dict["max_bitrate"] = hmsAudioTrackSettings.maxBitrate
        dict["audio_source"] = hmsAudioTrackSettings.audioSource

        return dict
    }
    
    static func setTrackSetting(_ settingsDict: [AnyHashable: Any]) -> HMSTrackSettings? {
        
            var audioSettings: HMSAudioTrackSettings?
            if let audioSettingsDict = settingsDict["audio_track_setting"] as? [AnyHashable: Any] {
                if let bitrate = audioSettingsDict["bit_rate"] as? Int, let desc = audioSettingsDict["track_description"] as? String {
                    audioSettings = HMSAudioTrackSettings(maxBitrate: bitrate, trackDescription: desc)
                }
            }
            
            var videoSettings: HMSVideoTrackSettings?
            if let videoSettingsDict = settingsDict["video_track_setting"] as? [AnyHashable: Any] {
                if let codec = videoSettingsDict["video_codec"] as? String,
                   let bitrate = videoSettingsDict["max_bit_rate"] as? Int,
                   let framerate = videoSettingsDict["max_frame_rate"] as? Int,
                   let desc = videoSettingsDict["track_description"] as? String {
                    
                    videoSettings = HMSVideoTrackSettings(codec: getCodec(from: codec),
                                                          resolution: .init(width: 320, height: 180),
                                                          maxBitrate: bitrate,
                                                          maxFrameRate: framerate,
                                                          cameraFacing: .front,
                                                          trackDescription: desc,
                                                          videoPlugins: nil)
                }
            }
        
        return HMSTrackSettings(videoSettings: videoSettings, audioSettings: audioSettings)
    }
    
    static private func getCodec(from string: String) -> HMSCodec {
        if string.lowercased().contains("h264") {
            return HMSCodec.H264
        }
        return HMSCodec.VP8
    }
}
