//
//  HMSRoomExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSRoomExtension {

    static func toDictionary(_ room: HMSRoom) -> [String: Any] {

        var dict = [String: Any]()

        if let roomID = room.roomID {
            dict["id"] = roomID
        }

        if let name = room.name {
            dict["name"] = name
        }

        if let data = room.metaData {
            dict["meta_data"] = data
        }

        if let sessionId = room.sessionID {
            dict["session_id"] = sessionId
        }

        if let peerCount = room.peerCount {
            dict["peer_count"] = peerCount
        }

        var peers = [[String: Any]]()
        room.peers.forEach { peers.append(HMSPeerExtension.toDictionary($0)) }
        dict["peers"] = peers

        dict["rtmp_streaming_state"] = HMSStreamingStateExtension.toDictionary(rtmp: room.rtmpStreamingState)

        dict["browser_recording_state"] = HMSStreamingStateExtension.toDictionary(browser: room.browserRecordingState)

        dict["server_recording_state"] = HMSStreamingStateExtension.toDictionary(server: room.serverRecordingState)

        dict["hls_streaming_state"] = HMSStreamingStateExtension.toDictionary(hlsStreaming: room.hlsStreamingState)

        dict["hls_recording_state"] = HMSStreamingStateExtension.toDictionary(hlsRecording: room.hlsRecordingState)

        return dict
    }

    static func getValueOf(_ update: HMSRoomUpdate) -> String {
        switch update {
        case .roomTypeChanged:
            return "room_type_changed"
        case .browserRecordingStateUpdated:
            return "browser_recording_state_updated"
        case .rtmpStreamingStateUpdated:
            return "rtmp_streaming_state_updated"
        case .serverRecordingStateUpdated:
            return "server_recording_state_updated"
        case .hlsStreamingStateUpdated:
            return "hls_streaming_state_updated"
        case .hlsRecordingStateUpdated:
            return "hls_recording_state_updated"
        case .metaDataUpdated:
            return "room_peer_count_updated"
        default:
            return "unknown_update"
        }
    }
}
