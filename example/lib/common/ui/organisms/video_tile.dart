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

class VideoTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    MeetingStore _meetingStore = context.read<MeetingStore>();
    int index = tileIndex;
    if (index > 0 && filteredList[0].source == "SCREEN") {
      int a = index ~/ ((orientation == Orientation.portrait) ? 4 : 2);
      int b = index % ((orientation == Orientation.portrait) ? 4 : 2);

      index =
          (a - 1) * ((orientation == Orientation.portrait) ? 4 : 2) + (b + 1);
      //print("${a} a and b ${b} ${filteredList[index].peer!.name}");
    }

    if (index >= filteredList.length) return SizedBox();
    print("$index after rebuildig");
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
          return ShouldRebuild<PeerItemOrganism>(
            shouldRebuild: (oldWidget, newWidget) {
              return oldWidget.track != newWidget.track ||
                  oldWidget.isVideoMuted != newWidget.isVideoMuted ||
                  oldWidget.track.isHighestAudio !=
                      newWidget.track.isHighestAudio;
            },
            child: PeerItemOrganism(
                key: Key(index.toString()),
                height: itemHeight,
                width: itemWidth,
                track: filteredList[index],
                isVideoMuted: filteredList[index].peer!.isLocal
                    ? !_meetingStore.isVideoOn
                    : (map[filteredList[index].trackId]) ==
                        HMSTrackUpdate.trackMuted),
          );
        }),
      ),
    );
  }
}
