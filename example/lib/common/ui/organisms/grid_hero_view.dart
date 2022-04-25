import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

List<Widget> gridHeroView(
    {required List<PeerTrackNode> peerTracks,
    required bool audioViewOn,
    required int itemCount,
    required int screenShareOn,
    required Size size}) {
  int index = 0;
  List<Widget> gridView = [];

  int numberofPages = (((itemCount - index) ~/ 4).toInt() +
      ((itemCount - index) % 4 == 0 ? 0 : 1));
  for (int i = 0; i < numberofPages; i++) {
    if (i == 0) {
      gridView.add(customHeroGrid(
          peerTracks.sublist(
              index, (index + 4 < itemCount) ? index + 4 : itemCount),
          audioViewOn,
          size,
          screenShareOn > 0));
      index += 4;
    } else {
      gridView.add(customGrid(
          peerTracks.sublist(
              index, (index + 4 < itemCount) ? index + 4 : itemCount),
          audioViewOn,
          size));
      index += 4;
    }
  }
  return gridView;
}

Widget customHeroGrid(List<PeerTrackNode> peerTracks, audioViewOn, Size size,
    bool screenShareOn) {
  return Container(
    child: Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: ChangeNotifierProvider.value(
                value: peerTracks[0],
                child: VideoTile(
                  key: Key(peerTracks[0].uid),
                  audioView: audioViewOn,
                  itemHeight: size.height,
                  itemWidth: size.width,
                  scaleType: screenShareOn
                      ? ScaleType.SCALE_ASPECT_FIT
                      : ScaleType.SCALE_ASPECT_FILL,
                )),
          ),
        ),
        if (peerTracks.length > 1)
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    child: ChangeNotifierProvider.value(
                        value: peerTracks[1],
                        child: VideoTile(
                          key: Key(peerTracks[1].uid),
                          audioView: audioViewOn,
                          itemHeight: size.height,
                          itemWidth: size.width,
                        )),
                  ),
                ),
                if (peerTracks.length > 2)
                  Flexible(
                    child: Container(
                      child: ChangeNotifierProvider.value(
                          value: peerTracks[2],
                          child: VideoTile(
                            key: Key(peerTracks[2].uid),
                            audioView: audioViewOn,
                            itemHeight: size.height,
                            itemWidth: size.width,
                          )),
                    ),
                  ),
                if (peerTracks.length > 3)
                  Flexible(
                    child: Container(
                      child: ChangeNotifierProvider.value(
                          value: peerTracks[3],
                          child: VideoTile(
                            key: Key(peerTracks[3].uid),
                            audioView: audioViewOn,
                            itemHeight: size.height,
                            itemWidth: size.width,
                          )),
                    ),
                  )
              ],
            ),
          )
      ],
    ),
  );
}

Widget customGrid(List<PeerTrackNode> peerTracks, audioViewOn, Size size) {
  return Container(
    child: Row(
      children: [
        if (peerTracks.length > 0)
          Flexible(
              child: Column(
            children: [
              Flexible(
                child: Container(
                  child: ChangeNotifierProvider.value(
                      value: peerTracks[0],
                      child: VideoTile(
                        key: Key(peerTracks[0].uid),
                        audioView: audioViewOn,
                        itemHeight: size.height,
                        itemWidth: size.width,
                      )),
                ),
              ),
              if (peerTracks.length > 1)
                Flexible(
                  child: Container(
                    child: ChangeNotifierProvider.value(
                        value: peerTracks[1],
                        child: VideoTile(
                          key: Key(peerTracks[1].uid),
                          audioView: audioViewOn,
                          itemHeight: size.height,
                          itemWidth: size.width,
                        )),
                  ),
                )
            ],
          )),
        if (peerTracks.length > 2)
          Flexible(
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    child: ChangeNotifierProvider.value(
                        value: peerTracks[2],
                        child: VideoTile(
                          key: Key(peerTracks[2].uid),
                          audioView: audioViewOn,
                          itemHeight: size.height,
                          itemWidth: size.width,
                        )),
                  ),
                ),
                Flexible(
                  child: (peerTracks.length > 3)
                      ? Container(
                          child: ChangeNotifierProvider.value(
                              value: peerTracks[3],
                              child: VideoTile(
                                key: Key(peerTracks[3].uid),
                                audioView: audioViewOn,
                                itemHeight: size.height,
                                itemWidth: size.width,
                              )),
                        )
                      : Container(),
                )
              ],
            ),
          )
      ],
    ),
  );
}
