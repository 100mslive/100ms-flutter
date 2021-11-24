import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/src/provider.dart';
import 'package:should_rebuild/should_rebuild.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoTile extends StatefulWidget {
  final tileIndex;
  final List<HMSTrack> filteredList;
  final double itemHeight;
  final double itemWidth;
  final Map<String, HMSTrackUpdate> map;

  VideoTile(
      {required this.tileIndex,
      required this.filteredList,
      required this.itemHeight,
      required this.itemWidth,
      required this.map});

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  void initState() {
    super.initState();

    String trackId = widget.filteredList[widget.tileIndex].trackId;
    widget.map[trackId] = widget.filteredList[widget.tileIndex].isMute
        ? HMSTrackUpdate.trackMuted
        : HMSTrackUpdate.trackUnMuted;
    print(
        "----------------------------Init Called for user ${widget.filteredList[widget.tileIndex].peer?.name}-------------------------------------");
  }

  @override
  void dispose() {
    super.dispose();
    String trackId = widget.filteredList[widget.tileIndex].trackId;
    print("Dispose $trackId}");
    widget.map[trackId] = HMSTrackUpdate.trackMuted;
    print(
        "----------------------------Dispose Called for user ${widget.filteredList[widget.tileIndex].isMute} ${widget.filteredList[widget.tileIndex].peer?.name}-------------------------------------");
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();

    return Observer(
      builder: (context) {

        int index = widget.tileIndex;
        print("$index after rebuildig");
        return InkWell(
          onLongPress: () {
            if (!widget.filteredList[index].peer!.isLocal &&
                widget.filteredList[index].source != "SCREEN")
              showDialog(
                  context: context,
                  builder: (_) => Column(
                        children: [
                          ChangeTrackOptionDialog(
                              isAudioMuted: _meetingStore.audioTrackStatus[
                                      widget.filteredList[index].trackId] ==
                                  HMSTrackUpdate.trackMuted,
                              isVideoMuted: widget
                                      .map[widget.filteredList[index].trackId] ==
                                  HMSTrackUpdate.trackMuted,
                              peerName:
                                  widget.filteredList[index].peer?.name ?? '',
                              changeTrack: (mute, isVideoTrack) {
                                Navigator.pop(context);
                                if (widget.filteredList[index].source != "SCREEN")
                                  _meetingStore.changeTrackRequest(
                                      widget.filteredList[index].peer?.peerId ??
                                          "",
                                      mute,
                                      isVideoTrack);
                              },
                              removePeer: () {
                                Navigator.pop(context);
                                _meetingStore.removePeerFromRoom(
                                    widget.filteredList[index].peer!.peerId);
                              }),
                        ],
                      ));
          },
          child: Observer(
            builder: (context) {

              return PeerItemOrganism(
                  setMirror: widget.filteredList[index].peer?.isLocal ?? false,
                  key: Key(widget.filteredList[index].trackId),
                  height: widget.itemHeight,
                  width: widget.itemWidth,
                  track: widget.filteredList[index],
                  isVideoMuted: widget.filteredList[index].peer!.isLocal
                      ? !_meetingStore.isVideoOn
                      : (widget.map[trackId]) == HMSTrackUpdate.trackMuted);
            }
          ),
        );
      }
    );
  }
}