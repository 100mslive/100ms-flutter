///HMSUpdateListener listens to all the updates happening inside the room
///
/// Just implement this listener and get the updates add as many listeners as you want.
///
/// There are 10 callbacks which will be called on different changes in the room.a
///
/// Check more down below.
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/model/hms_peer_removed_from_room.dart';
import 'package:hmssdk_flutter/src/model/hms_track_change_request.dart';

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
  void onError({required HMSError error});

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

  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest});

  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer});
}
