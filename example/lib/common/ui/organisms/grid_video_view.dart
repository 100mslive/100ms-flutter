import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

List<Widget> gridVideoView(
    {required List<PeerTrackNode> peerTracks,
    required bool audioViewOn,
    required int itemCount,
    required bool screenShareOn,
    required Size size}) {
  int index = screenShareOn ? 1 : 0;
  List<Widget> gridView = [];
  if (screenShareOn)
    gridView.add(
      Container(
        height: size.height,
        width: size.width,
        child: ChangeNotifierProvider.value(
          value: peerTracks[0],
          child: peerTracks[0].peer.isLocal?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_upload_outlined),
              Text("You are sharing your screen"),
                           
            ],
          )
          :VideoTile(
            key: Key(peerTracks[0].uid),
            itemHeight: size.height,
            itemWidth: size.width,
            audioView: audioViewOn,
            scaleType: ScaleType.SCALE_ASPECT_FIT,
          ),
        ),
      ),
    );
  int numberofPages = ((itemCount ~/ 4).toInt() + (itemCount % 4 == 0 ? 0 : 1));
  for (int i = 0; i < numberofPages; i++) {
    if (index + 4 < itemCount) {
      gridView.add(
          customGrid(peerTracks.sublist(index, index + 4), audioViewOn, size));
      index += 4;
    } else {
      gridView.add(
          customGrid(peerTracks.sublist(index, itemCount), audioViewOn, size));
    }
  }
  return gridView;
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
