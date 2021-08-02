// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MeetingStore on MeetingStoreBase, Store {
  final _$isSpeakerOnAtom = Atom(name: 'MeetingStoreBase.isSpeakerOn');

  @override
  bool get isSpeakerOn {
    _$isSpeakerOnAtom.reportRead();
    return super.isSpeakerOn;
  }

  @override
  set isSpeakerOn(bool value) {
    _$isSpeakerOnAtom.reportWrite(value, super.isSpeakerOn, () {
      super.isSpeakerOn = value;
    });
  }

  final _$errorAtom = Atom(name: 'MeetingStoreBase.error');

  @override
  HMSError? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(HMSError? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$isMeetingStartedAtom =
      Atom(name: 'MeetingStoreBase.isMeetingStarted');

  @override
  bool get isMeetingStarted {
    _$isMeetingStartedAtom.reportRead();
    return super.isMeetingStarted;
  }

  @override
  set isMeetingStarted(bool value) {
    _$isMeetingStartedAtom.reportWrite(value, super.isMeetingStarted, () {
      super.isMeetingStarted = value;
    });
  }

  final _$isVideoOnAtom = Atom(name: 'MeetingStoreBase.isVideoOn');

  @override
  bool get isVideoOn {
    _$isVideoOnAtom.reportRead();
    return super.isVideoOn;
  }

  @override
  set isVideoOn(bool value) {
    _$isVideoOnAtom.reportWrite(value, super.isVideoOn, () {
      super.isVideoOn = value;
    });
  }

  final _$isMicOnAtom = Atom(name: 'MeetingStoreBase.isMicOn');

  @override
  bool get isMicOn {
    _$isMicOnAtom.reportRead();
    return super.isMicOn;
  }

  @override
  set isMicOn(bool value) {
    _$isMicOnAtom.reportWrite(value, super.isMicOn, () {
      super.isMicOn = value;
    });
  }

  final _$peersAtom = Atom(name: 'MeetingStoreBase.peers');

  @override
  List<HMSPeer> get peers {
    _$peersAtom.reportRead();
    return super.peers;
  }

  @override
  set peers(List<HMSPeer> value) {
    _$peersAtom.reportWrite(value, super.peers, () {
      super.peers = value;
    });
  }

  final _$localPeerAtom = Atom(name: 'MeetingStoreBase.localPeer');

  @override
  HMSPeer? get localPeer {
    _$localPeerAtom.reportRead();
    return super.localPeer;
  }

  @override
  set localPeer(HMSPeer? value) {
    _$localPeerAtom.reportWrite(value, super.localPeer, () {
      super.localPeer = value;
    });
  }

  final _$tracksAtom = Atom(name: 'MeetingStoreBase.tracks');

  @override
  List<HMSTrack> get tracks {
    _$tracksAtom.reportRead();
    return super.tracks;
  }

  @override
  set tracks(List<HMSTrack> value) {
    _$tracksAtom.reportWrite(value, super.tracks, () {
      super.tracks = value;
    });
  }

  final _$messagesAtom = Atom(name: 'MeetingStoreBase.messages');

  @override
  List<HMSMessage> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(List<HMSMessage> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$toggleVideoAsyncAction = AsyncAction('MeetingStoreBase.toggleVideo');

  @override
  Future<void> toggleVideo() {
    return _$toggleVideoAsyncAction.run(() => super.toggleVideo());
  }

  final _$toggleCameraAsyncAction =
      AsyncAction('MeetingStoreBase.toggleCamera');

  @override
  Future<void> toggleCamera() {
    return _$toggleCameraAsyncAction.run(() => super.toggleCamera());
  }

  final _$toggleAudioAsyncAction = AsyncAction('MeetingStoreBase.toggleAudio');

  @override
  Future<void> toggleAudio() {
    return _$toggleAudioAsyncAction.run(() => super.toggleAudio());
  }

  final _$joinMeetingAsyncAction = AsyncAction('MeetingStoreBase.joinMeeting');

  @override
  Future<void> joinMeeting() {
    return _$joinMeetingAsyncAction.run(() => super.joinMeeting());
  }

  final _$sendMessageAsyncAction = AsyncAction('MeetingStoreBase.sendMessage');

  @override
  Future<void> sendMessage(String message) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(message));
  }

  final _$MeetingStoreBaseActionController =
      ActionController(name: 'MeetingStoreBase');

  @override
  void startListen() {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.startListen');
    try {
      return super.startListen();
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSpeaker() {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.toggleSpeaker');
    try {
      return super.toggleSpeaker();
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePeer(HMSPeer peer) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.removePeer');
    try {
      return super.removePeer(peer);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPeer(HMSPeer peer) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.addPeer');
    try {
      return super.addPeer(peer);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTrackWithTrackId(String trackId) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.removeTrackWithTrackId');
    try {
      return super.removeTrackWithTrackId(trackId);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeTrackWithPeerId(String peerId) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.removeTrackWithPeerId');
    try {
      return super.removeTrackWithPeerId(peerId);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addTrack(HMSTrack track) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.addTrack');
    try {
      return super.addTrack(track);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onRoleUpdated(int index, HMSPeer peer) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.onRoleUpdated');
    try {
      return super.onRoleUpdated(index, peer);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateError(HMSError error) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.updateError');
    try {
      return super.updateError(error);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void peerOperation(HMSPeer peer, HMSPeerUpdate update) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.peerOperation');
    try {
      return super.peerOperation(peer, update);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void peerOperationWithTrack(
      HMSPeer peer, HMSTrackUpdate update, HMSTrack track) {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.peerOperationWithTrack');
    try {
      return super.peerOperationWithTrack(peer, update, track);
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSpeakerOn: ${isSpeakerOn},
error: ${error},
isMeetingStarted: ${isMeetingStarted},
isVideoOn: ${isVideoOn},
isMicOn: ${isMicOn},
peers: ${peers},
localPeer: ${localPeer},
tracks: ${tracks},
messages: ${messages}
    ''';
  }
}
