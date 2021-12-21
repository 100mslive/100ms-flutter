//
//  HMSTrackExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class HMSTrackExtension {
    
    static func toDictionary(track: HMSTrack) -> [String: Any] {
        
        var dict = [
            "track_id": track.trackId,
            "track_kind": getKindInString(kind:track.kind),
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
    
    static func getTrackUpdateInString(trackUpdate: HMSTrackUpdate) -> String {
        
        switch trackUpdate {    
        case .trackAdded :return "trackAdded"
        case .trackDegraded: return "trackDegraded"
        case .trackDescriptionChanged: return "trackDescriptionChanged"
        case .trackMuted: return "trackMuted"
        case .trackRemoved: return "trackRemoved"
        case .trackRestored: return "trackRestored"
        case .trackUnmuted: return "trackUnMuted"
        default:
            return "defaultUpdate"
        }
    }
    
    
    static func toDictionary(audio settings: HMSAudioTrackSettings) -> Dictionary<String,Any?> {
    
        var dict = [String: Any]()
        
        dict["bit_rate"] = settings.maxBitrate
        
        dict["track_description"] = settings.trackDescription
        
        return dict
    }
    
    
    static func toDictionary(video settings: HMSVideoTrackSettings) -> [String: Any] {
        var dict = [String: Any]()

        dict["camera_facing"] = HMSTrackExtension.getValueOfHMSCameraFacing(settings.cameraFacing)
        
        dict["video_codec"] = HMSTrackExtension.getValueOfHMSVideoCodec(settings.codec)
        
        dict["max_bit_rate"] = settings.maxBitrate
        
        dict["max_frame_rate"] = settings.maxFrameRate
        
        dict["track_description"] = settings.trackDescription
        
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
