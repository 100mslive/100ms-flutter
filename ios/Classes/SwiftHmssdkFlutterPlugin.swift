import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener,FlutterStreamHandler,HMSPreviewListener {
   
    let channel:FlutterMethodChannel
    let meetingEventChannel:FlutterEventChannel
    let previewEventChannel:FlutterEventChannel
    var eventSink:FlutterEventSink?
    var previewSink:FlutterEventSink?
    var roleChangeRequest:HMSRoleChangeRequest?
    
    public  init(channel:FlutterMethodChannel,meetingEventChannel:FlutterEventChannel,previewEventChannel:FlutterEventChannel) {
        self.channel=channel
        self.meetingEventChannel=meetingEventChannel
        self.previewEventChannel=previewEventChannel
        hmsSDK=HMSSDK.build()
    }
    
    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        print("On Preview Room")
        var tracks:[Dictionary<String, Any?>]=[]
        
        for eachTrack in localTracks{
            tracks.insert(HMSTrackExtension.toDictionary(track: eachTrack), at: tracks.count)
        }
        
        let data:[String:Any]=[
            "event_name":"preview_video",
            "data":[
                "room":HMSRoomExtension.toDictionary(hmsRoom: room),
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
                "room" : HMSRoomExtension.toDictionary(hmsRoom: room)
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
    public func getRemotePeerById(peerId:String) -> HMSRemotePeer?{
            if let peers:[HMSRemotePeer] = hmsSDK?.remotePeers{
                for peer in peers {
                    if(peer.peerID == peerId){
                        return peer
                    }
                }
            }
        return nil
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
    
    public func on(message: HMSMessage) {
        print("On Message")

        let data:[String:Any]=[
            "event_name":"on_message",
            "data":[
                "message": HMSMessageExtension.toDictionary(message: message)
            ]
        ]
        eventSink?(data)
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        print("On Update Speaker")
        let data:[String:Any]=[
            "event_name":"on_update_speaker",
            "data":[
                "name":"On Update Speaker"
            ]
        ]
        eventSink?(data)
    }
    
    public func on(roleChangeRequest: HMSRoleChangeRequest) {
        print("On Role Change Request")
        
        self.roleChangeRequest=roleChangeRequest
        
        let data:[String:Any]=[
            "event_name":"on_role_change_request",
            "data":[
                "role_change_request":[
                    "requested_by":HMSPeerExtension.toDictionary(peer: roleChangeRequest.requestedBy),
                    "suggested_role":HMSRoleExtension.toDictionary(role: roleChangeRequest.suggestedRole)
                ]
            ]
        ]
        eventSink?(data)
    }
    public func onReconnecting() {
        print("on Reconnecting")
  
        let data:[String:Any]=[
            "event_name":"on_re_connecting",
            "data":[
                "name":"on Reconnecting"
            ]
        ]
        eventSink?(data)
    }
    
    public func onReconnected() {
        print("on Reconnected")
        let data:[String:Any]=[
            "event_name":"on_re_connected",
            "data":[
                "name":"onReconnected"
            ]
        ]
        eventSink?(data)
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
    
    func previewVideo(call: FlutterMethodCall,result:FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let config:HMSConfig = HMSConfig(
            userName: (arguments["user_name"] as? String) ?? "",
            userID: arguments["user_id"] as? String ?? "",
            roomID: arguments["room_id"] as? String ?? "",
            authToken: arguments["auth_token"] as? String ?? "",
            shouldSkipPIIEvents: arguments["should_skip_pii_events"] as? Bool ?? false
        )
     
        hmsSDK?.preview(config: config, delegate: self)
    }
    
    func joinMeeting(call:FlutterMethodCall,result:FlutterResult){
        let arguments = call.arguments as! Dictionary<String, AnyObject>

        let config:HMSConfig = HMSConfig(
            userName: (arguments["user_name"] as? String) ?? "",
            userID: arguments["user_id"] as? String ?? "",
            roomID: arguments["room_id"] as? String ?? "",
            authToken: arguments["auth_token"] as? String ?? "",
            shouldSkipPIIEvents: arguments["should_skip_pii_events"] as? Bool ?? false
        )
       
        hmsSDK?.join(config: config, delegate: self)
        meetingEventChannel.setStreamHandler(self)
        result("joining meeting in ios")
    }
    
    func sendBroadcastMessage(call: FlutterMethodCall,result:FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, AnyObject>
//        let message:HMSMessage = HMSMessage(
//            sender: (arguments["sender"] as? String) ?? "",
////            receiver: arguments["receiver"] as? String ?? "",
//            time:arguments["time"] as? String ?? "",
////            type: arguments["type"] as? String ?? "",
//            message: arguments["message"] as? String ?? ""
//        )
        hmsSDK?.sendBroadcastMessage(tyep:"chat",message:  arguments["message"] as? String ?? ""){ message, error in
        }
        result("sent message")
    }

    func sendDirectMessage(call: FlutterMethodCall,result:FlutterResult){
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let message:String = arguments["message"] as? String ?? ""
        let peerId:String = arguments["peer_id"] as? String ?? ""
        let peer:HMSRemotePeer? = getRemotePeerById(peerId: peerId)
        if(peer!=nil)
            hmssdk.sendDirectMessage(type: "chat", message:message!, peer: peer!) { message, error in

            }
         result("sent message")
    }

    func sendGroupMessage(){
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let message:String = arguments["message"] as? String ?? ""
        let roleUWant:String = arguments["role_name"] as? String ?? ""
        val roles = hmsSDK.getRoles()
        val role=roles.first(where:{$0.name==roleUWant})
        val rolesList=[]
        rolesList.append(role)
        hmssdk.sendGroupMessage(type: "chat", message: message!, roles: rolesList) { message, error in
        }
    }



    func acceptRoleRequest(call: FlutterMethodCall,result:FlutterResult) {
        if let role = roleChangeRequest{
            hmsSDK?.accept(changeRole: role)
        }
        result("role_accepted")
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
    func leaveMeeting(result:FlutterResult){
        hmsSDK?.leave();
        result("Leaving meeting")
    }

    func endRoom(call: FlutterMethodCall){
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let lock:Bool = arguments["lock"] as? Bool ?? false

        hmsSDK?.endRoom(lock: false, reason: "Meeting is over") { success, error in
            if (success) {
                // pop to previous screen
            }
        }
    }

    func removePeer(call: FlutterMethodCall){
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let peerId:Bool = arguments["peer_id"] as? String ?? ""
        let peer:HMSRemotePeer? = getRemotePeerById(peerId: peerId)
        hmssdk.removePeer(peer!, reason: "You are violating the community rules.") { success, error in
        }
    }

    func changeTrack(call: FlutterMethodCall){
        let arguments = call.arguments as! Dictionary<String, AnyObject>
        let hmsPeerId:String = arguments["hms_peer_id"] as? String ?? ""
        let mute:Bool = arguments["mute"] as? Bool ?? false
        let muteVideoKind:Bool = arguments["mute_video_kind"] as? Bool ?? false

        let peer:HMSRemotePeer? = getRemotePeerById(peerId: hmsPeerId)
        let track:HMSTrack = muteVideoKind==true ? peer!.videoTrack : peer!.audioTrack
        hmssdk.changeTrackState(track,mute!){ success, error in
            if (success) {
                // pop to previous screen
            }
        }
    }

    func muteAll(result:FlutterResult){
        val peerList =hmsSDK?.getRemotePeers()
        for remotePeer in peerList{
            remotePeer.audioTrack?.isPlaybackAllowed=false
            for auxTrack in remotePeer.auxiliaryTracks{
                if(auxTrack is HMSRemoteAudioTrack){
                    auxTrack.isPlaybackAllowed=false
                }
            }
        }
        result("muted all")
    }

    func unMuteAll(result:FlutterResult){
        val peerList =hmsSDK?.getRemotePeers()
        for remotePeer in peerList{
            remotePeer.audioTrack?.isPlaybackAllowed=true
            for auxTrack in remotePeer.auxiliaryTracks{
                if(auxTrack is HMSRemoteAudioTrack){
                    auxTrack.isPlaybackAllowed=true
                }
            }
        }
        result("unMutedAll")
    }





    internal var hmsSDK: HMSSDK?

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
    case "join_meeting":joinMeeting(call:call,result:result)
    case "leave_meeting":leaveMeeting(result: result)
    case "switch_audio":switchAudio(call: call , result: result)
    case "switch_video":switchVideo(call: call , result: result)
    case "switch_camera":switchCamera(result: result)
    case "preview_video":previewVideo(call:call,result:result)
    case "send_message":sendBroadcastMessage(call:call,result:result)
    case "send_direct_message":sendDirectMessage(call:call,result:result)
    case "send_group_message": sendGroupMessage(call:call,result:result)
    case "accept_role_change":acceptRoleRequest(call:call,result:result)
    case "change_role":changeRole(call:call,result:result)
    case "get_roles":getRoles(call:call,result:result)
    case "start_capturing": unMuteVideo()
    case "stop_capturing": muteVideo()
    case "end_room":endRoom(call)
    case "remove_peer":removePeer(call)
    case "on_change_track_state_request":changeTrack(call)
    case "mute_all":muteAll(result)
    case "un_mute_all":unMuteAll(result)
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}

