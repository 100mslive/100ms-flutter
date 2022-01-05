---
title: Set Track Settings
nav: 3.95
---

You can customize local peer's Audio & Video track settings while creating instance of 100ms SDK.


These settings are a optional parameter and meant to be passed in the HMSMeeting Constructor as `hmsTrackSetting` parameter which is a `HMSTrackSetting` object.


You can set the quality and description of the Audio tracks with props like maxBitrate and trackDescription. 


Similarly, for Video tracks you can use props like maxBitrate, maxFrameRate, cameraFacing, resolution and trackDescription.


## maxBitrate
Property specifies the maximum number of bits per second to allow a track.

## maxFrameRate
Frames Per Second is used to measure frame rate – the number of consecutive full-screen images that are displayed each second

## cameraFacing
Property specifies which camera to open while joining. It can be toggled later on.

```dart
HMSCameraFacing.FRONT
HMSCameraFacing.BACK
HMSCameraFacing.unknown
```

## resolution
Video resolution is the number of pixels contained in each frame. 
Video resolution determines the amount of detail in your video or how realistic and clear the video appears.

```dart

var audioSettings = HMSAudioTrackSettings( 
    hmsAudioCodec: HMSAudioCodec.opus,                    
    maxBitrate: 32,  
    useHardwareAcousticEchoCanceler:true                    
     );

var videoSettings=HMSVideoTrackSettings(
    codec: HMSVideoCodec.VP8,                     
    maxBitrate: 512,                              
    maxFrameRate: 25,                             
    cameraFacing: HMSCameraFacing.FRONT,               
    resolution: HMSVideoResolution({height: 180, width: 320}), 
  );

var hmstracksetting= HMSTrackSettings(
    video: videoSettings,
    audio: audioSettings,
 );

var meeting  =  HMSMeeting(trackSettings);
meeting.build();
```


