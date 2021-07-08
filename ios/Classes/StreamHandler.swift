//
//  StreamHandler.swift
//  hmssdk_flutter
//
//  Created by Vivek Yadav on 08/07/21.
//

import Foundation
import HMSSDK
class StreamHandler :NSObject, FlutterStreamHandler{
    let channel:FlutterMethodChannel
    let meetingEventChannel:FlutterEventChannel
    private var eventSink: FlutterEventSink?

    init(channel:FlutterMethodChannel,meetingEventChannel:FlutterEventChannel) {
        self.channel=channel
        self.meetingEventChannel=meetingEventChannel
    }
    
//    public func on(join room: HMSRoom) {
//        print("On Join Room")
//        channel.invokeMethod("on_join_room", arguments: "")
//        eventSink!("on_join_room")
//    }
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink=events
        print(events)
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("on flutter error")
       return nil
    }
    
//    public func on(room: HMSRoom, update: HMSRoomUpdate) {
//        print("On Update Room")
//        channel.invokeMethod("on_update_room", arguments: "")
//    }
//
//    public func on(peer: HMSPeer, update: HMSPeerUpdate) {
//        print("On Join Room")
//        channel.invokeMethod("on_peer_update", arguments: "")
//    }
//
//    public func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
//        print("On Track Update")
//        channel.invokeMethod("on_track_update", arguments: "")
//    }
//
//    public func on(error: HMSError) {
//        print("On Error")
//        channel.invokeMethod("on_error", arguments: "")
//    }
//
//    public func on(message: HMSMessage) {
//        print("On Message")
//        channel.invokeMethod("on_message", arguments: "")
//    }
//
//    public func on(updated speakers: [HMSSpeaker]) {
//        print("On Update Speaker")
//        channel.invokeMethod("on_update_speaker", arguments: "")
//        eventSink!("on_join_room")
//    }
//
//    public func onReconnecting() {
//        print("on Reconnecting")
//        channel.invokeMethod("on_re_connecting", arguments: "")
//    }
//
//    public func onReconnected() {
//        print("on Reconnected")
//        channel.invokeMethod("on_re_connected", arguments: "")
//    }
    
}
