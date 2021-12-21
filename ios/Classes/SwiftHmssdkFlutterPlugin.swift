
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
    
    
    // MARK: - Initial Setup
    
    public init(channel: FlutterMethodChannel,
                meetingEventChannel: FlutterEventChannel,
                previewEventChannel: FlutterEventChannel,
                logsEventChannel: FlutterEventChannel) {
        
        self.channel = channel
        self.meetingEventChannel = meetingEventChannel
        self.previewEventChannel = previewEventChannel
        self.logsEventChannel = logsEventChannel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
        let previewChannel = FlutterEventChannel(name: "preview_event_channel", binaryMessenger: registrar.messenger())
        let logsChannel = FlutterEventChannel(name: "logs_event_channel", binaryMessenger: registrar.messenger())
        
        let instance = SwiftHmssdkFlutterPlugin(channel: channel,
                                                meetingEventChannel: eventChannel,
                                                previewEventChannel: previewChannel,
                                                logsEventChannel: logsChannel)
        
        let videoViewFactory:HMSVideoViewFactory = HMSVideoViewFactory(messenger: registrar.messenger(),plugin: instance)
        registrar.register(videoViewFactory, withId: "HMSVideoView")
        
        eventChannel.setStreamHandler(instance)
        previewChannel.setStreamHandler(instance)
        logsChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
        case "join_meeting":
            joinMeeting(call, result)
            
        case "leave_meeting":
            leaveMeeting(result)
            
        case "switch_audio":
            switchAudio(call, result)
            
        case "switch_video":
            switchVideo(call, result)
            
        case "switch_camera":
            switchCamera(result)
            
        case "preview_video":
            preview(call, result)
            
        case "send_message":
            sendBroadcastMessage(call, result)
            
        case "send_direct_message":
            sendDirectMessage(call, result)
            
        case "send_group_message":
            sendGroupMessage(call, result)
            
        case "accept_role_change":
            acceptRoleRequest(call, result)
            
        case "change_role":
            changeRole(call, result)
            
        case "get_roles":
            getRoles(call, result)
            
        case "start_capturing":
            unMuteVideo()
            
        case "stop_capturing":
            muteVideo()
            
        case "end_room":
            endRoom(call)
            
        case "remove_peer":
            removePeer(call)
            
        case "on_change_track_state_request":
            changeTrack(call)
            
        case "mute_all":
            toggleMuteAll(result, shouldMute: true)
            
        case "un_mute_all":
            toggleMuteAll(result, shouldMute: false)
            
        case "is_video_mute":
            isVideoMute(result)
            
        case "is_audio_mute":
            isAudioMute(result)
            
        case "get_local_peer":
            getLocalPeer(result)
            
        case "change_track_state_for_role":
            changeTrackStateForRole(call, result)
            
        case "start_rtmp_or_recording":
            startRtmpOrRecording(call, result)
            
        case "stop_rtmp_and_recording":
            stopRtmpAndRecording(result)
            
        case "start_hms_logger":
            startHMSLogger(call)
            
        case "remove_hms_logger":
            removeHMSLogger()
            
        case "get_room":
            getRoom(result)
            
        case "build":
            build(call, result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - HMS SDK Delegate Callbacks
    
    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        
        print(#function, "On Preview Room")
        
        var tracks:[Dictionary<String, Any?>]=[]
        
        for eachTrack in localTracks{
            tracks.insert(HMSTrackExtension.toDictionary(track: eachTrack), at: tracks.count)
        }
        
        let data:[String:Any] = [
            "event_name": "preview_video",
            "data": [
                "room": HMSRoomExtension.toDictionary(room),
                "local_tracks": tracks
            ]
        ]
        previewSink?(data)
    }
    
    public func on(join room: HMSRoom) {
        print("On Join Room")
        
        let data:[String:Any]=[
            "event_name":"on_join_room",
            "data":[
                "room" : HMSRoomExtension.toDictionary(room)
            ]
        ]
        eventSink?(data)
    }
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let tempArg = arguments as? Dictionary<String, AnyObject>{
            let name =  tempArg["name"] as? String ?? ""
            if name == "meeting" {
                self.eventSink = events
            } else if name == "preview" {
                self.previewSink = events
            } else if name == "logs" {
                self.logsSink = events
            }
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("on flutter error")
        return nil
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        print("On Update Room")
        
        let data:[String:Any]=[
            "event_name":"on_update_room",
            "data":[
                "name":"On Update Room"
            ]
        ]
        eventSink?(data)
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        print("On Peer join Room")
        
        let data:[String:Any]=[
            "event_name":"on_peer_update",
            "data":[
                "peer":HMSPeerExtension.toDictionary(peer: peer),
                "update": HMSPeerExtension.getValueOfHMSPeerUpdate(update: update)
            ]
            
        ]
        print(data)
        eventSink?(data)
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        
        print("On Track Update")
        
        let data:[String:Any]=[
            "event_name":"on_track_update",
            "data":[
                "peer":HMSPeerExtension.toDictionary(peer: peer),
                "update":HMSTrackExtension.getTrackUpdateInString(trackUpdate: update),
                "track":HMSTrackExtension.toDictionary(track: track)
            ]
        ]
        eventSink?(data)
    }
    
    public func on(error: HMSError) {
        print("On Error")
        
        let data:[String:Any]=[
            "event_name":"on_error",
            "data":[
                "error": HMSErrorExtension.toDictionary(error)
            ]
        ]
        eventSink?(data)
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        logSpeakers(speakers)
        
        var speakersDict = [[String: Any]]()
        for speaker in speakers {
            speakersDict.append(HMSSpeakerExtension.toDictionary(speaker))
        }
        
        let data:[String:Any]=[
            "event_name": "on_update_speaker",
            "data": [
                "speakers": speakersDict
            ]
        ]
        eventSink?(data)
    }
    
    public func on(message: HMSMessage) {
        
        let data:[String:Any]=[
            "event_name":"on_message",
            "data":[
                "message": HMSMessageExtension.toDictionary(message: message)
            ]
        ]
        eventSink?(data)
    }
    
    public func on(roleChangeRequest: HMSRoleChangeRequest) {
        print(#function, "On Role Change Request: ", roleChangeRequest.suggestedRole.name)
        
        self.roleChangeRequest = roleChangeRequest
        
        var dict = ["event_name": "on_role_change_request"] as [String: Any]
        var request = ["suggested_role": HMSRoleExtension.toDictionary(role: roleChangeRequest.suggestedRole)] as [String: Any]
        
        if let peer = roleChangeRequest.requestedBy {
            request["requested_by"] = HMSPeerExtension.toDictionary(peer: peer)
        }
        
        
        dict["data"] = ["role_change_request": request]
        
        eventSink?(dict)
    }
    
    public func on(changeTrackStateRequest: HMSChangeTrackStateRequest) {
        print(#function)
    }
    
    public func on(removedFromRoom notification: HMSRemovedFromRoomNotification) {
        print(#function)
    }
    
    public func onReconnecting() {
        print(#function, "on Reconnecting")
        
        let data:[String:Any]=[
            "event_name":"on_re_connecting",
            "data":[
                "name":"on Reconnecting"
            ]
        ]
        eventSink?(data)
    }
    
    public func onReconnected() {
        print(#function, "on Reconnected")
        
        let data:[String:Any]=[
            "event_name":"on_re_connected",
            "data":[
                "name":"onReconnected"
            ]
        ]
        eventSink?(data)
    }
    
    
    // MARK: - HMS SDK Actions
    
    func build(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        var trackSettings: HMSTrackSettings?
        if let settings = arguments["hms_track_setting"] as? [AnyHashable: Any] {
            
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
        }
        
        result(true)
    }
    
    func preview(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let authToken = arguments["auth_token"] as? String,
              let userName = arguments["user_name"] as? String
        else {
            print(#function, "Could not show preview, invalid parameters passed!")
            result("Could not preview")
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
        
        result("preview called")
    }
    
    func joinMeeting(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        if let config = config {
            hmsSDK?.join(config: config, delegate: self)
        } else {
            
            guard let authToken = arguments["auth_token"] as? String,
                  let userName = arguments["user_name"] as? String
            else {
                print(#function, "Could not join room, invalid parameters passed!")
                result("Could not join room")
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
        
        meetingEventChannel.setStreamHandler(self)
        
        result("joining meeting in ios")
    }
    
    func leaveMeeting(_ result: FlutterResult) {
        hmsSDK?.leave();
        result("Leaving meeting")
    }
    
    func switchAudio(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        print(arguments)
        if let peer = hmsSDK?.localPeer, let audioTrack = peer.audioTrack as? HMSLocalAudioTrack {
            audioTrack.setMute( arguments["is_on"] as? Bool ?? false)
        }
        result("audio_changed")
    }
    
    func switchVideo(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            let isOn:Bool = arguments["is_on"] as? Bool ?? false
            print(videoTrack.settings)
            if isOn {
                muteVideo()
            }else{
                unMuteVideo()
            }
        }
        result("video_changed")
    }
    
    func muteVideo() {
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            print(videoTrack.settings)
            videoTrack.setMute(true)
        }
    }
    func unMuteVideo() {
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            print(videoTrack.settings)
            videoTrack.setMute(false)
        }
    }
    
    func switchCamera(_ result: FlutterResult) {
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            videoTrack.switchCamera()
        }
        result("camera_changed")
    }
    
    func sendBroadcastMessage(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let message = arguments["message"] as? String
        else {
            print(#function, "Could not send broadcast message")
            result("Could not send broadcast message")
            return
        }
        
        hmsSDK?.sendBroadcastMessage(type: "chat", message: message) { message, error in
            if let error = error {
                print(#function, "Error sending broadcast message: ", error.description)
                return
            }
            
            print(#function, "Successfully sent broadcast message: ", message?.message ?? "")
        }
        
        result("sent message")
    }
    
    func sendDirectMessage(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let message = arguments["message"] as? String,
              let peerID = arguments["peer_id"] as? String,
              let peer = getRemotePeerById(peerId: peerID)
        else {
            print(#function, "Could not send direct message")
            result("Could not send direct message")
            return
        }
        
        hmsSDK?.sendDirectMessage(type: "chat", message: message, peer: peer) { message, error in
            if let error = error {
                print(#function, "Error sending direct message: ", error.description)
                return
            }
            
            print(#function, "Successfully sent direct message: ", message?.message ?? "")
        }
        
        result("sent direct message")
    }
    
    func sendGroupMessage(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let message = arguments["message"] as? String,
              let roleString = arguments["role_name"] as? String,
              let availableRoles = hmsSDK?.roles,
              let role = availableRoles.first(where: { $0.name == roleString })
        else {
            print(#function, "Could not send group message")
            result("Could not send group message")
            return
        }
        
        hmsSDK?.sendGroupMessage(type: "chat", message: message, roles: [role]) { message, error in
            if let error = error {
                print(#function, "Error sending group message: ", error.description)
                return
            }
            
            print(#function, "Successfully sent group message: ", message?.message ?? "")
        }
        
        result("sent group message")
    }
    
    func changeRole(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        let forceChange:Bool = arguments["force_change"] as? Bool ?? false
        let peerId:String = (arguments["peer_id"] as? String) ?? ""
        let peer:HMSRemotePeer? = getRemotePeerById(peerId: peerId)
        let role:HMSRole? = getRoleByString(name: (arguments["role_name"] as? String) ?? "")
        if (peer != nil && role != nil) {
            hmsSDK?.changeRole(for: peer!, to: role!,force: forceChange)
        }
        
        result("role change requested")
    }
    
    func getRoles(_ call: FlutterMethodCall, _ result: FlutterResult) {
        var roleList:[Dictionary<String, Any?>]=[]
        if  let roles:[HMSRole] = hmsSDK?.roles {
            for role in roles{
                roleList.insert(HMSRoleExtension.toDictionary(role: role), at: roleList.count)
            }
        }
        result(["roles":roleList])
    }
    
    func acceptRoleRequest(_ call: FlutterMethodCall, _ result: FlutterResult) {
        if let role = roleChangeRequest {
            hmsSDK?.accept(changeRole: role, completion: { [weak self] success, error in
                print(#function, "success: ", success, "error: ", error?.description as Any)
                if success {
                    self?.roleChangeRequest = nil
                }
            })
        }
        result("role_accepted")
    }
    
    func endRoom(_ call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let lock = arguments["lock"] as? Bool ?? false
        
        hmsSDK?.endRoom(lock: lock, reason: "Meeting is over") { success, error in
            
            if let error = error {
                print(#function, "Error in ending room: ", error.description)
                return
            }
            
            if (success) {
                print(#function, "Ended room successfully")
            }
        }
    }
    
    func removePeer(_ call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        guard let peerID = arguments["peer_id"] as? String,
              let peer = getRemotePeerById(peerId: peerID)
        else {
            print(#function, "Could not remove from room")
            return
        }
        
        let reason = (arguments["reason"] as? String) ?? "Removed from room"
        
        hmsSDK?.removePeer(peer, reason: reason) { success, error in
            if let error = error {
                print(#function, "Error in removing peer from room: ", error.description)
                return
            }
            
            if (success) {
                print(#function, "Removed \(peer.name) from room successfully")
            }
        }
    }
    
    func changeTrack(_ call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let hmsPeerID = arguments["hms_peer_id"] as? String,
              let peer = getRemotePeerById(peerId: hmsPeerID)
        else {
            print(#function, "Could not change track state")
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
            print(#function, "Could not find track for peer: \(peer.name)")
            return
        }
        
        let mute = arguments["mute"] as? Bool ?? false
        
        hmsSDK?.changeTrackState(for: track, mute: mute) { success, error in
            if let error = error {
                print(#function, "Error in changing track state: ", error.description)
                return
            }
            print(#function, "Successfully changed track state for: ", track.trackId)
        }
    }
    
    private func changeTrackStateForRole(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let mute = arguments["mute"] as? Bool else {
            print(#function, "invalid parameters for changeTrackStateForRole:")
            return result("invalid parameters for changeTrackStateForRole:")
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
                print(#function, error.localizedDescription)
                return
            }
            print(#function, success)
        }
        result(#function)
    }
    
    private func startRtmpOrRecording(_ call: FlutterMethodCall, _ result: FlutterResult) {
        
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let record = arguments["to_record"] as? Bool else {
            print(#function, "Could not find to_record boolean")
            result("\(#function) Could not find to_record boolean")
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
                print(error.localizedDescription)
                return
            }
            print(#function, success)
        }
        result(#function)
    }
    
    private func stopRtmpAndRecording(_ result: FlutterResult) {
        
        hmsSDK?.stopRTMPAndRecording { success, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print(#function, success)
        }
        result(#function)
    }
    
    var logLevel = HMSLogLevel.off
    
    private func startHMSLogger(_ call: FlutterMethodCall) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
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
    
    private func getRoom(_ result: FlutterResult) {
        
        if let room = hmsSDK?.room {
            let roomData = HMSRoomExtension.toDictionary(room)
            result(roomData)
            return
        }
        result(nil)
    }
    
    
    // MARK: - Helper Functions
    
    private func logSpeakers(_ speakers: [HMSSpeaker]) {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        let dateString = "\(hour):\(minutes):\(second)"
        
        print(#function, "Speaker update " + dateString, speakers.map { $0.peer.name },
              speakers.map { kindString(from: $0.track.kind) },
              speakers.map { $0.track.source })
    }
    
    func toggleMuteAll(_ result: FlutterResult, shouldMute: Bool) {
        
        guard let peers = hmsSDK?.remotePeers
        else {
            print(#function, "No remote peers in the room")
            return
        }
        
        for peer in peers {
            peer.remoteAudioTrack()?.setPlaybackAllowed(!shouldMute)
            for track in peer.auxiliaryTracks ?? [] {
                if let audio = track as? HMSRemoteAudioTrack {
                    audio.setPlaybackAllowed(!shouldMute)
                }
            }
        }
        
        shouldMute ? result("muted all") : result("unMutedAll")
    }
    
    func isVideoMute(_ result: FlutterResult) {
        guard let peer = hmsSDK?.localPeer else { return }
        
        result(peer.videoTrack?.isMute() ?? false)
    }
    
    func isAudioMute(_ result: FlutterResult) {
        guard let peer = hmsSDK?.localPeer else { return }
        
        result(peer.audioTrack?.isMute() ?? false)
    }
    
    func getLocalPeer(_ result: FlutterResult) {
        guard let localPeer = hmsSDK?.localPeer else { return }
        result(localPeer)
    }
    
    public func getPeerById(peerId:String,isLocal:Bool) -> HMSPeer?{
        if isLocal{
            if  let peer:HMSLocalPeer = hmsSDK?.localPeer{
                return peer
            }
        }else{
            if let peers:[HMSRemotePeer] = hmsSDK?.remotePeers{
                for peer in peers {
                    if(peer.peerID == peerId){
                        return peer
                    }
                }
            }
        }
        return nil
    }
    
    public func getRemotePeerById(peerId: String) -> HMSRemotePeer? {
        
        guard let peers = hmsSDK?.remotePeers else { return nil }
        
        return peers.first { $0.peerID == peerId }
    }
    
    public func getRoleByString(name:String) -> HMSRole?{
        if let roles = hmsSDK?.roles{
            for role in roles{
                if(role.name == name){
                    return role
                }
                
            }
        }
        return nil
    }
    
    func kindString(from kind: HMSTrackKind) -> String {
        switch kind {
        case .audio:
            return "KHmsTrackAudio"
        case .video:
            return "KHmsTrackVideo"
        default:
            return "Unknown Kind"
        }
    }
    
    func kind(from string: String) -> HMSTrackKind {
        switch string {
        case "KHmsTrackAudio":
            return .audio
        case "KHmsTrackVideo":
            return .video
        default:
            return .audio
        }
    }
    
}
