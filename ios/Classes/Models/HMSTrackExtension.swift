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
            "track_kind": getKindInString(kind: track.kind),
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

        if let localVideo = track as? HMSLocalVideoTrack {
            dict["hms_video_track_settings"] = HMSTrackExtension.toDictionary(video: localVideo.settings)
        }

        if let localAudio = track as? HMSLocalAudioTrack {
            dict["hms_audio_track_settings"] = HMSTrackExtension.toDictionary(audio: localAudio.settings)
        }

        return dict
    }

    static func getKindInString(kind: HMSTrackKind) -> String {
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
