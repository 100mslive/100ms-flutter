// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MeetingStore on MeetingStoreBase, Store {
  late final _$hmsExceptionAtom =
      Atom(name: 'MeetingStoreBase.hmsException', context: context);

  @override
  HMSException? get hmsException {
    _$hmsExceptionAtom.reportRead();
    return super.hmsException;
  }

  @override
  set hmsException(HMSException? value) {
    _$hmsExceptionAtom.reportWrite(value, super.hmsException, () {
      super.hmsException = value;
    });
  }

  late final _$isVideoOnAtom =
      Atom(name: 'MeetingStoreBase.isVideoOn', context: context);

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

  late final _$isMicOnAtom =
      Atom(name: 'MeetingStoreBase.isMicOn', context: context);

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

  late final _$isScreenShareOnAtom =
      Atom(name: 'MeetingStoreBase.isScreenShareOn', context: context);

  @override
  bool get isScreenShareOn {
    _$isScreenShareOnAtom.reportRead();
    return super.isScreenShareOn;
  }

  @override
  set isScreenShareOn(bool value) {
    _$isScreenShareOnAtom.reportWrite(value, super.isScreenShareOn, () {
      super.isScreenShareOn = value;
    });
  }

  late final _$isRoomEndedAtom =
      Atom(name: 'MeetingStoreBase.isRoomEnded', context: context);

  @override
  bool get isRoomEnded {
    _$isRoomEndedAtom.reportRead();
    return super.isRoomEnded;
  }

  @override
  set isRoomEnded(bool value) {
    _$isRoomEndedAtom.reportWrite(value, super.isRoomEnded, () {
      super.isRoomEnded = value;
    });
  }

  late final _$trackStatusAtom =
      Atom(name: 'MeetingStoreBase.trackStatus', context: context);

  @override
  ObservableMap<String, HMSTrackUpdate> get trackStatus {
    _$trackStatusAtom.reportRead();
    return super.trackStatus;
  }

  @override
  set trackStatus(ObservableMap<String, HMSTrackUpdate> value) {
    _$trackStatusAtom.reportWrite(value, super.trackStatus, () {
      super.trackStatus = value;
    });
  }

  late final _$peerTracksAtom =
      Atom(name: 'MeetingStoreBase.peerTracks', context: context);

  @override
  ObservableList<PeerTrackNode> get peerTracks {
    _$peerTracksAtom.reportRead();
    return super.peerTracks;
  }

  @override
  set peerTracks(ObservableList<PeerTrackNode> value) {
    _$peerTracksAtom.reportWrite(value, super.peerTracks, () {
      super.peerTracks = value;
    });
  }

  late final _$joinAsyncAction =
      AsyncAction('MeetingStoreBase.join', context: context);

  @override
  Future<bool> join(String user, String roomUrl) {
    return _$joinAsyncAction.run(() => super.join(user, roomUrl));
  }

  late final _$toggleMicMuteStatusAsyncAction =
      AsyncAction('MeetingStoreBase.toggleMicMuteStatus', context: context);

  @override
  Future<void> toggleMicMuteStatus() {
    return _$toggleMicMuteStatusAsyncAction
        .run(() => super.toggleMicMuteStatus());
  }

  late final _$toggleCameraMuteStatusAsyncAction =
      AsyncAction('MeetingStoreBase.toggleCameraMuteStatus', context: context);

  @override
  Future<void> toggleCameraMuteStatus() {
    return _$toggleCameraMuteStatusAsyncAction
        .run(() => super.toggleCameraMuteStatus());
  }

  late final _$isScreenShareActiveAsyncAction =
      AsyncAction('MeetingStoreBase.isScreenShareActive', context: context);

  @override
  Future<void> isScreenShareActive() {
    return _$isScreenShareActiveAsyncAction
        .run(() => super.isScreenShareActive());
  }

  late final _$MeetingStoreBaseActionController =
      ActionController(name: 'MeetingStoreBase', context: context);

  @override
  void addUpdateListener() {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.addUpdateListener');
    try {
      return super.addUpdateListener();
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeUpdateListener() {
    final _$actionInfo = _$MeetingStoreBaseActionController.startAction(
        name: 'MeetingStoreBase.removeUpdateListener');
    try {
      return super.removeUpdateListener();
    } finally {
      _$MeetingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hmsException: ${hmsException},
isVideoOn: ${isVideoOn},
isMicOn: ${isMicOn},
isScreenShareOn: ${isScreenShareOn},
isRoomEnded: ${isRoomEnded},
trackStatus: ${trackStatus},
peerTracks: ${peerTracks}
    ''';
  }
}
