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
            "type": getPeerType(peer.type),
            "is_hand_raised": peer.isHandRaised,
            "customer_description": peer.metadata ?? "",
            "customer_user_id": peer.customerUserID ?? "",
            "joined_at": Int(peer.joinedAt.timeIntervalSince1970 * 1000),
            "updated_at": Int(peer.updatedAt.timeIntervalSince1970 * 1000)
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

        if let quality = peer.networkQuality {
            dict["network_quality"] = HMSNetworkQualityExtension.toDictionary(quality)
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
        case .networkQualityUpdated:
            return "networkQualityUpdated"
        case .handRaiseUpdated:
            return "handRaiseUpdated"
        @unknown default:
            return "defaultUpdate"
        }
    }

    private static func getPeerType(_ peerType: HMSPeerType) -> String {
        switch peerType {
        case .sip:
            return "sip"
        case .regular:
            return "regular"
        @unknown default:
            return "regular"
        }
    }
}
