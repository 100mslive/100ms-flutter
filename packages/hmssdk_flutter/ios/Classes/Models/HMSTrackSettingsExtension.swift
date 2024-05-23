//
//  HMSTrackSettingsExtension.swift
//  hmssdk_flutter
//
//  Created by Govind on 04/08/22.
//

import Foundation
import HMSSDK

class HMSTrackSettingsExtension {

    static var videoSettings: HMSVideoTrackSettings?

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
        dict["audio_mode"] = getStringFromAudioMode(from: hmsAudioTrackSettings.audioMode)
        return dict
    }

    static func setTrackSetting(_ settingsDict: [AnyHashable: Any],
                                _ audioMixerSourceMap: [String: HMSAudioNode],
                                _ vbConformer: HMSVirtualBackgroundActionPluginProtocol,
                                _ result: @escaping FlutterResult) -> HMSTrackSettings? {

        var audioSettings: HMSAudioTrackSettings?

        if let audioSettingsDict = settingsDict["audio_track_setting"] as? [AnyHashable: Any] {

            var initialMuteState: HMSTrackMuteState?
            if let muteState = audioSettingsDict["track_initial_state"] as? String {
                initialMuteState = getinitialMuteState(from: muteState)
            }

            if #available(iOS 13.0, *), !audioMixerSourceMap.isEmpty {
                do {
                    let audioMixerSource = try HMSAudioMixerSource(nodes: audioMixerSourceMap.values.map {$0})

                    audioSettings = HMSAudioTrackSettings.build({ builder in

                        builder.audioSource = audioMixerSource

                        if let muteState = initialMuteState {
                            builder.initialMuteState = muteState
                        }

                        if let mode = getAudioMode(from: audioSettingsDict["audio_mode"] as? String) {
                            builder.audioMode = mode
                        }

                        /*
                         Here we set the noise cancellation controller based on the parameter passed in audio track
                         settings
                         */
                        if let enableNoiseCancellation = audioSettingsDict["enable_noise_cancellation"] as? Bool {
                            if enableNoiseCancellation {

                                /// We create  the noise cancellation plugin
                                HMSNoiseCancellationController.createPlugin()
                                builder.noiseCancellationPlugin = HMSNoiseCancellationController.noiseCancellationController
                            }
                        }
                    })

                } catch {
                    print(#function, HMSErrorExtension.toDictionary(error))
                    result(false)
                }
            } else {
                audioSettings = HMSAudioTrackSettings.build({ builder in

                    if let muteState = initialMuteState {
                        builder.initialMuteState = muteState
                    }

                    if let mode = getAudioMode(from: audioSettingsDict["audio_mode"] as? String) {
                        builder.audioMode = mode
                    }

                    /*
                     Here we set the noise cancellation controller based on the parameter passed in audio track
                     settings
                     */
                    if let enableNoiseCancellation = audioSettingsDict["enable_noise_cancellation"] as? Bool {
                        if enableNoiseCancellation {

                            /// We create  the noise cancellation plugin
                            HMSNoiseCancellationController.createPlugin()
                            builder.noiseCancellationPlugin = HMSNoiseCancellationController.noiseCancellationController
                        }
                    }

                })
            }
        }

        if let videoSettingsDict = settingsDict["video_track_setting"] as? [AnyHashable: Any] {
            if let cameraFacing = videoSettingsDict["camera_facing"] as? String,
               let isVirtualBackgroundEnabled = videoSettingsDict["is_virtual_background_enabled"] as? Bool,
               let initialMuteState = videoSettingsDict["track_initial_state"] as? String {

                var videoPlugins: [HMSVideoPlugin]?
                if isVirtualBackgroundEnabled {
                    if #available(iOS 15.0, *) {
                        if let virtualbackground = vbConformer.plugin {
                            videoPlugins = []
                            videoPlugins?.append(virtualbackground)
                        }
                    } else {
                        HMSErrorLogger.logError("\(#function)", "Virtual Background is not supported below iOS 15", "Plugin not supported error")
                    }
                }
                videoSettings = HMSVideoTrackSettings(codec: HMSCodec.VP8,
                                                      resolution: .init(width: 320, height: 180),
                                                      maxBitrate: 32,
                                                      maxFrameRate: 30,
                                                      cameraFacing: getCameraFacing(from: cameraFacing),
                                                      simulcastSettings: nil,
                                                      trackDescription: "track_description",
                                                      initialMuteState: getinitialMuteState(from: initialMuteState),
                                                      videoPlugins: videoPlugins)
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

    static private func getStringFromAudioMode(from mode: HMSAudioMode) -> String? {
        switch mode {
        case .music:
            return "music"

        case .voice:
            return "voice"

        default:
            return nil
        }
    }
}
