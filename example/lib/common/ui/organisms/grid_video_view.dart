import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:provider/provider.dart';

class GridVideoView extends StatelessWidget {
  final List<PeerTrackNode> peerTracks;
  final bool audioViewOn;
  final int itemCount;
  final bool screenShareOn;
  const GridVideoView(
      {Key? key,
      required this.peerTracks,
      required this.audioViewOn,
      required this.itemCount,
      required this.screenShareOn
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = screenShareOn?0:-1;
    Size size = MediaQuery.of(context).size;

    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisExtent: size.width),
        delegate: SliverChildBuilderDelegate((context, indexx) {
          return Container(
            child: Row(
              children: [
                if(itemCount>index)
                Flexible(
                  child: Column(
                    children: [
                if(itemCount>++index)
                      Flexible(
                        child: Container(
                          child: ChangeNotifierProvider.value(
                              value: peerTracks[index],
                              child: VideoTile(
                                key: Key(peerTracks[index].uid),
                                audioView: audioViewOn,
                                itemHeight: size.height,
                                itemWidth: size.width,
                                index: index,
                              )),
                        ),
                      ),
                if(itemCount>++index)
                      Flexible(
                        child: Container(
                          child: ChangeNotifierProvider.value(
                              value: peerTracks[index],
                              child: VideoTile(
                                key: Key(peerTracks[index].uid),
                                audioView: audioViewOn,
                                itemHeight: size.height,
                                itemWidth: size.width,
                                index: index,
                              )),
                        ),
                      )
                    ],
                  )
                ),
                if(itemCount>index+1)
                Flexible(
                  child: Column(
                    children: [
                if(itemCount>++index)
                      Flexible(
                        child: Container(
                          child: ChangeNotifierProvider.value(
                              value: peerTracks[index],
                              child: VideoTile(
                                key: Key(peerTracks[index].uid),
                                audioView: audioViewOn,
                                itemHeight: size.height,
                                itemWidth: size.width,
                                index: index,
                              )),
                        ),
                      ),
                      Flexible(
                child:(itemCount>++index)?
                         Container(
                          child: ChangeNotifierProvider.value(
                              value: peerTracks[index],
                              child: VideoTile(
                                key: Key(peerTracks[index].uid),
                                audioView: audioViewOn,
                                itemHeight: size.height,
                                itemWidth: size.width,
                                index: index,
                              )),
                        ):Container(),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
          
        },childCount: (itemCount/4).toInt() + (itemCount%4==0?0:1),
          addAutomaticKeepAlives: true,));
  }
}
