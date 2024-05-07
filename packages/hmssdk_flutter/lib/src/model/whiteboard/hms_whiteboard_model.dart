//Project imports
import 'package:hmssdk_flutter/src/model/hms_peer.dart';

///[HMSWhiteboardModel] is a class which includes the properties of a whiteboard
class HMSWhiteboardModel {
  ///[id] is the unique identifier of the whiteboard
  final String id;

  ///[owner] is the owner of the whiteboard
  final HMSPeer? owner;

  ///[title] is the title of the whiteboard
  final String? title;

  ///[url] is the url of the whiteboard which can be used to display whiteboard
  final String? url;

  HMSWhiteboardModel({required this.id, this.owner, this.title, this.url});

  factory HMSWhiteboardModel.fromMap(Map map) {
    return HMSWhiteboardModel(
        id: map['id'],
        owner: map['owner'] != null ? HMSPeer.fromMap(map['owner']) : null,
        title: map['title'],
        url: map['url']);
  }
}
