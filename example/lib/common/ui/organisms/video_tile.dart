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
  final List filteredList;
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
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    MeetingStore _meetingStore = context.read<MeetingStore>();
    int index = widget.tileIndex;
    if (index > 0 && widget.filteredList[0].source == "SCREEN") {
      int a = index ~/ ((orientation == Orientation.portrait) ? 4 : 2);
      int b = index % ((orientation == Orientation.portrait) ? 4 : 2);

      index =
          (a - 1) * ((orientation == Orientation.portrait) ? 4 : 2) + (b + 1);
      //print("${a} a and b ${b} ${filteredList[index].peer!.name}");
    }

    if (index >= widget.filteredList.length) return SizedBox();
    print("$index after rebuildig");
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;
        print("$index  ${widget.filteredList[index].peer!.name} lengthofFilteredList");
        String trackId = widget.filteredList[index].trackId;
        print(widget.filteredList[index].isMute);
        if (visiblePercentage <= 40) {
          widget.map[trackId] = HMSTrackUpdate.trackMuted;
        } else {
          widget.map[trackId] = widget.filteredList[index].isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
          print(widget.map[trackId]);
        }
        debugPrint(
            'Widget ${info.key} is $visiblePercentage% visible and index is $index');
      },
      key: Key(widget.filteredList[index].trackId),
      child: InkWell(
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
                            isVideoMuted: widget.map[widget.filteredList[index].trackId] ==
                                HMSTrackUpdate.trackMuted,
                            peerName: widget.filteredList[index].peer?.name ?? '',
                            changeTrack: (mute, isVideoTrack) {
                              Navigator.pop(context);
                              if (widget.filteredList[index].source != "SCREEN")
                                _meetingStore.changeTrackRequest(
                                    widget.filteredList[index].peer?.peerId ?? "",
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
        child: Observer(builder: (context) {
          print("${widget.filteredList[index].peer?.name} rebuildingonaudio");
          return PeerItemOrganism(
              setMirror: widget.filteredList[index].peer?.isLocal??false,
              key: Key(index.toString()),
              height: widget.itemHeight,
              width: widget.itemWidth,
              track: widget.filteredList[index],
              isVideoMuted: widget.filteredList[index].peer!.isLocal
                  ? !_meetingStore.isVideoOn
                  : (widget.map[widget.filteredList[index].trackId]) ==
                  HMSTrackUpdate.trackMuted);
        }),
      ),
    );
  }
}
