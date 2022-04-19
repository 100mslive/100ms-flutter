import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RTCStatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple2<RTCStats?, bool>>(
        builder: (_, data, __) {
          return 
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(
                color: Colors.black38.withOpacity(0.3),
          child:data.item2
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Width\t ${data.item1?.hmsLocalVideoStats?.resolution.width}"),
                      Text("Height\t ${data.item1?.hmsLocalVideoStats?.resolution.height}"),
                      Text("FPS\t ${data.item1?.hmsLocalVideoStats?.frameRate}"),
                      Text("Bitrate(V)\t ${data.item1?.hmsLocalVideoStats?.bitrate}"),
                      Text("Bitrate(A)\t ${data.item1?.hmsLocalAudioStats?.bitrate}"),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Width\t ${data.item1?.hmsRemoteVideoStats?.resolution.width}"),
                      Text("Height\t ${data.item1?.hmsRemoteVideoStats?.resolution.height}"),
                      Text("FPS\t ${data.item1?.hmsRemoteVideoStats?.frameRate}"),
                      Text("Bitrate(V)\t ${data.item1?.hmsRemoteVideoStats?.bitrate}"),
                      Text("Bitrate(A)\t ${data.item1?.hmsRemoteAudioStats?.bitrate}"),
                      Text("Jitter(V)\t ${data.item1?.hmsRemoteVideoStats?.jitter}"),
                      Text("Jitter(A)\t ${data.item1?.hmsRemoteAudioStats?.jitter}"),
                    ],
                )),
            );
        },
        selector: (_, peerTrackNode) =>
            Tuple2(peerTrackNode.stats, peerTrackNode.peer.isLocal));
  }
}
