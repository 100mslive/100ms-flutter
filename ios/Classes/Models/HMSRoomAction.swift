//
//  HMSRoom.swift
//  hmssdk_flutter
//
//  Created by govind on 03/02/22.
//

import Foundation
import HMSSDK

class HMSRoomAction {
    static func roomActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult, _ hmsSDK: HMSSDK?) {
        switch call.method {
            
        case "get_room":
            getRoom(result, hmsSDK)
            
        case "get_local_peer":
            getLocalPeer(result, hmsSDK)
            
        case "get_remote_peers":
            getRemotePeers(result, hmsSDK)
            
        case "get_peers":
            getPeers(result, hmsSDK)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    static private func getRoom(_ result: FlutterResult, _ hmsSDK: HMSSDK?) {
        
        guard let room = hmsSDK?.room else { result(nil); return }
        
        result(HMSRoomExtension.toDictionary(room))
    }
    
    static private func getLocalPeer(_ result: FlutterResult, _ hmsSDK: HMSSDK?) {
        
        guard let localPeer = hmsSDK?.localPeer else { result(nil); return }
        
        result(HMSPeerExtension.toDictionary(localPeer))
    }
    
    static private func getRemotePeers(_ result: FlutterResult, _ hmsSDK: HMSSDK?) {
        
        guard let peers = hmsSDK?.remotePeers else { result(nil); return }
        
        var listOfPeers = [[String: Any]]()
        peers.forEach { listOfPeers.append(HMSPeerExtension.toDictionary($0)) }
        result(listOfPeers)
    }
    
    static private func getPeers(_ result: FlutterResult, _ hmsSDK: HMSSDK?) {
        
        guard let peers = hmsSDK?.room?.peers else { result(nil); return }
        
        var listOfPeers = [[String: Any]]()
        peers.forEach { listOfPeers.append(HMSPeerExtension.toDictionary($0)) }
        result(listOfPeers)
    }
}
