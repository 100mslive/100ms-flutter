// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///100ms HMSUpdateListener
///
/// 100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing HMSUpdateListener.
///
/// Implement this listener in a class where you want to perform UI Actions, update App State, etc. These updates can be used to render the video on screen or to display other info regarding the room.
///
/// Depending on your use case, you'll need to implement specific methods of the Update Listener. The most common ones are onJoin, onPeerUpdate, onTrackUpdate & onHMSError.
abstract class HMSUpdateListener {
  /// This will be called on a successful JOIN of the room by the user
  ///
  /// This is the point where applications can stop showing its loading state
  /// - Parameter room: the room which was joined
  void onJoin({required HMSRoom room});

  /// This will be called whenever there is an update on an existing peer
  /// or a new peer got added/existing peer is removed.
  ///
  /// This callback can be used to keep a track of all the peers in the room
  /// - Parameters:
  ///   - peer: the peer who joined/left or was updated
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update});

  /// This is called when there are updates on an existing track
  /// or a new track got added/existing track is removed
  ///
  /// This callback can be used to render the video on screen whenever a track gets added
  /// - Parameters:
  ///   - track: the track which was added, removed or updated
  ///   - trackUpdate: the triggered update type
  ///   - peer: the peer for which track was added, removed or updated
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer});

  /// This will be called when there is an error in the system
  ///
  /// and SDK has already retried to fix the error
  /// - Parameter error: the error that occurred
  void onHMSError({required HMSException error});

  /// This is called when there is a change in any property of the Room
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

  /// This is called when there is a new broadcast message from any other peer in the room
  ///
  /// This can be used to implement chat is the room
  /// - Parameter message: the received broadcast message
  void onMessage({required HMSMessage message});

  /// This is called every 1 second with list of active speakers
  ///
  /// ## A HMSSpeaker object contains -
  ///    - peerId: the peer identifier of HMSPeer who is speaking
  ///    - trackId: the track identifier of HMSTrack which is emitting audio
  ///    - audioLevel: a number within range 1-100 indicating the audio volume
  ///
  /// A peer who is not present in the list indicates that the peer is not speaking
  ///
  /// This can be used to highlight currently speaking peers in the room
  /// - Parameter speakers: the list of speakers
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers});

  /// When network connection is lost & the SDK is trying to reconnect to the room
  void onReconnecting();

  /// When you are back in the room after network connection was lost
  void onReconnected();

  /// This is called when someone asks for change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

  /// When someone requests for track change of your Audio, Video or an Auxiliary track like Screenshare, this event will be triggered
  /// - Parameter hmsTrackChangeRequest: request instance consisting of all the required info about track change
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest});

  /// When someone kicks you out or when someone ends the room at that time it is triggered
  /// - Parameter hmsPeerRemovedFromPeer - it consists info about who removed you and why.
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer});

  /// Whenever a new audio device is plugged in or audio output is changed we get the onAudioDeviceChanged update
  /// This callback is only fired on Android devices. On iOS, this callback will not be triggered.
  /// - Parameters:
  ///   - currentAudioDevice: Current audio output route
  ///   - availableAudioDevice: List of available audio output devices
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice});

  /// Whenever a user joins a room [onSessionStoreAvailable] is fired to get an instance of [HMSSessionStore]
  /// which can be used to perform session metadata operations
  /// - Parameters:
  ///   - hmsSessionStore: An instance of HMSSessionStore which will be used to call session metadata methods
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore});

  ///Upon joining a room with existing peers, onPeerListUpdated will be called with the list of peers present
  ///in the room instead of getting onPeerUpdate for each peer in the room.
  ///Subsequent peer joins/leaves would be notified via both onPeerUpdate and onPeerListUpdated
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers, required List<HMSPeer> removedPeers});
}
