import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener,FlutterStreamHandler {


    
    let channel:FlutterMethodChannel
    let meetingEventChannel:FlutterEventChannel
    var eventSink:FlutterEventSink?
    
    public  init(channel:FlutterMethodChannel,meetingEventChannel:FlutterEventChannel) {
        self.channel=channel
        self.meetingEventChannel=meetingEventChannel
    }
    
    public func on(join room: HMSRoom) {
        print("On Join Room")
        channel.invokeMethod("on_join_room", arguments: "")
        eventSink!("on_join_room")
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
        channel.invokeMethod("on_update_room", arguments: "")
        eventSink!("on_update_room")
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        print("On Join Room")
        channel.invokeMethod("on_peer_update", arguments: "")
        eventSink!("on_peer_room")
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        print("On Track Update")
        channel.invokeMethod("on_track_update", arguments: "")
        eventSink!("on_track_update")
    }
    
    public func on(error: HMSError) {
        print("On Error")
        channel.invokeMethod("on_error", arguments: "")
        eventSink!("on_error")
    }
    
    public func on(message: HMSMessage) {
        print("On Message")
        channel.invokeMethod("on_message", arguments: "")
        eventSink!("on_message")
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        print("On Update Speaker")
        channel.invokeMethod("on_update_speaker", arguments: "")
        eventSink!("on_update_speaker")
    }
    
    public func onReconnecting() {
        print("on Reconnecting")
        channel.invokeMethod("on_re_connecting", arguments: "")
        eventSink!("on_re_connecting")
    }
    
    public func onReconnected() {
        print("on Reconnected")
        channel.invokeMethod("on_re_connected", arguments: "")
        eventSink!("on_re_connected")
    }
    
    internal var hmsSDK: HMSSDK?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "meeting_event_channel", binaryMessenger: registrar.messenger())
    let instance = SwiftHmssdkFlutterPlugin(channel: channel,meetingEventChannel: eventChannel)
    eventChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "join_meeting": joinMeeting(call:call,result:result)
    case "leave_meeting":leaveMeeting(result: result)
    default:
        result(FlutterMethodNotImplemented)
    }
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
//enable the stream handler
        
        result("joining meeting in ios")
    }
    
    func leaveMeeting(result:FlutterResult){
        hmsSDK?.leave();
        result("Leaving meeting")
    }

    
    
}

