


# HMSMeeting class






    *[<Null safety>](https://dart.dev/null-safety)*






## Constructors

[HMSMeeting](../hmssdk_flutter/HMSMeeting/HMSMeeting.md) ()

    


## Properties

##### [hashCode](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html) &#8594; [int](https://api.flutter.dev/flutter/dart-core/int-class.html)



The hash code for this object. [...](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html)  
_read-only, inherited_



##### [runtimeType](https://api.flutter.dev/flutter/dart-core/Object/runtimeType.html) &#8594; [Type](https://api.flutter.dev/flutter/dart-core/Type-class.html)



A representation of the runtime type of the object.   
_read-only, inherited_




## Methods

##### [acceptRoleChangerequest](../hmssdk_flutter/HMSMeeting/acceptRoleChangerequest.md)() void



accept the role changes.   




##### [addMeetingListener](../hmssdk_flutter/HMSMeeting/addMeetingListener.md)([HMSUpdateListener](../hmssdk_flutter/HMSUpdateListener-class.md) listener) void



add MeetingListener it will add all the listeners.   




##### [addPreviewListener](../hmssdk_flutter/HMSMeeting/addPreviewListener.md)([HMSPreviewListener](../hmssdk_flutter/HMSPreviewListener-class.md) listener) void



add one or more previewListeners.   




##### [changeRole](../hmssdk_flutter/HMSMeeting/changeRole.md)({required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) peerId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) roleName, [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) forceChange = false}) void



you can change role of any peer in the room just pass <code>peerId</code> and <code>roleName</code>, <code>forceChange</code> is optional.   




##### [getRoles](../hmssdk_flutter/HMSMeeting/getRoles.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSRole](../hmssdk_flutter/HMSRole-class.md)>>



returns all the roles associated with the link used   




##### [isAudioMute](../hmssdk_flutter/HMSMeeting/isAudioMute.md)([HMSPeer](../hmssdk_flutter/HMSPeer-class.md)? peer) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)>



checks the audio is mute or unmute just pass <code>peer</code>   




##### [isVideoMute](../hmssdk_flutter/HMSMeeting/isVideoMute.md)([HMSPeer](../hmssdk_flutter/HMSPeer-class.md)? peer) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)>



checks the video is mute or unmute just pass <code>peer</code>   




##### [joinMeeting](../hmssdk_flutter/HMSMeeting/joinMeeting.md)({required [HMSConfig](../hmssdk_flutter/HMSConfig-class.md) config}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



join meeting by passing HMSConfig instance to it.   




##### [leaveMeeting](../hmssdk_flutter/HMSMeeting/leaveMeeting.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



just call this method to leave meeting.   




##### [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)([Invocation](https://api.flutter.dev/flutter/dart-core/Invocation-class.html) invocation) dynamic



Invoked when a non-existent method or property is accessed. [...](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)  
_inherited_



##### [previewVideo](../hmssdk_flutter/HMSMeeting/previewVideo.md)({required [HMSConfig](../hmssdk_flutter/HMSConfig-class.md) config}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



preview before joining the room pass <a href="../hmssdk_flutter/HMSConfig-class.md">HMSConfig</a>.   




##### [removeMeetingListener](../hmssdk_flutter/HMSMeeting/removeMeetingListener.md)([HMSUpdateListener](../hmssdk_flutter/HMSUpdateListener-class.md) listener) void



remove a meetListener.   




##### [removePreviewListener](../hmssdk_flutter/HMSMeeting/removePreviewListener.md)([HMSPreviewListener](../hmssdk_flutter/HMSPreviewListener-class.md) listener) void



remove a previewListener.   




##### [sendMessage](../hmssdk_flutter/HMSMeeting/sendMessage.md)([String](https://api.flutter.dev/flutter/dart-core/String-class.html) message) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



send message to the room and the pass the <code>message</code>.   




##### [startCapturing](../hmssdk_flutter/HMSMeeting/startCapturing.md)() void



it will start capturing the local video.   




##### [stopCapturing](../hmssdk_flutter/HMSMeeting/stopCapturing.md)() void



it will stop capturing the local video.   




##### [switchAudio](../hmssdk_flutter/HMSMeeting/switchAudio.md)({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch local audio on/off.
just pass false or true to switchAudio   




##### [switchCamera](../hmssdk_flutter/HMSMeeting/switchCamera.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch camera to front or rear.   




##### [switchVideo](../hmssdk_flutter/HMSMeeting/switchVideo.md)({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch local video on/off.
///just pass false or true to switchVideo   




##### [toString](https://api.flutter.dev/flutter/dart-core/Object/toString.html)() [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



A string representation of this object. [...](https://api.flutter.dev/flutter/dart-core/Object/toString.html)  
_inherited_




## Operators

##### [operator ==](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other) [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



The equality operator. [...](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)  
_inherited_











