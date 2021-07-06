import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener {
    
    let channel:FlutterMethodChannel
    
    public  init(channel:FlutterMethodChannel) {
        self.channel=channel
    }
    public func on(join room: HMSRoom) {
        print("On Join Room")
        channel.invokeMethod("join_room", arguments: "")
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        channel.invokeMethod("update_room", arguments: "")
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        channel.invokeMethod("peer_update", arguments: "")
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        channel.invokeMethod("track_update", arguments: "")
    }
    
    public func on(error: HMSError) {
        channel.invokeMethod("error", arguments: "")
    }
    
    public func on(message: HMSMessage) {
        channel.invokeMethod("message", arguments: "")
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        channel.invokeMethod("update_speaker", arguments: "")
    }
    
    public func onReconnecting() {
        channel.invokeMethod("re_connecting", arguments: "")
    }
    
    public func onReconnected() {
        channel.invokeMethod("on_reconnected", arguments: "")
    }
    
    internal var hmsSDK: HMSSDK?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftHmssdkFlutterPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "join_meeting": joinMeeting(call:call,result:result)
        
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
    }

    
    
}

