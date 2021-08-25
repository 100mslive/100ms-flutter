# Preview

Preview screen is a frequently used UX element which allows users to check if their input devices are working properly and set the initial state (mute/unmute) of their audio and video tracks before joining. 100ms SDKs provide an easy-to-use API to back this feature. Additionally, the SDK will try to establish a connection to 100ms server to verify there are no network issues and that the auth credentials are valid so that if everything is in order the subsequent room join is instant.

To invoke this API call

```dart
    HMSMeeting meeting =  new HMSMeeting();
    meeting.previewVideo(hmsConfig);
```

you need HMSConfig instance which you have created.


Now you have started preview you need to listen to the updates.You got this 
PreviewUpdateListener.Just implement this 

```dart

abstract class HMSPreviewListener {
  ///when an error is caught [onError] will be called
  ///
  /// - Parameters:
  ///   - error: error which you get.
  void onError({required HMSError error});

  ///when you want to preview listen to this callback
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - localTracks: local audio/video tracks list
  void onPreview({required HMSRoom room, required List<HMSTrack>            localTracks});
    
}
```

This will pass an array of local tracks that you can display to the user (see Render Video and Mute sections for more details).

If however there was some error related to getting the input sources or some preflight check has failed delegate callback will be fired with the HMSError instance you can use to find what went wrong (see Error Handling).


add the `previewListener` instance to 

```dart
    PlatformService.addPreviewListener(previewListener);
```


 