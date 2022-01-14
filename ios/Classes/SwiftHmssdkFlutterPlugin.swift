
import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener, FlutterStreamHandler, HMSPreviewListener, HMSLogger {
    
    let channel: FlutterMethodChannel
    let meetingEventChannel: FlutterEventChannel
    let previewEventChannel: FlutterEventChannel
    let logsEventChannel: FlutterEventChannel
    
    var eventSink: FlutterEventSink?
    var previewSink: FlutterEventSink?
    var logsSink: FlutterEventSink?
    var roleChangeRequest: HMSRoleChangeRequest?
    
    internal var hmsSDK: HMSSDK?
    
    private var config: HMSConfig?
    
    
    // MARK: - Flutter Setup
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
        
        let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
        let previewChannel = FlutterEventChannel(name: "preview_event_channel", binaryMessenger: registrar.messenger())
        let logsChannel = FlutterEventChannel(name: "logs_event_channel", binaryMessenger: registrar.messenger())
        
        let instance = SwiftHmssdkFlutterPlugin(channel: channel,
                                                meetingEventChannel: eventChannel,
                                                previewEventChannel: previewChannel,
                                                logsEventChannel: logsChannel)
        
        let videoViewFactory = HMSFlutterPlatformViewFactory(plugin: instance)
        registrar.register(videoViewFactory, withId: "HMSFlutterPlatformView")
        
        eventChannel.setStreamHandler(instance)
        previewChannel.setStreamHandler(instance)
        logsChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public init(channel: FlutterMethodChannel,
                meetingEventChannel: FlutterEventChannel,
                previewEventChannel: FlutterEventChannel,
                logsEventChannel: FlutterEventChannel) {
        
        self.channel = channel
        self.meetingEventChannel = meetingEventChannel
        self.previewEventChannel = previewEventChannel
        self.logsEventChannel = logsEventChannel
    }
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        guard let tempArg = arguments as? [AnyHashable: Any],
              let name =  tempArg["name"] as? String else {
                  return FlutterError(code: #function, message: "invalid event sink name", details: arguments)
              }
        
        switch name {
        case "meeting":
            eventSink = events
        case "preview":
            previewSink = events
        case "logs":
            logsSink = events
        default:
            return FlutterError(code: #function, message: "invalid event sink name", details: arguments)
        }
        
        return nil
    }
    
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        previewSink = nil
        logsSink = nil
        return nil
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        meetingEventChannel.setStreamHandler(nil)
        previewEventChannel.setStreamHandler(nil)
        logsEventChannel.setStreamHandler(nil)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
            
            // MARK:  Room Actions
            
        case "build":
            build(call, result)
            
        case "preview":
            preview(call, result)
            
        case "join":
            join(call, result)
            
        case "leave":
            leave(result)
            
        case "get_room":
            getRoom(result)
            
        case "get_local_peer":
            getLocalPeer(result)
            
        case "get_remote_peers":
            getRemotePeers(result)
            
        case "get_peers":
            getPeers(result)
            
            // MARK: - Audio Helpers
            
        case "switch_audio":
            switchAudio(call, result)
            
        case "is_audio_mute":
            isAudioMute(call, result)
            
        case "mute_all":
            toggleAudioMuteAll(result, shouldMute: true)
            
        case "un_mute_all":
            toggleAudioMuteAll(result, shouldMute: false)
            
        case "set_volume":
            setVolume(call, result)
            
            // MARK: - Video Helpers
            
        case "switch_video":
            switchVideo(call, result)
            
        case "switch_camera":
            switchCamera(result)
            
        case "start_capturing":
            startCapturing(result)
            
        case "stop_capturing":
            stopCapturing(result)
            
        case "is_video_mute":
            isVideoMute(call, result)
            
        case "set_playback_allowed":
            setPlaybackAllowed(call, result)
            
            // MARK: - Messaging
            
        case "send_broadcast_message":
            sendBroadcastMessage(call, result)
            
        case "send_direct_message":
            sendDirectMessage(call, result)
            
        case "send_group_message":
            sendGroupMessage(call, result)
            
            // MARK: - Role based Actions
            
        case "get_roles":
            getRoles(call, result)
            
        case "change_role":
            changeRole(call, result)
            
        case "accept_change_role":
            acceptChangeRole(result)
            
        case "end_room":
            endRoom(call, result)
            
        case "remove_peer":
            removePeer(call, result)
            
        case "on_change_track_state_request":
            changeTrackState(call, result)
            
        case "change_track_state_for_role":
            changeTrackStateForRole(call, result)
            
        case "change_metadata":
            changeMetadata(call, result)
            
        case "change_name":
            changeName(call, result)
            
            // MARK: - Recording
            
        case "start_rtmp_or_recording":
            startRtmpOrRecording(call, result)
            
        case "stop_rtmp_and_recording":
            stopRtmpAndRecording(result)
            
            // MARK: - Logging
            
        case "start_hms_logger":
            startHMSLogger(call)
            
        case "remove_hms_logger":
            removeHMSLogger()
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    // MARK: - Room Actions
    
    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        var trackSettings: HMSTrackSettings?
        if let settingsDict = arguments["hms_track_setting"] as? [AnyHashable: Any] {
            
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
                                                          trackDescription: desc)
                }
            }
            
            trackSettings = HMSTrackSettings(videoSettings: videoSettings, audioSettings: audioSettings)
        }
        
        var setLogger = false
        if let level = arguments["log_level"] as? String {
            logLevel = getLogLevel(from: level)
            setLogger = true
        }
        
        hmsSDK = HMSSDK.build { sdk in
            
            if let settings = trackSettings {
                sdk.trackSettings = settings
            }
            
            if setLogger {
                sdk.logger = self
            }
            
            result(true)
        }
    }
    
    
    private func preview(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let authToken = arguments["auth_token"] as? String,
              let userName = arguments["user_name"] as? String
        else {
            let error = getError(message: "Could not show preview, invalid parameters passed", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let shouldSkipPIIEvents = arguments["should_skip_pii_events"] as? Bool ?? false
        let metaData = arguments["meta_data"] as? String
        
        if let endPoint = arguments["end_point"] as? String, !endPoint.isEmpty {
            config = HMSConfig(userName: userName, authToken: authToken, shouldSkipPIIEvents: shouldSkipPIIEvents, metadata: metaData, endpoint: endPoint)
        } else {
            config = HMSConfig(userName: userName, authToken: authToken, shouldSkipPIIEvents: shouldSkipPIIEvents, metadata: metaData)
        }
        
        hmsSDK?.preview(config: config!, delegate: self)
        
        result(nil)
    }
    
    
    /*
     private func previewForRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
     let arguments = call.arguments as! [AnyHashable: Any]
     
     hmsSDK?.preview(role: ) { ,  in
     
     }
     }
     
     private func cancelPreview(_ result: FlutterResult) {
     hmsSDK?.cancelPreview()
     result(nil)
     }
     */
    
    
    private func join(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        if let config = config {
            hmsSDK?.join(config: config, delegate: self)
        } else {
            
            guard let authToken = arguments["auth_token"] as? String,
                  let userName = arguments["user_name"] as? String
            else {
                let error = getError(message: "Could not join room, invalid parameters passed", params: ["function": #function, "arguments": arguments])
                result(HMSErrorExtension.toDictionary(error))
                return
            }
            
            let shouldSkipPIIEvents = arguments["should_skip_pii_events"] as? Bool ?? false
            let metaData = arguments["meta_data"] as? String
            
            if let endPoint = arguments["end_point"] as? String, !endPoint.isEmpty  {
                config = HMSConfig(userName: userName, authToken: authToken, shouldSkipPIIEvents: shouldSkipPIIEvents, metadata: metaData, endpoint: endPoint)
            } else {
                config = HMSConfig(userName: userName, authToken: authToken, shouldSkipPIIEvents: shouldSkipPIIEvents, metadata: metaData)
            }
            
            hmsSDK?.join(config: config!, delegate: self)
        }
        
        result(nil)
    }
    
    
    private func leave(_ result: @escaping FlutterResult) {
        hmsSDK?.leave { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    private func getRoom(_ result: FlutterResult) {
        
        guard let room = hmsSDK?.room else { result(nil); return }
        
        result(HMSRoomExtension.toDictionary(room))
    }
    
    
    private func getLocalPeer(_ result: FlutterResult) {
        
        guard let localPeer = hmsSDK?.localPeer else { result(nil); return }
        
        result(HMSPeerExtension.toDictionary(localPeer))
    }
    
    private func getRemotePeers(_ result: FlutterResult) {
        
        guard let peers = hmsSDK?.remotePeers else { result(nil); return }
        
        var listOfPeers = [[String: Any]]()
        peers.forEach { listOfPeers.append(HMSPeerExtension.toDictionary($0)) }
        result(listOfPeers)
    }
    
    private func getPeers(_ result: FlutterResult) {
        
        guard let peers = hmsSDK?.room?.peers else { result(nil); return }
        
        var listOfPeers = [[String: Any]]()
        peers.forEach { listOfPeers.append(HMSPeerExtension.toDictionary($0)) }
        result(listOfPeers)
    }
    
    
    // MARK: - Audio Helpers
    
    private func switchAudio(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let shouldMute = arguments["is_on"] as? Bool,
              let peer = hmsSDK?.localPeer,
              let audio = peer.audioTrack as? HMSLocalAudioTrack else {
                  result(false)
                  return
              }
        
        audio.setMute(shouldMute)
        
        result(true)
    }
    
    
    private func isAudioMute(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        if let peerID = arguments["peer_id"] as? String, let peer = getPeer(by: peerID) {
            if let audio = peer.audioTrack {
                result(audio.isMute())
                return
            }
        } else {
            if let peer = hmsSDK?.localPeer, let audio = peer.audioTrack {
                result(audio.isMute())
                return
            }
        }
        
        result(false)
    }
    
    
    private func toggleAudioMuteAll(_ result: FlutterResult, shouldMute: Bool) {
        
        hmsSDK?.remotePeers?.forEach { peer in
            if let audio = peer.remoteAudioTrack() {
                audio.setPlaybackAllowed(!shouldMute)
            }
            peer.auxiliaryTracks?.forEach { track in
                if let audio = track as? HMSRemoteAudioTrack {
                    audio.setPlaybackAllowed(!shouldMute)
                }
            }
        }
        
        result(nil)
    }

    
    private func setVolume(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let volume = arguments["volume"] as? Double,
              let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getTrack(for: trackID, in: hmsSDK!.room!)
        else {
            let error = getError(message: "Invalid arguments passed in \(#function)",
                                 description: "Message is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        if let remoteAudio = track as? HMSRemoteAudioTrack {
            remoteAudio.setVolume(volume)
            result(nil)
            return
        }
        
        let error = getError(message: "Invalid arguments passed in \(#function)",
                             params: ["function": #function, "arguments": arguments])
        result(HMSErrorExtension.toDictionary(error))
    }
    
    
    // MARK: - Video Helpers
    
    private func startCapturing(_ result: FlutterResult) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }
        
        track.startCapturing()
        
        result(true)
    }
    
    private func stopCapturing(_ result: FlutterResult) {
        guard let peer = hmsSDK?.localPeer,
              let track = peer.videoTrack as? HMSLocalVideoTrack
        else {
            result(false)
            return
        }
        
        track.stopCapturing()
        
        result(true)
    }
    
    private func switchCamera(_ result: FlutterResult) {
        guard let peer = hmsSDK?.localPeer,
              let videoTrack = peer.videoTrack as? HMSLocalVideoTrack
        else {
            let error = getError(message: "Local Peer not found", params: ["function": #function])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        videoTrack.switchCamera()
        
        result(nil)
    }
    
    private func switchVideo(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let shouldMute = arguments["is_on"] as? Bool,
              let peer = hmsSDK?.localPeer,
              let video = peer.videoTrack as? HMSLocalVideoTrack else {
                  result(false)
                  return
              }
        
        video.setMute(shouldMute)
        
        result(true)
    }
    
    private func isVideoMute(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        if let peerID = arguments["peer_id"] as? String, let peer = getPeer(by: peerID) {
            if let video = peer.videoTrack {
                result(video.isMute())
                return
            }
        } else {
            if let peer = hmsSDK?.localPeer, let video = peer.videoTrack {
                result(video.isMute())
                return
            }
        }
        
        result(false)
    }
    
    
    private func setPlaybackAllowed(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        let allowed = arguments["allowed"] as! Bool
        
        
        if let localPeer = hmsSDK?.localPeer {
            if let video = localPeer.videoTrack as? HMSLocalVideoTrack {
                video.setMute(!allowed)
            }
        }
        
        if let remotePeers = hmsSDK?.remotePeers {
            remotePeers.forEach { peer in
                if let video = peer.remoteVideoTrack() {
                    video.setPlaybackAllowed(allowed)
                }
                peer.auxiliaryTracks?.forEach { track in
                    if let video = track as? HMSRemoteVideoTrack {
                        video.setPlaybackAllowed(allowed)
                    }
                }
            }
        }
        
        result(nil)
    }
    
    
    // MARK: - Messaging
    
    private func sendBroadcastMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String
        else {
            let error = getError(message: "No message found in \(#function)",
                                 description: "Message is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendBroadcastMessage(type: type, message: message) { message, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    private func sendDirectMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String,
              let peerID = arguments["peer_id"] as? String,
              let peer = getPeer(by: peerID)
        else {
            let error = getError(message: "Invalid arguments passed in \(#function)",
                                 description: "Message is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendDirectMessage(type: type, message: message, peer: peer) { message, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    private func sendGroupMessage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let message = arguments["message"] as? String,
              let roleString = arguments["role_name"] as? String,
              let role = getRole(by: roleString)
        else {
            let error = getError(message: "Invalid arguments passed in \(#function)",
                                 description: "Message is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let type = arguments["type"] as? String ?? "chat"
        
        hmsSDK?.sendGroupMessage(type: type, message: message, roles: [role]) { message, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    // MARK: - Role based Actions
    
    private func getRoles(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        var roles = [[String: Any]]()
        
        hmsSDK?.roles.forEach { roles.append(HMSRoleExtension.toDictionary($0)) }
        
        result(["roles": roles])
    }
    
    
    private func changeRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let peerID = arguments["peer_id"] as? String,
              let peer = getPeer(by: peerID),
              let roleString = arguments["role_name"] as? String,
              let role = getRole(by: roleString)
        else {
            let error = getError(message: "Invalid parameters for change role", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let force = arguments["force_change"] as? Bool ?? false
        
        hmsSDK?.changeRole(for: peer, to: role, force: force) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    private func acceptChangeRole(_ result: @escaping FlutterResult) {
        
        hmsSDK?.accept(changeRole: roleChangeRequest!) { [weak self] success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                self?.roleChangeRequest = nil
                result(nil)
            }
        }
    }
    
    
    private func endRoom(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        let lock = arguments["lock"] as? Bool ?? false
        let reason = arguments["reason"] as? String ?? "End room invoked"
        
        hmsSDK?.endRoom(lock: lock, reason: reason) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    private func removePeer(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let peerID = arguments["peer_id"] as? String,
              let peer = getPeer(by: peerID)
        else {
            let error = getError(message: "Peer not found", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let reason = (arguments["reason"] as? String) ?? "Removed from room"
        
        hmsSDK?.removePeer(peer, reason: reason) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    private func changeTrackState(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let peerID = arguments["hms_peer_id"] as? String,
              let peer = getPeer(by: peerID)
        else {
            let error = getError(message: "Could not find peer to change track",
                                 description: "Could not find peer from peerID",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let muteVideoKind = arguments["mute_video_kind"] as? Bool ?? false
        
        let track: HMSTrack?
        if muteVideoKind {
            track = peer.videoTrack
        } else {
            track = peer.audioTrack
        }
        
        guard let track = track else {
            let error = getError(message: "Could not find track for peer: \(peer.name)",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let mute = arguments["mute"] as? Bool ?? false
        
        hmsSDK?.changeTrackState(for: track, mute: mute) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
                return
            }
            result(nil)
        }
    }
    
    private func changeTrackStateForRole(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let mute = arguments["mute"] as? Bool else {
            let error = getError(message: "Mute status to be set not found",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        var trackKind: HMSTrackKind?
        if let kindStr = arguments["type"] as? String {
            trackKind = kind(from: kindStr)
        }
        
        let source = arguments["source"] as? String
        
        var roles: [HMSRole]?
        if let rolesString = arguments["roles"] as? [String] {
            roles = hmsSDK?.roles.filter { rolesString.contains($0.name) }
        }
        
        hmsSDK?.changeTrackState(mute: mute, for: trackKind, source: source, roles: roles) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    private var hasChangedMetadata = false
    
    private func changeMetadata(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let metadata = arguments["metadata"] as? String else {
            let error = getError(message: "No metadata found in \(#function)",
                                 description: "Metadata is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        hmsSDK?.change(metadata: metadata) { [weak self] success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
                return
            } else {
                if let strongSelf = self {
                    strongSelf.hasChangedMetadata = !strongSelf.hasChangedMetadata
                }
                result(nil)
            }
        }
    }
    
    
    private func changeName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as![AnyHashable:Any]
        
        guard let name = arguments["name"] as? String else {
            let error = getError(message: "No name found in \(#function)",
                                 description: "Name is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        hmsSDK?.change(name: name) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    // MARK: - Recording
    
    private func startRtmpOrRecording(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let record = arguments["to_record"] as? Bool else {
            let error = getError(message: "Record boolean not found", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        var meetingURL: URL?
        if let meetingURLStr = arguments["meeting_url"] as? String {
            meetingURL = URL(string: meetingURLStr)
        }
        
        var rtmpURLs: [URL]?
        if let strings = arguments["rtmp_urls"] as? [String] {
            for string in strings {
                if let url = URL(string: string) {
                    if rtmpURLs == nil {
                        rtmpURLs = [URL]()
                    }
                    rtmpURLs?.append(url)
                }
            }
        }
        
        
        let config = HMSRTMPConfig(meetingURL: meetingURL, rtmpURLs: rtmpURLs, record: record)
        
        hmsSDK?.startRTMPOrRecording(config: config) { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    private func stopRtmpAndRecording(_ result: @escaping FlutterResult) {
        hmsSDK?.stopRTMPAndRecording { success, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    
    // MARK: - Logging
    
    private var logLevel = HMSLogLevel.off
    
    private func startHMSLogger(_ call: FlutterMethodCall) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let level = arguments["log_level"] as? String else {
            print(#function, "Could not find `log_level` argument")
            return
        }
        
        logLevel = getLogLevel(from: level)
        
        hmsSDK?.logger = self
    }
    
    private func getLogLevel(from level: String) -> HMSLogLevel {
        switch level {
        case "verbose":
            return .verbose
        case "warning":
            return .warning
        case "error":
            return .error
        case "off":
            return .off
        default:
            return .off
        }
    }
    
    public func log(_ message: String, _ level: HMSLogLevel) {
        guard level.rawValue <= logLevel.rawValue else { return }
        
        var args = [String: Any]()
        args["event_name"] = "on_logs_update"
        
        var logArgs = [String: Any]()
        logArgs["log"] = ["message": message, "level": level.rawValue]
        
        args["data"] = logArgs
        
        logsSink?(args)
    }
    
    private func removeHMSLogger() {
        logLevel = .off
        hmsSDK?.logger = nil
    }
    
    
    // MARK: - 100ms SDK Delegate Callbacks
    
    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        
        var tracks = [[String: Any]]()
        localTracks.forEach { tracks.append(HMSTrackExtension.toDictionary($0)) }
        
        let data = [
            "event_name": "preview_video",
            "data": [
                "room": HMSRoomExtension.toDictionary(room),
                "local_tracks": tracks
            ]
        ] as [String: Any]
        
        previewSink?(data)
    }
    
    public func on(join room: HMSRoom) {
        
        previewEventChannel.setStreamHandler(nil)
        
        let data = [
            "event_name": "on_join_room",
            "data": [
                "room" : HMSRoomExtension.toDictionary(room)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        
        let data = [
            "event_name": "on_room_update",
            "data": [
                "room": HMSRoomExtension.toDictionary(room),
                "update": HMSRoomExtension.getValueOf(update)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        
        let data = [
            "event_name": "on_peer_update",
            "data":[
                "peer": HMSPeerExtension.toDictionary(peer),
                "update": HMSPeerExtension.getValueOf(update)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        
        let data = [
            "event_name": "on_track_update",
            "data": [
                "peer": HMSPeerExtension.toDictionary(peer),
                "track": HMSTrackExtension.toDictionary(track),
                "update": HMSTrackExtension.getValueOf(update)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(error: HMSError) {
        
        let data = [
            "event_name": "on_error",
            "data": HMSErrorExtension.toDictionary(error)
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(updated speakers: [HMSSpeaker]) {
        
        logSpeakers(speakers)
        
        var speakersDict = [[String: Any]]()
        speakers.forEach { speakersDict.append(HMSSpeakerExtension.toDictionary($0)) }
        
        let data = [
            "event_name": "on_update_speaker",
            "data": [
                "speakers": speakersDict
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(message: HMSMessage) {
        
        let data = [
            "event_name": "on_message",
            "data": [
                "message": HMSMessageExtension.toDictionary(message)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(roleChangeRequest: HMSRoleChangeRequest) {
        
        self.roleChangeRequest = roleChangeRequest
        
        var dict = ["event_name": "on_role_change_request"] as [String: Any]
        var request = ["suggested_role": HMSRoleExtension.toDictionary(roleChangeRequest.suggestedRole)] as [String: Any]
        
        if let peer = roleChangeRequest.requestedBy {
            request["requested_by"] = HMSPeerExtension.toDictionary(peer)
        }
        
        dict["data"] = ["role_change_request": request]
        
        eventSink?(dict)
    }
    
    
    public func on(changeTrackStateRequest: HMSChangeTrackStateRequest) {
        
        let data = [
            "event_name": "on_change_track_state_request",
            "data": [
                "track_change_request": HMSChangeTrackStateRequestExtension.toDictionary(changeTrackStateRequest)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    
    public func on(removedFromRoom notification: HMSRemovedFromRoomNotification) {
        
        let data = [
            "event_name": "on_removed_from_room",
            "data": [
                "removed_from_room": HMSRemovedFromRoomExtension.toDictionary(notification)
            ]
        ] as [String: Any]
        
        eventSink?(data)
    }
    
    public func onReconnecting() {
        let data = [ "event_name": "on_re_connecting" ]
        eventSink?(data)
    }
    
    public func onReconnected() {
        let data = [ "event_name": "on_re_connected" ]
        eventSink?(data)
    }
    
    
    // MARK: - Helper Functions
    
    private func getError(message: String, description: String? = nil, params: [String: Any]) -> HMSError {
        HMSError(id: "NONE",
                 code: .genericErrorJsonParsingFailed,
                 message: message,
                 info: description,
                 params: params)
    }
    
    private func logSpeakers(_ speakers: [HMSSpeaker]) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let dateString = "\(hour):\(minutes):\(second)"
        
        // print(#function, "Speaker update " + dateString, speakers.map { $0.peer.name },
        //       speakers.map { kindString(from: $0.track.kind) },
        //       speakers.map { $0.track.source })
    }
    
    internal func getPeer(by peerID: String) -> HMSPeer? {
        hmsSDK?.room?.peers.first { $0.peerID == peerID }
    }
    
    private func getRole(by name: String) -> HMSRole? {
        hmsSDK?.roles.first { $0.name == name }
    }
    
    private func kindString(from kind: HMSTrackKind) -> String {
        switch kind {
        case .audio:
            return "KHmsTrackAudio"
        case .video:
            return "KHmsTrackVideo"
        default:
            return "Unknown Kind"
        }
    }
    
    private func kind(from string: String) -> HMSTrackKind {
        switch string {
        case "KHmsTrackAudio":
            return .audio
        case "KHmsTrackVideo":
            return .video
        default:
            return .audio
        }
    }
    
    private func getCodec(from string: String) -> HMSCodec {
        if string.lowercased().contains("h264") {
            return HMSCodec.H264
        }
        return HMSCodec.VP8
    }
    
    
}
