import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

List<Widget> gridAudioView(
    {required List<PeerTrackNode> peerTracks,
    required bool audioViewOn,
    required int itemCount,
    required int screenShareOn,
    required Size size}) {
  int index = screenShareOn;
  List<Widget> gridView = [];

  int numberofPages = (((itemCount - index) ~/ 6).toInt() +
      ((itemCount - index) % 6 == 0 ? 0 : 1));
  for (int i = 0; i < numberofPages; i++) {
    if (index + 6 < itemCount) {
      gridView.add(
          customGrid(peerTracks.sublist(index, index + 6), audioViewOn, size));
      index += 6;
    } else {
      gridView.add(
          customGrid(peerTracks.sublist(index, itemCount), audioViewOn, size));
    }
  }
  return gridView;
}

Widget customGrid(List<PeerTrackNode> peerTracks, audioViewOn, Size size) {
  return Container(
    child: Column(
      children: [
        Expanded(
          flex: 2,
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
                      ),
                    if (peerTracks.length == 3)
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
                  ],
                )),
              if (peerTracks.length > 3)
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
                          child: Container(
                        child: ChangeNotifierProvider.value(
                            value: peerTracks[3],
                            child: VideoTile(
                              key: Key(peerTracks[3].uid),
                              audioView: audioViewOn,
                              itemHeight: size.height,
                              itemWidth: size.width,
                            )),
                      ))
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (peerTracks.length > 4)
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    child: ChangeNotifierProvider.value(
                        value: peerTracks[4],
                        child: VideoTile(
                          key: Key(peerTracks[4].uid),
                          audioView: audioViewOn,
                          itemHeight: size.height,
                          itemWidth: size.width,
                        )),
                  ),
                ),
                if (peerTracks.length > 5)
                  Flexible(
                      child: Container(
                    child: ChangeNotifierProvider.value(
                        value: peerTracks[5],
                        child: VideoTile(
                          key: Key(peerTracks[5].uid),
                          audioView: audioViewOn,
                          itemHeight: size.height,
                          itemWidth: size.width,
                        )),
                  ))
              ],
            ),
          ),
      ],
    ),
  );
}
