


# HMSUpdateListener class






    *[<Null safety>](https://dart.dev/null-safety)*






## Constructors

[HMSUpdateListener](../hmssdk_flutter/HMSUpdateListener/HMSUpdateListener.md) ()

    


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



##### [onError](../hmssdk_flutter/HMSUpdateListener/onError.md)({required [HMSError](../hmssdk_flutter/HMSError-class.md) error}) void



This will be called when there is an error in the system [...](../hmssdk_flutter/HMSUpdateListener/onError.md)  




##### [onJoin](../hmssdk_flutter/HMSUpdateListener/onJoin.md)({required [HMSRoom](../hmssdk_flutter/HMSRoom-class.md) room}) void



This will be called on a successful JOIN of the room by the user [...](../hmssdk_flutter/HMSUpdateListener/onJoin.md)  




##### [onMessage](../hmssdk_flutter/HMSUpdateListener/onMessage.md)({required [HMSMessage](../hmssdk_flutter/HMSMessage-class.md) message}) void



This is called when there is a new broadcast message from any other peer in the room [...](../hmssdk_flutter/HMSUpdateListener/onMessage.md)  




##### [onPeerUpdate](../hmssdk_flutter/HMSUpdateListener/onPeerUpdate.md)({required [HMSPeer](../hmssdk_flutter/HMSPeer-class.md) peer, required [HMSPeerUpdate](../hmssdk_flutter/HMSPeerUpdate-class.md) update}) void



This will be called whenever there is an update on an existing peer
or a new peer got added/existing peer is removed. [...](../hmssdk_flutter/HMSUpdateListener/onPeerUpdate.md)  




##### [onReconnected](../hmssdk_flutter/HMSUpdateListener/onReconnected.md)() void



when you are back in the room after reconnection   




##### [onReconnecting](../hmssdk_flutter/HMSUpdateListener/onReconnecting.md)() void



when network or some other error happens it will be called   




##### [onRoleChangeRequest](../hmssdk_flutter/HMSUpdateListener/onRoleChangeRequest.md)({required [HMSRoleChangeRequest](../hmssdk_flutter/HMSRoleChangeRequest-class.md) roleChangeRequest}) void



This is called when someone asks for change or role [...](../hmssdk_flutter/HMSUpdateListener/onRoleChangeRequest.md)  




##### [onRoomUpdate](../hmssdk_flutter/HMSUpdateListener/onRoomUpdate.md)({required [HMSRoom](../hmssdk_flutter/HMSRoom-class.md) room, required [HMSRoomUpdate](../hmssdk_flutter/HMSRoomUpdate-class.md) update}) void



This is called when there is a change in any property of the Room [...](../hmssdk_flutter/HMSUpdateListener/onRoomUpdate.md)  




##### [onTrackUpdate](../hmssdk_flutter/HMSUpdateListener/onTrackUpdate.md)({required [HMSTrack](../hmssdk_flutter/HMSTrack-class.md) track, required [HMSTrackUpdate](../hmssdk_flutter/HMSTrackUpdate-class.md) trackUpdate, required [HMSPeer](../hmssdk_flutter/HMSPeer-class.md) peer}) void



This is called when there are updates on an existing track
or a new track got added/existing track is removed [...](../hmssdk_flutter/HMSUpdateListener/onTrackUpdate.md)  




##### [onUpdateSpeakers](../hmssdk_flutter/HMSUpdateListener/onUpdateSpeakers.md)({required [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSSpeaker](../hmssdk_flutter/HMSSpeaker-class.md)> updateSpeakers}) void



This is called every 1 second with list of active speakers [...](../hmssdk_flutter/HMSUpdateListener/onUpdateSpeakers.md)  




##### [toString](https://api.flutter.dev/flutter/dart-core/Object/toString.html)() [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



A string representation of this object. [...](https://api.flutter.dev/flutter/dart-core/Object/toString.html)  
_inherited_




## Operators

##### [operator ==](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other) [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



The equality operator. [...](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)  
_inherited_











