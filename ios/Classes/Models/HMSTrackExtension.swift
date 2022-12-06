//
//  HMSTrackExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSTrackExtension {

    static func toDictionary(_ track: HMSTrack) -> [String: Any] {

        var dict = [
            "track_id": track.trackId,
            "track_kind": getStringFromKind(kind: track.kind),
            "track_source": track.source.uppercased(),
            "track_description": track.trackDescription,
            "track_mute": track.isMute()
        ] as [String: Any]

        if track.kind == .audio {
            dict["instance_of"] = false
        }

        if let videoTrack = track as? HMSVideoTrack {
            dict["is_degraded"] = videoTrack.isDegraded()
            dict["instance_of"] = true
        }

        if let remoteAudio = track as? HMSRemoteAudioTrack {
            dict["is_playback_allowed"] = remoteAudio.isPlaybackAllowed()
        }

        if let remoteVideo = track as? HMSRemoteVideoTrack {
            dict["is_playback_allowed"] = remoteVideo.isPlaybackAllowed()
        }
        
        if let remoteVideo = track as? HMSRemoteVideoTrack {
            dict["layer"] = HMSSimulcastLayerDefinitionExtension.getStringFromLayer(layer: remoteVideo.layer)
        }
        
        if let remoteVideo = track as? HMSRemoteVideoTrack {
            var layers = [[String: Any]]()
            remoteVideo.layerDefinitions?.forEach { layers.append(HMSSimulcastLayerDefinitionExtension.toDictionary($0)) }
            dict["layer_definitions"] = layers
        }

        return dict
    }

    static func getStringFromKind(kind: HMSTrackKind) -> String {
        switch kind {
        case .audio:
            return "kHMSTrackKindAudio"
        case .video:
            return "kHMSTrackKindVideo"
        @unknown default:
            return ""
        }
    }

    static func getValueOf(_ update: HMSTrackUpdate) -> String {

        switch update {
        case .trackAdded:
            return "trackAdded"

        case .trackRemoved:
            return "trackRemoved"

        case .trackMuted:
            return "trackMuted"

        case .trackUnmuted:
            return "trackUnMuted"

        case .trackDegraded:
            return "trackDegraded"

        case .trackRestored:
            return "trackRestored"

        case .trackDescriptionChanged:
            return "trackDescriptionChanged"

        default:
            return "defaultUpdate"
        }
    }

    static func toDictionary(audio settings: HMSAudioTrackSettings) -> [String: Any] {

        var dict = [String: Any]()

        dict["bit_rate"] = settings.maxBitrate

        if let desc = settings.trackDescription {
            dict["track_description"] = desc
        }

        return dict
    }

    static func toDictionary(video settings: HMSVideoTrackSettings) -> [String: Any] {
        var dict = [String: Any]()

        dict["camera_facing"] = HMSTrackExtension.getValueOfHMSCameraFacing(settings.cameraFacing)

        dict["video_codec"] = HMSTrackExtension.getValueOfHMSVideoCodec(settings.codec)

        dict["max_bit_rate"] = settings.maxBitrate

        dict["max_frame_rate"] = settings.maxFrameRate

        if let desc = settings.trackDescription {
            dict["track_description"] = desc
        }

        return dict
    }

    static func getValueOfHMSCameraFacing(_ facing: HMSCameraFacing) -> String {
        switch facing {
        case .back:
            return "back"
        case .front:
            return "front"
        default:
            return "default"
        }
    }

    static func getValueOfHMSVideoCodec(_ codec: HMSCodec) -> String {
        switch codec {
        case .H264:
            return "h264"
        case .VP8:
            return "vp8"
        default:
            return "default"
        }
    }
}
