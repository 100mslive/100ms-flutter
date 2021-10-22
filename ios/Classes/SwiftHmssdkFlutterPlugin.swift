
import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener, FlutterStreamHandler, HMSPreviewListener {
    
    let channel:FlutterMethodChannel
    let meetingEventChannel:FlutterEventChannel
    let previewEventChannel:FlutterEventChannel
    var eventSink:FlutterEventSink?
    var previewSink:FlutterEventSink?
    var roleChangeRequest:HMSRoleChangeRequest?
    
    internal var hmsSDK: HMSSDK?
    
    private var config: HMSConfig?
    
    
    // MARK: - Initial Setup
    
    public init(channel: FlutterMethodChannel, meetingEventChannel: FlutterEventChannel, previewEventChannel: FlutterEventChannel) {
        self.channel=channel
        self.meetingEventChannel=meetingEventChannel
        self.previewEventChannel=previewEventChannel
        hmsSDK=HMSSDK.build()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
        let previewChannel = FlutterEventChannel(name: "preview_event_channel", binaryMessenger: registrar.messenger())
        
        let instance = SwiftHmssdkFlutterPlugin(channel: channel,meetingEventChannel: eventChannel,previewEventChannel: previewChannel)
        
        
        let videoViewFactory:HMSVideoViewFactory = HMSVideoViewFactory(messenger: registrar.messenger(),plugin: instance)
        registrar.register(videoViewFactory, withId: "HMSVideoView")
        
        eventChannel.setStreamHandler(instance)
        previewChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        
        case "join_meeting":
            joinMeeting(call:call,result:result)
            
        case "leave_meeting":
            leaveMeeting(result: result)
            
        case "switch_audio":
            switchAudio(call: call , result: result)
            
        case "switch_video":
            switchVideo(call: call , result: result)
            
        case "switch_camera":
            switchCamera(result: result)
            
        case "preview_video":
            previewVideo(call:call,result:result)
            
        case "send_message":
            sendBroadcastMessage(call:call,result:result)
            
        case "send_direct_message":
            sendDirectMessage(call:call,result:result)
            
        case "send_group_message":
            sendGroupMessage(call, result)
            
        case "accept_role_change":
            acceptRoleRequest(call:call,result:result)
            
        case "change_role":
            changeRole(call:call,result:result)
            
        case "get_roles":
            getRoles(call:call,result:result)
            
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
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - HMS SDK Delegate Callbacks
    
    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        print("On Preview Room")
        var tracks:[Dictionary<String, Any?>]=[]
        
        for eachTrack in localTracks{
            tracks.insert(HMSTrackExtension.toDictionary(track: eachTrack), at: tracks.count)
        }
        
        let data:[String:Any]=[
            "event_name":"preview_video",
            "data":[
                "room":HMSRoomExtension.toDictionary(room),
                "local_tracks":tracks,
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
            let name:String =  tempArg["name"] as? String ?? ""
            if(name == "meeting"){
                self.eventSink = events
            }else if(name == "preview"){
                self.previewSink=events;
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
                "error":HMSErrorExtension.toDictionary(error: error)
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
        print(#function, "On Role Change Request: ", roleChangeRequest.suggestedRole.name, roleChangeRequest.requestedBy.name)
        
        self.roleChangeRequest = roleChangeRequest
        
        let data: [String:Any] = [
            "event_name": "on_role_change_request",
            "data": [
                "role_change_request":[
                    "requested_by": HMSPeerExtension.toDictionary(peer: roleChangeRequest.requestedBy),
                    "suggested_role": HMSRoleExtension.toDictionary(role: roleChangeRequest.suggestedRole)
                ]
            ]
        ]
        eventSink?(data)
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
    
    func previewVideo(call: FlutterMethodCall, result: FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        
        guard let authToken = arguments["auth_token"] as? String,
              let userName = arguments["user_name"] as? String
        else {
            print(#function, "Could not show preview, invalid parameters passed!")
            result("Could not preview")
            return
        }
        
        let shouldSkipPIIEvents = arguments["should_skip_pii_events"] as? Bool ?? false
        let metaData = arguments["meta_data"] as? String ?? nil
        let isProd = arguments["is_prod"] as? Bool ?? true
        let initEndpoint = isProd ? nil : "https://qa-init.100ms.live/init"
        
        config = HMSConfig(userName: userName,
                           authToken: authToken,
                           shouldSkipPIIEvents: shouldSkipPIIEvents,
                           metaData: metaData,
                           endpoint: initEndpoint)
        
        hmsSDK?.preview(config: config!, delegate: self)
        
        result("preview called")
    }
    
    func joinMeeting(call: FlutterMethodCall, result: FlutterResult) {
        
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
            let metaData = arguments["meta_data"] as? String ?? nil
            let isProd = arguments["is_prod"] as? Bool ?? true
            let initEndpoint = isProd ? nil : "https://qa-init.100ms.live/init"
            
            config = HMSConfig(userName: userName,
                               authToken: authToken,
                               shouldSkipPIIEvents: shouldSkipPIIEvents,
                               metaData: metaData,
                               endpoint: initEndpoint)
            
            hmsSDK?.join(config: config!, delegate: self)
        }
        
        meetingEventChannel.setStreamHandler(self)
        
        result("joining meeting in ios")
    }
    
    func leaveMeeting(result:FlutterResult){
        hmsSDK?.leave();
        result("Leaving meeting")
    }
    
    func switchAudio(call: FlutterMethodCall,result:FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        print(arguments)
        if let peer = hmsSDK?.localPeer, let audioTrack = peer.audioTrack as? HMSLocalAudioTrack {
            audioTrack.setMute( arguments["is_on"] as? Bool ?? false)
        }
        result("audio_changed")
    }
    
    func switchVideo(call: FlutterMethodCall,result:FlutterResult) {
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
    
    func muteVideo(){
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            print(videoTrack.settings)
            videoTrack.setMute(true)
        }
    }
    func unMuteVideo(){
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            print(videoTrack.settings)
            videoTrack.setMute(false)
        }
    }
    
    func switchCamera(result:FlutterResult) {
        if let peer = hmsSDK?.localPeer, let videoTrack = peer.videoTrack as? HMSLocalVideoTrack {
            videoTrack.switchCamera()
        }
        result("camera_changed")
    }
    
    func sendBroadcastMessage(call: FlutterMethodCall,result:FlutterResult) {
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
    
    func sendDirectMessage(call: FlutterMethodCall,result:FlutterResult){
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
    
    func changeRole(call: FlutterMethodCall,result:FlutterResult) {
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
    
    
    func getRoles(call: FlutterMethodCall,result:FlutterResult){
        var roleList:[Dictionary<String, Any?>]=[]
        if  let roles:[HMSRole] = hmsSDK?.roles {
            for role in roles{
                roleList.insert(HMSRoleExtension.toDictionary(role: role), at: roleList.count)
            }
        }
        result(["roles":roleList])
        
    }
    
    func acceptRoleRequest(call: FlutterMethodCall,result:FlutterResult) {
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
    
    func endRoom(_ call: FlutterMethodCall){
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
    
    func removePeer(_ call: FlutterMethodCall){
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
    
    func changeTrack(_ call: FlutterMethodCall){
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
    
    
    // MARK: - Helper Functions
    
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
            return "Audio"
        case .video:
            return "Video"
        default:
            return "Unknown Kind"
        }
    }
    
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
}

