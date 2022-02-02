//
//  HMSPeerExtension.swift
//  hmssdk_flutter
//
//  Copyright © 2021 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class  HMSPeerExtension {

    static func toDictionary(_ peer: HMSPeer) -> [String: Any] {

        var dict = [
            "peer_id": peer.peerID,
            "name": peer.name,
            "is_local": peer.isLocal,
            "customer_description": peer.metadata ?? "",
            "customer_user_id": peer.customerUserID ?? ""
        ] as [String: Any]

        if let metadata = peer.metadata {
            dict["metadata"] = metadata
        }
        if let role = peer.role {
            dict["role"] = HMSRoleExtension.toDictionary(role)
        }

        if let audioTrack = peer.audioTrack {
            dict["audio_track"] = HMSTrackExtension.toDictionary(audioTrack)
        }

        if let videoTrack = peer.videoTrack {
            dict["video_track"] = HMSTrackExtension.toDictionary(videoTrack)
        }

        if let aux = peer.auxiliaryTracks {
            var auxilaryTracks = [[String: Any]]()
            aux.forEach { auxilaryTracks.append(HMSTrackExtension.toDictionary($0)) }
            dict["auxilary_tracks"] = auxilaryTracks
        }

        return dict
    }

    static func getValueOf(_ update: HMSPeerUpdate) -> String {
        switch update {
        case .peerJoined:
            return "peerJoined"
        case .peerLeft:
            return "peerLeft"
        case .roleUpdated:
            return "roleUpdated"
        case .defaultUpdate:
            return "defaultUpdate"
        case .nameUpdated:
            return "nameChanged"
        case .metadataUpdated:
            return "metadataChanged"
        @unknown default:
            return "defaultUpdate"
        }
    }
}
