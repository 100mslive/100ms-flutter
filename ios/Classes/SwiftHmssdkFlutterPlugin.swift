
import Flutter
import UIKit
import HMSSDK
import ReplayKit

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener, FlutterStreamHandler, HMSPreviewListener, HMSLogger {
    
    let channel: FlutterMethodChannel
    let meetingEventChannel: FlutterEventChannel
    let previewEventChannel: FlutterEventChannel
    let logsEventChannel: FlutterEventChannel
    let rtcStatsEventChannel: FlutterEventChannel
    
    var eventSink: FlutterEventSink?
    var previewSink: FlutterEventSink?
    var logsSink: FlutterEventSink?
    var rtcSink: FlutterEventSink?
    var roleChangeRequest: HMSRoleChangeRequest?
    
    internal var hmsSDK: HMSSDK?
    
    private var isStatsActive = false
    
    // MARK: - Flutter Setup
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
        
        let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
        let previewChannel = FlutterEventChannel(name: "preview_event_channel", binaryMessenger: registrar.messenger())
        let logsChannel = FlutterEventChannel(name: "logs_event_channel", binaryMessenger: registrar.messenger())
        let rtcChannel = FlutterEventChannel(name: "rtc_event_channel", binaryMessenger: registrar.messenger())
        
        let instance = SwiftHmssdkFlutterPlugin(channel: channel,
                                                meetingEventChannel: eventChannel,
                                                previewEventChannel: previewChannel,
                                                logsEventChannel: logsChannel,
                                                rtcStatsEventChannel: rtcChannel)
        
        let videoViewFactory = HMSFlutterPlatformViewFactory(plugin: instance)
        registrar.register(videoViewFactory, withId: "HMSFlutterPlatformView")
        
        
        eventChannel.setStreamHandler(instance)
        previewChannel.setStreamHandler(instance)
        logsChannel.setStreamHandler(instance)
        rtcChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(channel: FlutterMethodChannel,
                meetingEventChannel: FlutterEventChannel,
                previewEventChannel: FlutterEventChannel,
                logsEventChannel: FlutterEventChannel,
                rtcStatsEventChannel: FlutterEventChannel
    ) {
        
        self.channel = channel
        self.meetingEventChannel = meetingEventChannel
        self.previewEventChannel = previewEventChannel
        self.logsEventChannel = logsEventChannel
        self.rtcStatsEventChannel = rtcStatsEventChannel
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
        case "rtc_stats":
            rtcSink = events
        default:
            return FlutterError(code: #function, message: "invalid event sink name", details: arguments)
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        previewSink = nil
        logsSink = nil
        rtcSink = nil
        return nil
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        meetingEventChannel.setStreamHandler(nil)
        previewEventChannel.setStreamHandler(nil)
        logsEventChannel.setStreamHandler(nil)
        rtcStatsEventChannel.setStreamHandler(nil)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        switch call.method {
            
            // MARK: Room Actions
            
        case "build", "preview", "join", "leave":
            buildActions(call, result)
            
            // MARK: Room Actions
            
        case "get_room", "get_local_peer", "get_remote_peers", "get_peers":
            HMSRoomAction.roomActions(call, result, hmsSDK)
            
            // MARK: - Audio Helpers
            
        case "switch_audio", "is_audio_mute", "mute_all", "un_mute_all", "set_volume":
            HMSAudioAction.audioActions(call, result, hmsSDK)
            
            // MARK: - Video Helpers
            
        case "switch_video", "switch_camera", "start_capturing", "stop_capturing", "is_video_mute", "set_playback_allowed":
            HMSVideoAction.videoActions(call, result, hmsSDK)
            
            // MARK: - Messaging
            
        case "send_broadcast_message", "send_direct_message", "send_group_message":
            HMSMessageAction.messageActions(call, result, hmsSDK)
            
            // MARK: - Role based Actions
            
        case "get_roles", "change_role", "accept_change_role", "end_room", "remove_peer", "on_change_track_state_request", "change_track_state_for_role":
            roleActions(call, result)
            
            // MARK: - Peer Action
        case "change_metadata", "change_name":
            peerActions(call, result)
            
            // MARK: - RTMP
            
        case "start_rtmp_or_recording", "stop_rtmp_and_recording":
            HMSRecordingAction.recordingActions(call, result, hmsSDK)
            
            // MARK: - HLS
            
        case "hls_start_streaming", "hls_stop_streaming":
            HMSHLSAction.hlsActions(call, result, hmsSDK)
            
            // MARK: - Logging
            
        case "start_hms_logger", "remove_hms_logger":
            loggingActions(call, result)
            
            // MARK: - Stats Listener
            
        case "start_stats_listener", "remove_stats_listener":
            statsListenerAction(call, result)
            
            // MARK: - Screen Share
            
        case "start_screen_share", "stop_screen_share", "is_screen_share_active":
            screenShareActions(call, result)
            
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Build Actions
    private func buildActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "build":
            build(call, result)
            
        case "preview":
            preview(call, result)
            
        case "join":
            join(call, result)
            
        case "leave":
            leave(result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Role based Actions
    private func roleActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
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
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    // MARK: - Peer Actions
    
    private func peerActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "change_metadata":
            changeMetadata(call, result)
            
        case "change_name":
            changeName(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Logging
    private func loggingActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "start_hms_logger":
            startHMSLogger(call)
            
        case "remove_hms_logger":
            removeHMSLogger()
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Stats Listener
    
    private func statsListenerAction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
            
        case "start_stats_listener":
            isStatsActive = true
            
        case "remove_stats_listener":
            isStatsActive = false
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Screen Share
    var isScreenShareOn = false {
        didSet {
            screenShareActionResult?(nil)
            screenShareActionResult = nil
        }
    }
    var preferredExtension: String?
    var systemBroadcastPicker: RPSystemBroadcastPickerView?
    var screenShareActionResult: FlutterResult?
    
    private func screenShareActions(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {

        switch call.method {
        case "start_screen_share", "stop_screen_share":
            guard let preferredExtension = preferredExtension else {
                let error = getError(message: "Could not start Screen share, preferredExtension not passed in Build Method", params: ["function": #function])
                result(HMSErrorExtension.toDictionary(error))
                screenShareActionResult = nil
                return
            }
            
            screenShareActionResult = result
            
            if systemBroadcastPicker == nil {
                systemBroadcastPicker = RPSystemBroadcastPickerView()
                systemBroadcastPicker!.preferredExtension = preferredExtension
                systemBroadcastPicker!.showsMicrophoneButton = false
            }
            
            for view in systemBroadcastPicker!.subviews {
                if let button = view as? UIButton {
                    button.sendActions(for: .allEvents)
                }
            }
            
        case "is_screen_share_active":
            result(isScreenShareOn)
        default:
            print("Not Valid")
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
                                                          trackDescription: desc,
                                                          videoPlugins: nil)
                }
            }
            
            trackSettings = HMSTrackSettings(videoSettings: videoSettings, audioSettings: audioSettings)
        }
        
        if let prefExtension = arguments["preferred_extension"] as? String {
            preferredExtension = prefExtension
        }
        
        
        var setLogger = false
        if let level = arguments["log_level"] as? String {
            logLevel = getLogLevel(from: level)
            setLogger = true
        }
        
        hmsSDK = HMSSDK.build { sdk in
            
            if let appGroup = arguments["app_group"] as? String {
                sdk.appGroup = appGroup
            }
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
        
        guard let config = getConfig(from: arguments) else {
            let error = getError(message: "Could not join room, invalid parameters passed", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        hmsSDK?.preview(config: config, delegate: self)
        
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
        
        guard let config = getConfig(from: arguments) else {
            let error = getError(message: "Could not join room, invalid parameters passed", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        hmsSDK?.join(config: config, delegate: self)
        
        result(nil)
    }
    
    private func leave(_ result: @escaping FlutterResult) {
        hmsSDK?.leave { _, error in
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
              let peer = HMSCommonAction.getPeer(by: peerID,hmsSDK:hmsSDK),
              let roleString = arguments["role_name"] as? String,
              let role = HMSCommonAction.getRole(by: roleString,hmsSDK: hmsSDK)
        else {
            let error = getError(message: "Invalid parameters for change role", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let force = arguments["force_change"] as? Bool ?? false
        
        hmsSDK?.changeRole(for: peer, to: role, force: force) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    private func acceptChangeRole(_ result: @escaping FlutterResult) {
        
        hmsSDK?.accept(changeRole: roleChangeRequest!) { [weak self] _, error in
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
        
        hmsSDK?.endRoom(lock: lock, reason: reason) { _, error in
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
              let peer = HMSCommonAction.getPeer(by: peerID,hmsSDK: hmsSDK)
        else {
            let error = getError(message: "Peer not found", params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let reason = (arguments["reason"] as? String) ?? "Removed from room"
        
        hmsSDK?.removePeer(peer, reason: reason) { _, error in
            if let error = error {
                result(HMSErrorExtension.toDictionary(error))
            } else {
                result(nil)
            }
        }
    }
    
    private func changeTrackState(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let arguments = call.arguments as! [AnyHashable: Any]
        
        guard let trackID = arguments["track_id"] as? String,
              let track = HMSUtilities.getTrack(for: trackID, in: hmsSDK!.room!)
        else {
            let error = getError(message: "Could not find track to change track",
                                 description: "Could not find track from trackID",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        let mute = arguments["mute"] as? Bool ?? false
        
        hmsSDK?.changeTrackState(for: track, mute: mute) { _, error in
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
        
        hmsSDK?.changeTrackState(mute: mute, for: trackKind, source: source, roles: roles) { _, error in
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
        
        hmsSDK?.change(metadata: metadata) { [weak self] _, error in
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
        
        let arguments = call.arguments as![AnyHashable: Any]
        
        guard let name = arguments["name"] as? String else {
            let error = getError(message: "No name found in \(#function)",
                                 description: "Name is nil",
                                 params: ["function": #function, "arguments": arguments])
            result(HMSErrorExtension.toDictionary(error))
            return
        }
        
        hmsSDK?.change(name: name) { _, error in
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
                "room": HMSRoomExtension.toDictionary(room)
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
        
        previewSink?(data)
        eventSink?(data)
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        
        let data = [
            "event_name": "on_peer_update",
            "data": [
                "peer": HMSPeerExtension.toDictionary(peer),
                "update": HMSPeerExtension.getValueOf(update)
            ]
        ] as [String: Any]
        
        previewSink?(data)
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
        if peer.isLocal && track.source.uppercased() == "SCREEN" {
            if update == .trackAdded {
                isScreenShareOn = true
            }else if update == .trackRemoved {
                isScreenShareOn = false
            }
        }
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
    
    
    // MARK: - RTC Stats Listeners
    
    public func on(localAudioStats: HMSLocalAudioStats, track: HMSLocalAudioTrack, peer: HMSPeer) {
        if(isStatsActive){
            let data = [
                "event_name": "on_local_audio_stats",
                "data": [
                    "local_audio_stats": HMSStatsExtension.toDictionary(localAudioStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]
            
            rtcSink?(data)
        }
    }
    
    public func on(localVideoStats: HMSLocalVideoStats, track: HMSLocalVideoTrack, peer: HMSPeer) {
        if(isStatsActive){
            let data = [
                "event_name": "on_local_video_stats",
                "data": [
                    "local_video_stats": HMSStatsExtension.toDictionary(localVideoStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]
            
            rtcSink?(data)
        }
    }
    
    public func on(remoteAudioStats: HMSRemoteAudioStats, track: HMSRemoteAudioTrack, peer: HMSPeer) {
        if(isStatsActive){
            let data = [
                "event_name": "on_remote_audio_stats",
                "data": [
                    "remote_audio_stats": HMSStatsExtension.toDictionary(remoteAudioStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]
            
            rtcSink?(data)
        }
    }
    
    public func on(remoteVideoStats: HMSRemoteVideoStats, track: HMSRemoteVideoTrack, peer: HMSPeer) {
        if(isStatsActive){
            let data = [
                "event_name": "on_remote_video_stats",
                "data": [
                    "remote_video_stats": HMSStatsExtension.toDictionary(remoteVideoStats),
                    "track": HMSTrackExtension.toDictionary(track),
                    "peer": HMSPeerExtension.toDictionary(peer)
                ]
            ] as [String: Any]
            
            rtcSink?(data)
        }
    }
    
    public func on(rtcStats: HMSRTCStatsReport) {
        if(isStatsActive){
            let data = [
                "event_name": "on_rtc_stats_report",
                "data": [
                    "rtc_stats_report": HMSStatsExtension.toDictionary(rtcStats)
                ]
            ] as [String: Any]
            
            rtcSink?(data)
        }
    }
    
    // MARK: - Helper Functions
    
    private func getConfig(from arguments: [AnyHashable: Any]) -> HMSConfig? {
        guard let authToken = arguments["auth_token"] as? String,
              let userName = arguments["user_name"] as? String
        else {
            return nil
        }
        
        let shouldSkipPIIEvents = arguments["should_skip_pii_events"] as? Bool ?? false
        let captureNetworkQualityInPreview = arguments["capture_network_quality_in_preview"] as? Bool ?? false
        let metaData = arguments["meta_data"] as? String
        
        var endPoint: String?
        if let endPointStr = arguments["end_point"] as? String, !endPointStr.isEmpty {
            endPoint = endPointStr
        }
        
        return HMSConfig(userName: userName,
                         authToken: authToken,
                         shouldSkipPIIEvents: shouldSkipPIIEvents,
                         metadata: metaData,
                         endpoint: endPoint,
                         captureNetworkQualityInPreview: captureNetworkQualityInPreview)
    }
    
    private func getError(message: String, description: String? = nil, params: [String: Any]) -> HMSError {
        HMSError(id: "NONE",
                 code: .genericErrorJsonParsingFailed,
                 message: message,
                 info: description,
                 params: params)
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
