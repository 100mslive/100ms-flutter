# Preview

Preview screen is a frequently used UX element which allows users to check if their input devices are working properly and set the initial state (mute/unmute) of their audio and video tracks before joining. 100ms SDKs provide an easy-to-use API to back this feature. Additionally, the SDK will try to establish a connection to 100ms server to verify there are no network issues and that the auth credentials are valid so that if everything is in order the subsequent room join is instant.

## Preview video
To invoke this API call

```dart:
/// meeting is object of HMSMeeting and config is an object of HMSConfig

meeting.previewVideo(config:config);

```


## Preview listener
`HMSPreviewListener` is a listener class which can gets callbacks about preview video.

Following functions are present in `HMSPreviewListener`.

```dart:

  /// when an error is caught [onError] will be called

  void onError({required HMSError error});


  ///when you want to preview listen to this callback
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - localTracks: local audio/video tracks list

  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});

```


You would need the same config object that you would pass to <a href="https://docs.100ms.live/flutter/v2/features/join">join API</a>. The interface to render video, mute/unmute etc. remains the same.