


# HMSMeeting class






    *[<Null safety>](https://dart.dev/null-safety)*






## Constructors

[HMSMeeting](../meeting_meeting/HMSMeeting/HMSMeeting.md) ()

    


## Properties

##### [hashCode](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html) &#8594; [int](https://api.flutter.dev/flutter/dart-core/int-class.html)



The hash code for this object. [...](https://api.flutter.dev/flutter/dart-core/Object/hashCode.html)  
_read-only, inherited_



##### [runtimeType](https://api.flutter.dev/flutter/dart-core/Object/runtimeType.html) &#8594; [Type](https://api.flutter.dev/flutter/dart-core/Type-class.html)



A representation of the runtime type of the object.   
_read-only, inherited_




## Methods

##### [acceptRoleChangerequest](../meeting_meeting/HMSMeeting/acceptRoleChangerequest.md)() void



accept the role changes.   




##### [addMeetingListener](../meeting_meeting/HMSMeeting/addMeetingListener.md)([HMSUpdateListener](../model_hms_update_listener/HMSUpdateListener-class.md) listener) void



add MeetingListener it will add all the listeners.   




##### [addPreviewListener](../meeting_meeting/HMSMeeting/addPreviewListener.md)([HMSPreviewListener](../model_hms_preview_listener/HMSPreviewListener-class.md) listener) void



add one or more previewListeners.   




##### [changeRole](../meeting_meeting/HMSMeeting/changeRole.md)({required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) peerId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) roleName, [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) forceChange = false}) void



you can change role of any peer in the room just pass <code>peerId</code> and <code>roleName</code>, <code>forceChange</code> is optional.   




##### [getRoles](../meeting_meeting/HMSMeeting/getRoles.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSRole](../model_hms_role/HMSRole-class.md)>>



returns all the roles associated with the link used   




##### [isAudioMute](../meeting_meeting/HMSMeeting/isAudioMute.md)([HMSPeer](../model_hms_peer/HMSPeer-class.md)? peer) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)>



checks the audio is mute or unmute just pass <code>peer</code>   




##### [isVideoMute](../meeting_meeting/HMSMeeting/isVideoMute.md)([HMSPeer](../model_hms_peer/HMSPeer-class.md)? peer) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)>



checks the video is mute or unmute just pass <code>peer</code>   




##### [joinMeeting](../meeting_meeting/HMSMeeting/joinMeeting.md)({required [HMSConfig](../model_hms_config/HMSConfig-class.md) config}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



join meeting by passing HMSConfig instance to it.   




##### [leaveMeeting](../meeting_meeting/HMSMeeting/leaveMeeting.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



just call this method to leave meeting.   




##### [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)([Invocation](https://api.flutter.dev/flutter/dart-core/Invocation-class.html) invocation) dynamic



Invoked when a non-existent method or property is accessed. [...](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)  
_inherited_



##### [previewVideo](../meeting_meeting/HMSMeeting/previewVideo.md)({required [HMSConfig](../model_hms_config/HMSConfig-class.md) config}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



preview before joining the room pass <a href="../model_hms_config/HMSConfig-class.md">HMSConfig</a>.   




##### [removeMeetingListener](../meeting_meeting/HMSMeeting/removeMeetingListener.md)([HMSUpdateListener](../model_hms_update_listener/HMSUpdateListener-class.md) listener) void



remove a meetListener.   




##### [removePreviewListener](../meeting_meeting/HMSMeeting/removePreviewListener.md)([HMSPreviewListener](../model_hms_preview_listener/HMSPreviewListener-class.md) listener) void



remove a previewListener.   




##### [sendMessage](../meeting_meeting/HMSMeeting/sendMessage.md)([String](https://api.flutter.dev/flutter/dart-core/String-class.html) message) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



send message to the room and the pass the <code>message</code>.   




##### [startCapturing](../meeting_meeting/HMSMeeting/startCapturing.md)() void



it will start capturing the local video.   




##### [stopCapturing](../meeting_meeting/HMSMeeting/stopCapturing.md)() void



it will stop capturing the local video.   




##### [switchAudio](../meeting_meeting/HMSMeeting/switchAudio.md)({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch local audio on/off.
just pass false or true to switchAudio   




##### [switchCamera](../meeting_meeting/HMSMeeting/switchCamera.md)() [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch camera to front or rear.   




##### [switchVideo](../meeting_meeting/HMSMeeting/switchVideo.md)({[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isOn = false}) [Future](https://api.flutter.dev/flutter/dart-async/Future-class.html)&lt;void>



switch local video on/off.
///just pass false or true to switchVideo   




##### [toString](https://api.flutter.dev/flutter/dart-core/Object/toString.html)() [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



A string representation of this object. [...](https://api.flutter.dev/flutter/dart-core/Object/toString.html)  
_inherited_




## Operators

##### [operator ==](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other) [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



The equality operator. [...](https://api.flutter.dev/flutter/dart-core/Object/operator_equals.html)  
_inherited_











