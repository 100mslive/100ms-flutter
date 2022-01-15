// Package imports
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final tileIndex;
  final List<PeerTracKNode> filteredList;
  final double itemHeight;
  final double itemWidth;
  final Map<String, HMSTrackUpdate> trackStatus;
  final Map<String, String> observerMap;
  final bool audioView;
  VideoTile({
    Key? key,
    required this.tileIndex,
    required this.filteredList,
    this.itemHeight = 200.0,
    this.itemWidth = 200.0,
    required this.trackStatus,
    required this.observerMap,
    required this.audioView,
  }) : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    var index = widget.tileIndex;
    var filteredList = widget.filteredList;

    if (index >= filteredList.length) return SizedBox();

    Map<String, HMSTrackUpdate> trackStatus = widget.trackStatus;
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        if (index >= filteredList.length) return;
        var visiblePercentage = info.visibleFraction * 100;
        String peerId = filteredList[index].peerId;
        if (visiblePercentage <= 40) {
          trackStatus[peerId] = HMSTrackUpdate.trackMuted;
        } else {
          trackStatus[peerId] = (widget.audioView)
              ? HMSTrackUpdate.trackMuted
              : filteredList[index].track?.isMute ?? true
                  ? HMSTrackUpdate.trackMuted
                  : HMSTrackUpdate.trackUnMuted;
        }
      },
      key: Key(filteredList[index].peerId),
      child: InkWell(
        onLongPress: () {
          if (!widget.audioView &&
              filteredList[index].peerId != _meetingStore.localPeer!.peerId)
            showDialog(
                context: context,
                builder: (_) => Column(
                      children: [
                        ChangeTrackOptionDialog(
                            isAudioMuted:
                                filteredList[index].audioTrack?.isMute,
                            isVideoMuted: filteredList[index].track == null
                                ? true
                                : filteredList[index].track?.isMute,
                            peerName: filteredList[index].name,
                            changeTrack: (mute, isVideoTrack) async {
                              Navigator.pop(context);
                              var peer = await _meetingStore.getPeer(
                                  peerId: filteredList[index].peerId);
                              _meetingStore.changeTrackState(
                                  peer!, mute, isVideoTrack);
                            },
                            removePeer: () async {
                              Navigator.pop(context);
                              var peer = await _meetingStore.getPeer(
                                  peerId: filteredList[index].peerId);
                              _meetingStore.removePeerFromRoom(peer!);
                            }),
                      ],
                    ));
        },
        child: Observer(builder: (context) {
          return PeerItemOrganism(
              observableMap: widget.observerMap,
              key: Key(index.toString()),
              height: widget.itemHeight,
              width: widget.itemWidth,
              peerTracKNode: filteredList[index],
              isVideoMuted: (widget.audioView)
                  ? true
                  : (trackStatus[filteredList[index].peerId]) ==
                      HMSTrackUpdate.trackMuted);
        }),
      ),
    );
  }
}
