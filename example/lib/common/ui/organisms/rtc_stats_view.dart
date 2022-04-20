import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RTCStatsView extends StatelessWidget {
  final bool isLocal;

  RTCStatsView({required this.isLocal});
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, bool>(
        builder: (_, statsVisible, __) {
          return statsVisible ? Stats(isLocal: isLocal) : SizedBox();
        },
        selector: (_, _meetingStore) => _meetingStore.statsVisible);
  }
}

class Stats extends StatelessWidget {
  final isLocal;
  const Stats({Key? key, required this.isLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLocal
        ? Selector<PeerTrackNode, Tuple4<double?, double?, RTCStats?, int?>>(
            selector: (_, peerTrackNode) => Tuple4(
                peerTrackNode.stats?.hmsLocalVideoStats?.bitrate,
                peerTrackNode.stats?.hmsLocalAudioStats?.bitrate,
                peerTrackNode.stats,
                peerTrackNode.networkQuality),
            builder: (_, data, __) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    color: Colors.black38.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsLocalVideoStats?.resolution.width.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Height\t ${data.item3?.hmsLocalVideoStats?.resolution.height.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "FPS\t ${data.item3?.hmsLocalVideoStats?.frameRate.toStringAsFixed(2) ?? "0.00"}"),
                    Text("Downlink\t ${data.item4 ?? "-1"}"),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsLocalVideoStats?.bitrate.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsLocalAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}"),
                  ],
                ),
              );
            })
        : Selector<PeerTrackNode, Tuple4<double?, double?, RTCStats?, int?>>(
            selector: (_, peerTrackNode) => Tuple4(
                peerTrackNode.stats?.hmsRemoteVideoStats?.bitrate,
                peerTrackNode.stats?.hmsRemoteAudioStats?.bitrate,
                peerTrackNode.stats,
                peerTrackNode.networkQuality),
            builder: (_, data, __) {
              return Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    color: Colors.black38.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsRemoteVideoStats?.resolution.width.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Height\t ${data.item3?.hmsRemoteVideoStats?.resolution.height.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "FPS\t ${data.item3?.hmsRemoteVideoStats?.frameRate.toStringAsFixed(2) ?? "0.00"}"),
                    Text("Downlink\t ${data.item4 ?? "-1"}"),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsRemoteVideoStats?.bitrate.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsRemoteAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Jitter(V)\t ${data.item3?.hmsRemoteVideoStats?.jitter.toStringAsFixed(2) ?? "0.00"}"),
                    Text(
                        "Jitter(A)\t ${data.item3?.hmsRemoteAudioStats?.jitter.toStringAsFixed(2) ?? "0.00"}"),
                  ],
                ),
              );
            });
  }
}
