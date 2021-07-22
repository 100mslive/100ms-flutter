
import 'package:hmssdk_flutter/model/hms_local_peer.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/sdk_store.dart';

class HMSRoom{
  String roomId;
  HMSLocalPeer localPeer;
  List<HMSPeer> peerList;
  String name;

  HMSRoom(this.roomId, this.localPeer, this.peerList, this.name);
}