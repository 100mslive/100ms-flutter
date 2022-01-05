---
title: HMS Logger
nav: 3.92
---

HMSLogger is a logging api that lets you see all the other api logs as they are called. Instead of logging the values on your app in each and every function you can easily monitor and debug via these logs.  
## HMS Log Class

```dart
class HMSLog {
  HMSLogLevel level;
  String tag;
  String message;
  bool isWebRtcLog;
  }
```

## Example

```dart
//create HMSLog Object
var logger = new HMSLog();


```
## HMSLogLevel

You can subscribe to different log levels by passing HMSLogLevel enums to HMSLog

```dart
//HMSLogLevel enums

enum HMSLogLevel {
    VERBOSE,
    DEBUG,
    INFO,
    WARN,
    ERROR,
    OFF,
    Unknown
}
```


## Starting HMSLogger

```dart
    meeting.startHMSLogger(webRtclogLevel,logLevel);
```

## remove HMSLogger
```dart
    meeting.removeHMSLogger();
```

## HMSLogListener

HMSLogListener is an abstract class which has to be implemented if you want log updates

```dart

    abstract class HMSLogListener {
        void onLogMessage({required HMSLog});
    }

```