


# HMSPeer class






    *[<Null safety>](https://dart.dev/null-safety)*








**Implementers**

- [HMSLocalPeer](../model_hms_local_peer/HMSLocalPeer-class.md)



## Constructors

[HMSPeer](../model_hms_peer/HMSPeer/HMSPeer.md) ({required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) peerId, required [String](https://api.flutter.dev/flutter/dart-core/String-class.html) name, required [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) isLocal, [HMSRole](../model_hms_role/HMSRole-class.md)? role, [String](https://api.flutter.dev/flutter/dart-core/String-class.html)? customerUserId, [String](https://api.flutter.dev/flutter/dart-core/String-class.html)? customerDescription, [HMSAudioTrack](../model_hms_audio_track/HMSAudioTrack-class.md)? audioTrack, [HMSVideoTrack](../model_hms_video_track/HMSVideoTrack-class.md)? videoTrack, [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSTrack](../model_hms_track/HMSTrack-class.md)>? auxiliaryTracks})

    

[HMSPeer.fromMap](../model_hms_peer/HMSPeer/HMSPeer.fromMap.md) ([Map](https://api.flutter.dev/flutter/dart-core/Map-class.html) map)

    _factory_


## Properties

##### [audioTrack](../model_hms_peer/HMSPeer/audioTrack.md) &#8594; [HMSAudioTrack](../model_hms_audio_track/HMSAudioTrack-class.md)?



   
_final_



##### [auxiliaryTracks](../model_hms_peer/HMSPeer/auxiliaryTracks.md) &#8594; [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSTrack](../model_hms_track/HMSTrack-class.md)>?



   
_final_



##### [customerDescription](../model_hms_peer/HMSPeer/customerDescription.md) &#8594; [String](https://api.flutter.dev/flutter/dart-core/String-class.html)?



   
_final_



##### [customerUserId](../model_hms_peer/HMSPeer/customerUserId.md) &#8594; [String](https://api.flutter.dev/flutter/dart-core/String-class.html)?



   
_final_



##### [hashCode](../model_hms_peer/HMSPeer/hashCode.md) &#8594; [int](https://api.flutter.dev/flutter/dart-core/int-class.html)



The hash code for this object. [...](../model_hms_peer/HMSPeer/hashCode.md)  
_read-only, override_



##### [isLocal](../model_hms_peer/HMSPeer/isLocal.md) &#8594; [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



returns whether peer is local or not.   
_final_



##### [name](../model_hms_peer/HMSPeer/name.md) &#8594; [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



name of the peer in the room.   
_final_



##### [peerId](../model_hms_peer/HMSPeer/peerId.md) &#8594; [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



id of the peer   
_final_



##### [role](../model_hms_peer/HMSPeer/role.md) &#8594; [HMSRole](../model_hms_role/HMSRole-class.md)?



role of the peer in the room.   
_final_



##### [runtimeType](https://api.flutter.dev/flutter/dart-core/Object/runtimeType.html) &#8594; [Type](https://api.flutter.dev/flutter/dart-core/Type-class.html)



A representation of the runtime type of the object.   
_read-only, inherited_



##### [videoTrack](../model_hms_peer/HMSPeer/videoTrack.md) &#8594; [HMSVideoTrack](../model_hms_video_track/HMSVideoTrack-class.md)?



   
_final_




## Methods

##### [noSuchMethod](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)([Invocation](https://api.flutter.dev/flutter/dart-core/Invocation-class.html) invocation) dynamic



Invoked when a non-existent method or property is accessed. [...](https://api.flutter.dev/flutter/dart-core/Object/noSuchMethod.html)  
_inherited_



##### [toString](../model_hms_peer/HMSPeer/toString.md)() [String](https://api.flutter.dev/flutter/dart-core/String-class.html)



A string representation of this object. [...](../model_hms_peer/HMSPeer/toString.md)  
_override_




## Operators

##### [operator ==](../model_hms_peer/HMSPeer/operator_equals.md)([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other) [bool](https://api.flutter.dev/flutter/dart-core/bool-class.html)



important to compare using <a href="../model_hms_peer/HMSPeer/peerId.md">peerId</a>   
_override_





## Static Methods

##### [fromListOfMap](../model_hms_peer/HMSPeer/fromListOfMap.md)([List](https://api.flutter.dev/flutter/dart-core/List-class.html) peersMap) [List](https://api.flutter.dev/flutter/dart-core/List-class.html)&lt;[HMSPeer](../model_hms_peer/HMSPeer-class.md)>



   










