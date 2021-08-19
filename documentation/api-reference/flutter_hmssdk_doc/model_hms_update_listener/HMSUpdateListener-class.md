


# HMSUpdateListener class






    *[<Null safety>](https://dart.dev/null-safety)*






## Constructors

[HMSUpdateListener](../model_hms_update_listener/HMSUpdateListener/HMSUpdateListener.md) ()

    


## Properties

##### [hashCode](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html) &#8594; [int](https://api.flutter.dev/flutter/dart-core/int-class.html)



The hash code for this object. [...](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html)  
_read-only, inherited_



##### [runtimeType](https://api.flutter.dev/flutter/dart-core/Object/runtimeType.html) &#8594; [Type](https://api.flutter.dev/flutter/dart-core/Type-class.html)



A representation of the runtime type of the object.   
_read-only, inherited_




## Methods

##### [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)([Invocation](https://api.flutter.dev/flutter/dart-core/Invocation-class.html) invocation) dynamic



Invoked when a non-existent method or property is accessed. [...](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)  
_inherited_



##### [onError](../model_hms_update_listener/HMSUpdateListener/onError.md)({required [HMSError](../model_hms_error/HMSError-class.md) error}) void



This will be called when there is an error in the system [...](../model_hms_update_listener/HMSUpdateListener/onError.md)  




##### [onJoin](../model_hms_update_listener/HMSUpdateListener/onJoin.md)({required [HMSRoom](../model_hms_room/HMSRoom-class.md) room}) void



This will be called on a successful JOIN of the room by the user [...](../model_hms_update_listener/HMSUpdateListener/onJoin.md)  




##### [onMessage](../model_hms_update_listener/HMSUpdateListener/onMessage.md)({required [HMSMessage](../model_hms_message/HMSMessage-class.md) message}) void



This is called when there is a new broadcast message from any other peer in the room [...](../model_hms_update_listener/HMSUpdateListener/onMessage.md)  




##### [onPeerUpdate](../model_hms_update_listener/HMSUpdateListener/onPeerUpdate.md)({required [HMSPeer](../model_hms_peer/HMSPeer-class.md) peer, required [HMSPeerUpdate](../enum_hms_peer_update/HMSPeerUpdate-class.md) update}) void



This will be called whenever there is an update on an existing peer
or a new peer got added/existing peer is removed. [...](../model_hms_update_listener/HMSUpdateListener/onPeerUpdate.md)  




##### [onReconnected](../model_hms_update_listener/HMSUpdateListener/onReconnected.md)() void



when you are back in the room after reconnection   




##### [onReconnecting](../model_hms_update_listener/HMSUpdateListener/onReconnecting.md)() void



when network or some other error happens it will be called   




##### [onRoleChangeRequest](../model_hms_update_listener/HMSUpdateListener/onRoleChangeRequest.md)({required [HMSRoleChangeRequest](../model_hms_role_change_request/HMSRoleChangeRequest-class.md) roleChangeRequest}) void



This is called when someone asks for change or role [...](../model_hms_update_listener/HMSUpdateListener/onRoleChangeRequest.md)  




##### [onRoomUpdate](../model_hms_update_listener/HMSUpdateListener/onRoomUpdate.md)({required [HMSRoom](../model_hms_room/HMSRoom-class.md) room, required [HMSRoomUpdate](../enum_hms_room_update/HMSRoomUpdate-class.md) update}) void



This is called when there is a change in any property of the Room [...](../model_hms_update_listener/HMSUpdateListener/onRoomUpdate.md)  




##### [onTrackUpdate](../model_hms_update_listener/HMSUpdateListener/onTrackUpdate.md)({required [HMSTrack](../model_hms_track/HMSTrack-class.md) track, required [HMSTrackUpdate](../enum_hms_track_update/HMSTrackUpdate-class.md) trackUpdate, required [HMSPeer](../model_hms_peer/HMSPeer-class.md) peer}) void



This is called when there are updates on an existing track
or a new track got added/existing track is removed [...](../model_hms_update_listener/HMSUpdateListener/onTrackUpdate.md)  




##### [onUpdateSpeakers](../model_hms_update_listener/HMSUpdateListener/onUpdateSpeakers.md)({required [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSSpeaker](../model_hms_speaker/HMSSpeaker-class.md)> updateSpeakers}) void



This is called every 1 second with list of active speakers [...](../model_hms_update_listener/HMSUpdateListener/onUpdateSpeakers.md)  




##### [toString](https://api.flutter.dev/flutter/dart-core/Object/toString.html)() [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



A string representation of this object. [...](https://api.flutter.dev/flutter/dart-core/Object/toString.html)  
_inherited_




## Operators

##### [operator ==](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other) [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



The equality operator. [...](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)  
_inherited_











