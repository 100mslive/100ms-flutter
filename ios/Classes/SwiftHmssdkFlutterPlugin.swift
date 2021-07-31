import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener,FlutterStreamHandler,HMSPreviewListener {
   
    let channel:FlutterMethodChannel
    let meetingEventChannel:FlutterEventChannel
    var eventSink:FlutterEventSink?
    
    public  init(channel:FlutterMethodChannel,meetingEventChannel:FlutterEventChannel) {
        self.channel=channel
        self.meetingEventChannel=meetingEventChannel
    }
    
    public func onPreview(room: HMSRoom, localTracks: [HMSTrack]) {
        print("On Join Room")
        var peerDict : Dictionary<String, Any?> = [:]
        var trackDict : Dictionary<String, Any?> = [:]
        if let tempPeer:HMSPeer = hmsSDK?.localPeer{
            peerDict = HMSPeerExtension.toDictionary(peer:tempPeer )
        }
        if let tempTrack:HMSTrack = hmsSDK?.localPeer?.localVideoTrack(){
            trackDict = HMSTrackExtension.toDictionary(track: tempTrack )
        }
        let data:[String:Any]=[
            "event_name":"preview_video",
            "data":[
                "peer":peerDict,
                "track":trackDict
            ]
        ]
        eventSink?(data)
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
        self.eventSink = events
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
                "name":"Vivek"
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
                "name":"Vivek"
            ]
        ]
        eventSink?(data)
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        print("On Update Speaker")
        let data:[String:Any]=[
            "event_name":"on_update_speaker",
            "data":[
                "name":"Vivek"
            ]
        ]
        eventSink?(data)
    }
    
    public func onReconnecting() {
        print("on Reconnecting")
  
        let data:[String:Any]=[
            "event_name":"on_re_connecting",
            "data":[
                "name":"Vivek"
            ]
        ]
        eventSink?(data)
    }
    
    public func onReconnected() {
        print("on Reconnected")
        let data:[String:Any]=[
            "event_name":"on_re_connected",
            "data":[
                "name":"Vivek"
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
                videoTrack.stopCapturing()

            }else{
                videoTrack.startCapturing()
            }
         }
        result("video_changed")
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
//        result("preview initiated")
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
        
        
        hmsSDK = HMSSDK.build()
        
        hmsSDK?.join(config: config, delegate: self)
        meetingEventChannel.setStreamHandler(self)
        result("joining meeting in ios")
    }
    
    func leaveMeeting(result:FlutterResult){
        hmsSDK?.leave();
        result("Leaving meeting")
    }
    internal var hmsSDK: HMSSDK?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
   
    let instance = SwiftHmssdkFlutterPlugin(channel: channel,meetingEventChannel: eventChannel)
    
    
     let videoViewFactory:HMSVideoViewFactory = HMSVideoViewFactory(messenger: registrar.messenger(),plugin: instance)
     registrar.register(videoViewFactory, withId: "HMSVideoView")
    
    eventChannel.setStreamHandler(instance)
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
    default:
        result(FlutterMethodNotImplemented)
    }
  }


    
    
}

