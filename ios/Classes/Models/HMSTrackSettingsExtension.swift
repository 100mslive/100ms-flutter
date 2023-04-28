//
//  HMSTrackSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 04/08/22.
//

import Foundation
import HMSSDK

class HMSTrackSettingsExtension {
    static func toDictionary(_ hmssdk: HMSSDK, _ audioMixerSourceMap: [String: HMSAudioNode]?) -> [String: Any] {

        let hmsTrackSettings = hmssdk.trackSettings
        var dict = [String: Any]()

        if let hmsVideoSettings = hmsTrackSettings.video {
            dict["video_track_setting"] = HMSTrackSettingsExtension.toDictionary(hmsVideoSettings)
        }
        if let hmsAudioSettings = hmsTrackSettings.audio {
            dict["audio_track_setting"] = HMSTrackSettingsExtension.toDictionary(hmsAudioSettings, audioMixerSourceMap!)
        }

        return dict
    }

    static func toDictionary(_ hmsVideoTrackSettings: HMSVideoTrackSettings) -> [String: Any] {

        var dict = [String: Any]()
        if hmsVideoTrackSettings.codec ==  HMSCodec.H264 {
            dict["video_codec"] = "h264"
        } else {
            dict["video_codec"] = "vp8"
        }
        if hmsVideoTrackSettings.cameraFacing == .front {
            dict["camera_facing"] = "front"
        } else {
            dict["camera_facing"] = "back"
        }
        dict["max_bitrate"] = hmsVideoTrackSettings.maxBitrate
        dict["max_frame_rate"] = hmsVideoTrackSettings.maxFrameRate
        dict["resolution"] = HMSVideoResolutionExtension.toDictionary(hmsVideoTrackSettings.resolution)
        dict["simulcast_settings"] = hmsVideoTrackSettings.simulcastSettings
        dict["track_description"] = hmsVideoTrackSettings.trackDescription
        dict["video_plugins"] = hmsVideoTrackSettings.videoPlugins
        return dict
    }

    static func toDictionary(_ hmsAudioTrackSettings: HMSAudioTrackSettings, _ audioMixerSourceMap: [String: HMSAudioNode]) -> [String: Any] {

        var dict = [String: Any]()

        dict["track_description"] = hmsAudioTrackSettings.trackDescription
        dict["max_bitrate"] = hmsAudioTrackSettings.maxBitrate
        dict["audio_source"] = audioMixerSourceMap.keys.map {$0}
        return dict
    }

    static func setTrackSetting(_ settingsDict: [AnyHashable: Any], _ audioMixerSourceMap: [String: HMSAudioNode], _ result: @escaping FlutterResult) -> HMSTrackSettings? {

        var audioSettings: HMSAudioTrackSettings?
        if let audioSettingsDict = settingsDict["audio_track_setting"] as? [AnyHashable: Any],
           let initialMuteState = audioSettingsDict["track_initial_state"] as? String {

            if #available(iOS 13.0, *), !audioMixerSourceMap.isEmpty {
                do {
                    let audioMixerSource = try HMSAudioMixerSource(nodes: audioMixerSourceMap.values.map {$0})

                    audioSettings = HMSAudioTrackSettings(maxBitrate: 32, trackDescription: "track_description", initialMuteState: getinitialMuteState(from: initialMuteState), audioSource: audioMixerSource)

                } catch {
                    print(#function, HMSErrorExtension.toDictionary(error))
                    result(false)
                }
            } else {
                audioSettings = HMSAudioTrackSettings(maxBitrate: 32, trackDescription: "track_description", initialMuteState: getinitialMuteState(from: initialMuteState), audioSource: nil)
            }
        }

        var videoSettings: HMSVideoTrackSettings?
        if let videoSettingsDict = settingsDict["video_track_setting"] as? [AnyHashable: Any] {
            if let cameraFacing = videoSettingsDict["camera_facing"] as? String,
               let initialMuteState = videoSettingsDict["track_initial_state"] as? String {
                videoSettings = HMSVideoTrackSettings(codec: HMSCodec.VP8,
                                                      resolution: .init(width: 320, height: 180),
                                                      maxBitrate: 32,
                                                      maxFrameRate: 30,
                                                      cameraFacing: getCameraFacing(from: cameraFacing),
                                                      simulcastSettings: nil,
                                                      trackDescription: "track_description",
                                                      initialMuteState: getinitialMuteState(from: initialMuteState),
                                                      videoPlugins: nil)

            }
        }

        return HMSTrackSettings(videoSettings: videoSettings, audioSettings: audioSettings)
    }

    static private func getCameraFacing(from string: String) -> HMSCameraFacing {
        if string.lowercased().contains("back") {
            return HMSCameraFacing.back
        }
        return HMSCameraFacing.front
    }

    static private func getinitialMuteState(from string: String) -> HMSTrackMuteState {
        if string.lowercased().contains("unmuted") {
            return HMSTrackMuteState.unmute
        }
        return HMSTrackMuteState.mute
    }

    static private  func getAudioMode(from mode: String?) -> HMSAudioMode? {
        switch mode {
        case "voice":
            return .voice

        case "music":
            return .music

        default:
            return nil
        }
    }
}
