// Package imports
import 'package:flutter/material.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/brb_tag.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/hand_raise.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_mute_status.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/network_icon_widget.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_name.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile_border.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/rtc_stats_view.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

import 'change_track_options.dart';

class AudioTile extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  AudioTile({this.itemHeight = 200.0, this.itemWidth = 200.0, Key? key})
      : super(key: key);

  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();

    bool mutePermission =
        _meetingStore.localPeer?.role.permissions.mute ?? false;
    bool unMutePermission =
        _meetingStore.localPeer?.role.permissions.unMute ?? false;
    bool removePeerPermission =
        _meetingStore.localPeer?.role.permissions.removeOthers ?? false;

    return InkWell(
      onLongPress: () {
        var peerTrackNode = context.read<PeerTrackNode>();
        HMSPeer peerNode = peerTrackNode.peer;
        if (!mutePermission || !unMutePermission || !removePeerPermission)
          return;
        if (peerTrackNode.peer.peerId != _meetingStore.localPeer!.peerId)
          showDialog(
              context: context,
              builder: (_) => Column(
                    children: [
                      ChangeTrackOptionDialog(
                          isAudioMuted:
                              peerTrackNode.audioTrack?.isMute ?? true,
                          isVideoMuted: peerTrackNode.track == null
                              ? true
                              : peerTrackNode.track!.isMute,
                          peerName: peerNode.name,
                          changeVideoTrack: (mute, isVideoTrack) {
                            Navigator.pop(context);
                            _meetingStore.changeTrackState(
                                peerTrackNode.track!, mute);
                          },
                          changeAudioTrack: (mute, isAudioTrack) {
                            Navigator.pop(context);
                            _meetingStore.changeTrackState(
                                peerTrackNode.audioTrack!, mute);
                          },
                          removePeer: () async {
                            Navigator.pop(context);
                            var peer = await _meetingStore.getPeer(
                                peerId: peerNode.peerId);
                            _meetingStore.removePeerFromRoom(peer!);
                          },
                          mute: mutePermission,
                          unMute: unMutePermission,
                          removeOthers: removePeerPermission),
                    ],
                  ));
      },
      child: Container(
        color: Colors.transparent,
        key: key,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(2),
        height: itemHeight + 110,
        width: itemWidth - 5.0,
        child: Stack(
          children: [
            Center(
                child: CircleAvatar(
                    backgroundColor: Utilities.getBackgroundColour(
                        context.read<PeerTrackNode>().peer.name),
                    radius: 36,
                    child: Text(
                      Utilities.getAvatarTitle(
                          context.read<PeerTrackNode>().peer.name),
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ))),
            PeerName(),
            HandRaise(), //bottom left
            BRBTag(), //top right
            NetworkIconWidget(), //top left
            AudioMuteStatus(), //bottom center
            RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
            VideoTileBorder(
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                uid: context.read<PeerTrackNode>().uid)
          ],
        ),
      ),
    );
  }
}
