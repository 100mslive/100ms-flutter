import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/change_track_options.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:mobx/mobx.dart';
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
      {Key? key,
      required this.tileIndex,
      required this.filteredList,
      required this.itemHeight,
      required this.itemWidth,
      required this.map})
      : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    var index = widget.tileIndex;
    List<HMSTrack> filteredList = widget.filteredList;
    Map<String, HMSTrackUpdate> map = widget.map;
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        var visiblePercentage = info.visibleFraction * 100;
        print("$index  ${filteredList[index].peer!.name} lengthofFilteredList");
        String trackId = filteredList[index].trackId;
        print(filteredList[index].isMute);
        if (visiblePercentage <= 40) {
          map[trackId] = HMSTrackUpdate.trackMuted;
        } else {
          map[trackId] = filteredList[index].isMute
              ? HMSTrackUpdate.trackMuted
              : HMSTrackUpdate.trackUnMuted;
          print(map[trackId]);
        }
        debugPrint(
            'Widget ${info.key} is $visiblePercentage% visible and index is $index');
      },
      key: Key(filteredList[index].trackId),
      child: InkWell(
        onLongPress: () {
          if (!filteredList[index].peer!.isLocal &&
              filteredList[index].source != "SCREEN")
            showDialog(
                context: context,
                builder: (_) => Column(
                      children: [
                        ChangeTrackOptionDialog(
                            isAudioMuted: _meetingStore.audioTrackStatus[
                                    filteredList[index].trackId] ==
                                HMSTrackUpdate.trackMuted,
                            isVideoMuted: map[filteredList[index].trackId] ==
                                HMSTrackUpdate.trackMuted,
                            peerName: filteredList[index].peer?.name ?? '',
                            changeTrack: (mute, isVideoTrack) {
                              Navigator.pop(context);
                              if (filteredList[index].source != "SCREEN")
                                _meetingStore.changeTrackRequest(
                                    filteredList[index].peer?.peerId ?? "",
                                    mute,
                                    isVideoTrack);
                            },
                            removePeer: () {
                              Navigator.pop(context);
                              _meetingStore.removePeerFromRoom(
                                  filteredList[index].peer!.peerId);
                            }),
                      ],
                    ));
        },
        child: Observer(builder: (context) {
          print("${filteredList[index].peer?.name} rebuildingonaudio");
          return PeerItemOrganism(
              key: Key(index.toString()),
              height: widget.itemHeight,
              width: widget.itemWidth,
              track: filteredList[index],
              isVideoMuted: filteredList[index].peer!.isLocal
                  ? !_meetingStore.isVideoOn
                  : (map[filteredList[index].trackId]) ==
                      HMSTrackUpdate.trackMuted);
        }),
      ),
    );
  }
}
