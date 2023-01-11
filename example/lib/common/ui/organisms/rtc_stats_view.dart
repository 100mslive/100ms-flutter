//Package imports
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

//Project imports
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:hmssdk_flutter_example/model/rtc_stats.dart';

class RTCStatsView extends StatelessWidget {
  final bool isLocal;

  RTCStatsView({required this.isLocal});
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, bool>(
        builder: (_, statsVisible, __) {
          return statsVisible ? Stats(isLocal: isLocal) : SizedBox();
        },
        selector: (_, _meetingStore) => _meetingStore.isStatsVisible);
  }
}

class Stats extends StatelessWidget {
  final isLocal;
  Stats({Key? key, required this.isLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLocal
        ? Selector<PeerTrackNode, Tuple4<double?, double?, RTCStats?, int?>>(
            selector: (_, peerTrackNode) => Tuple4(
                peerTrackNode.stats?.hmsLocalVideoStats?[0].bitrate,
                peerTrackNode.stats?.hmsLocalAudioStats?.bitrate,
                peerTrackNode.stats,
                peerTrackNode.networkQuality),
            builder: (_, data, __) {
              return Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.black38.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        if ((data.item3 != null) &&
                            (data.item3!.hmsLocalVideoStats != null))
                          ...data.item3!.hmsLocalVideoStats!
                              .map((videoStats) => localVideoStats(videoStats))
                              .toList(),
                        Text("Downlink\t ${data.item4 ?? "-1"}",
                            style: GoogleFonts.inter(
                                color: iconColor, fontSize: 12)),
                        Text(
                            "Bitrate(A)\t ${data.item3?.hmsLocalAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                            style: GoogleFonts.inter(
                                color: iconColor, fontSize: 12)),
                      ],
                    ),
                  ));
            })
        : Selector<PeerTrackNode, Tuple4<double?, double?, RTCStats?, int?>>(
            selector: (_, peerTrackNode) => Tuple4(
                peerTrackNode.stats?.hmsRemoteVideoStats?.bitrate,
                peerTrackNode.stats?.hmsRemoteAudioStats?.bitrate,
                peerTrackNode.stats,
                peerTrackNode.networkQuality),
            builder: (_, data, __) {
              return Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.black38.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsRemoteVideoStats?.resolution.width.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "Height\t ${data.item3?.hmsRemoteVideoStats?.resolution.height.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "FPS\t ${data.item3?.hmsRemoteVideoStats?.frameRate.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text("Downlink\t ${data.item4 ?? "-1"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsRemoteVideoStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsRemoteAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "Jitter(V)\t ${data.item3?.hmsRemoteVideoStats?.jitter.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                    Text(
                        "Jitter(A)\t ${data.item3?.hmsRemoteAudioStats?.jitter.toStringAsFixed(2) ?? "0.00"}",
                        style:
                            GoogleFonts.inter(color: iconColor, fontSize: 12)),
                  ],
                ),
              );
            });
  }

  Widget localVideoStats(HMSLocalVideoStats? videoStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(videoStats?.hmsLayer).toUpperCase()}",
          style:
              GoogleFonts.inter(color: iconColor, fontWeight: FontWeight.bold),
        ),
        Text(
          "Width\t ${videoStats?.resolution.width.toStringAsFixed(2) ?? "0.00"}",
          style: GoogleFonts.inter(color: iconColor, fontSize: 12),
        ),
        Text(
            "Height\t ${videoStats?.resolution.height.toStringAsFixed(2) ?? "0.00"}",
            style: GoogleFonts.inter(color: iconColor, fontSize: 12)),
        Text("FPS\t ${videoStats?.frameRate.toStringAsFixed(2) ?? "0.00"}",
            style: GoogleFonts.inter(color: iconColor, fontSize: 12)),
        Text("Bitrate(V)\t ${videoStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
            style: GoogleFonts.inter(color: iconColor, fontSize: 12)),
        Text("Quality Limitation: ${videoStats?.hmsQualityLimitationReasons?.reason.name??""}",
        style: GoogleFonts.inter(color: iconColor, fontSize: 12)),
      ],
    );
  }
}
