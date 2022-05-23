///HMSUpdateListener listens to all the updates happening inside the room
///
/// Just implement this listener and get the updates add as many listeners as you want.
///
/// There are 10 callbacks which will be called on different changes in the room.a
///
/// Check more down below.

// Project imports:
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// 100ms SDK provides callbacks to the client app about any change or update happening in the room after a user has joined by implementing HMSUpdateListener.
/// These updates can be used to render the video on screen or to display other info regarding the room.
abstract class HMSUpdateListener {
  /// This will be called on a successful JOIN of the room by the user
  ///
  /// This is the point where applications can stop showing its loading state
  /// - Parameter room: the room which was joined
  void onJoin({required HMSRoom room});

  /// This is called when there is a change in any property of the Room
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - update: the triggered update type. Should be used to perform different UI Actions
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update});

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
  void onError({required HMSException error});

  /// This is called when there is a new broadcast message from any other peer in the room
  ///
  /// This can be used to implement chat is the room
  /// - Parameter message: the received broadcast message
  void onMessage({required HMSMessage message});

  /// This is called when someone asks for change or role
  ///
  /// for eg. admin can ask a peer to become host from guest.
  /// this triggers this call on peer's app
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest});

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

  ///when network or some other error happens it will be called
  void onReconnecting();

  ///when you are back in the room after reconnection
  void onReconnected();

  ///when someone requests for track change of yours be it video or audio this will be triggered
  /// - Parameter hmsTrackChangeRequest: request instance consisting of all the required info about track change
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest});

  ///when someone kicks you out or when someone ends the room at that time it is triggered
  ///- Paramter hmsPeerRemovedFromPeer - it consists info about who removed you and why.
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer});

}
