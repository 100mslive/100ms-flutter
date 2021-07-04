import Flutter
import UIKit
import HMSSDK

public class SwiftHmssdkFlutterPlugin: NSObject, FlutterPlugin, HMSUpdateListener {
    public func on(join room: HMSRoom) {
        print("On Join Room")
    }
    
    public func on(room: HMSRoom, update: HMSRoomUpdate) {
        print("On update Room")
    }
    
    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
        print("On Update Peer")
    }
    
    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
        print("On Track update")
    }
    
    public func on(error: HMSError) {
        print("On error")
    }
    
    public func on(message: HMSMessage) {
        print("On Message")
    }
    
    public func on(updated speakers: [HMSSpeaker]) {
        print("On update speaker")
    }
    
    public func onReconnecting() {
        print("On Re connecting")
    }
    
    public func onReconnected() {
        print("On reconnection")
    }
    
    internal var hmsSDK: HMSSDK?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hmssdk_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftHmssdkFlutterPlugin()
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

