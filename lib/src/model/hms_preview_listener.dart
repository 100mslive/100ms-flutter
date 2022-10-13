///[HMSPreviewListener] listens to updates when you preview.
///
///Just implement it and get the preview updates.
///
/// Check out the [Sample App] how we are using it.

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

abstract class HMSPreviewListener {
  ///when an error is caught [onError] will be called
  ///
  /// - Parameters:
  ///   - error: error which you get.
  void onHMSError({required HMSException error});

  ///when you want to preview listen to this callback
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - localTracks: local audio/video tracks list
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});

  /// This is called when there is a change in any property of the Room
  ///
  /// To Enable [onRoomUpdate] activate Enable Room-State from dashboard under templates->Advance Settings.
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  /// This will be called whenever there is an update on an existing peer
  /// or a new peer got added/existing peer is removed.
  ///
  /// To Enable [onPeerUpdate] activate Send Peer List in Room-state from dashboard under templates->Advance Settings.
  ///
  /// This callback can be used to keep a track of all the peers in the room
  /// - Parameters:
  ///   - peer: the peer who joined/left or was updated
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  ///whenever a new audio device is plugged in or audio output is changed we
  ///get the onAudioDeviceChanged update
  ///This callback is only fired on Android devices. On iOS, this callback will not be triggered.
  /// - Parameters:
  ///   - currentAudioDevice: Current audio output route
  ///   - availableAudioDevice: List of available audio output devices
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice});
}
