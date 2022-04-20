import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RTCStatsView extends StatelessWidget {
  bool isLocal;

  RTCStatsView({required this.isLocal});
  @override
  Widget build(BuildContext context) {
    return isLocal
        ? Selector<PeerTrackNode, Tuple3<double?, double?, RTCStats?>>(
            selector: (_, peerTrackNode) => Tuple3(
                peerTrackNode.stats?.hmsLocalVideoStats?.bitrate,
                peerTrackNode.stats?.hmsLocalAudioStats?.bitrate,
                peerTrackNode.stats),
            builder: (_, data, __) {
              return Container(
                color: Colors.black38.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsLocalVideoStats?.resolution.width}"),
                    Text(
                        "Height\t ${data.item3?.hmsLocalVideoStats?.resolution.height}"),
                    Text("FPS\t ${data.item3?.hmsLocalVideoStats?.frameRate}"),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsLocalVideoStats?.bitrate}"),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsLocalAudioStats?.bitrate}"),
                  ],
                ),
              );
            })
        : Selector<PeerTrackNode, Tuple3<double?, double?, RTCStats?>>(
            selector: (_, peerTrackNode) => Tuple3(
                peerTrackNode.stats?.hmsRemoteVideoStats?.bitrate,
                peerTrackNode.stats?.hmsRemoteAudioStats?.bitrate,
                peerTrackNode.stats),
            builder: (_, data, __) {
              return Container(
                color: Colors.black38.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsRemoteVideoStats?.resolution.width}"),
                    Text(
                        "Height\t ${data.item3?.hmsRemoteVideoStats?.resolution.height}"),
                    Text("FPS\t ${data.item3?.hmsRemoteVideoStats?.frameRate}"),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsRemoteVideoStats?.bitrate}"),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsRemoteAudioStats?.bitrate}"),
                    Text(
                        "Jitter(V)\t ${data.item3?.hmsRemoteVideoStats?.jitter}"),
                    Text(
                        "Jitter(A)\t ${data.item3?.hmsRemoteAudioStats?.jitter}"),
                  ],
                ),
              );
            });
  }
}
