


# operator == method




    *[<Null safety>](https://dart.dev/null-safety)*



- @[override](https://api.flutter.dev/flutter/dart-core/override-constant.html)

[bool](https://api.flutter.dev/flutter/dart-core/bool-class.html) operator ==
([Object](https://api.flutter.dev/flutter/dart-core/Object-class.html) other)

_override_



<p>important to compare using <a href="../../model_hms_peer/HMSPeer/peerId.md">peerId</a></p>



## Implementation

```dart
@override
bool operator ==(Object other) =>
    identical(this, other) ||
    other is HMSPeer &&
        runtimeType == other.runtimeType &&
        peerId == other.peerId;
```







