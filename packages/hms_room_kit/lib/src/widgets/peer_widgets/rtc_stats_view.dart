//Package imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/model/rtc_stats.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

//Project imports
class RTCStatsView extends StatelessWidget {
  final bool isLocal;

  const RTCStatsView({super.key, required this.isLocal});
  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, bool>(
        builder: (_, statsVisible, __) {
          return statsVisible ? Stats(isLocal: isLocal) : const SizedBox();
        },
        selector: (_, meetingStore) => meetingStore.isStatsVisible);
  }
}

class Stats extends StatelessWidget {
  final bool isLocal;
  const Stats({Key? key, required this.isLocal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLocal
        ? Selector<PeerTrackNode, Tuple4<double?, double?, RTCStats?, int?>>(
            selector: (_, peerTrackNode) => Tuple4(
                peerTrackNode.stats?.hmsLocalVideoStats?.fold(
                    0,
                    (previousValue, element) =>
                        previousValue! + element.bitrate),
                peerTrackNode.stats?.hmsLocalAudioStats?.bitrate,
                peerTrackNode.stats,
                peerTrackNode.networkQuality),
            builder: (_, data, __) {
              return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.black38.withOpacity(0.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if ((data.item3 != null) &&
                          (data.item3!.hmsLocalVideoStats != null))
                        localVideoStats(data.item3!.hmsLocalVideoStats!),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Downlink\t ${data.item4 ?? "-1"}",
                          style: HMSTextStyle.setTextStyle(
                              color: iconColor, fontSize: 12)),
                      Text(
                          "Bitrate(A)\t ${data.item3?.hmsLocalAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                          style: HMSTextStyle.setTextStyle(
                              color: iconColor, fontSize: 12)),
                    ],
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
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.black38.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Width\t ${data.item3?.hmsRemoteVideoStats?.resolution.width.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "Height\t ${data.item3?.hmsRemoteVideoStats?.resolution.height.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "FPS\t ${data.item3?.hmsRemoteVideoStats?.frameRate.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text("Downlink\t ${data.item4 ?? "-1"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "Bitrate(V)\t ${data.item3?.hmsRemoteVideoStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "Bitrate(A)\t ${data.item3?.hmsRemoteAudioStats?.bitrate.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "Jitter(V)\t ${data.item3?.hmsRemoteVideoStats?.jitter.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                    Text(
                        "Jitter(A)\t ${data.item3?.hmsRemoteAudioStats?.jitter.toStringAsFixed(2) ?? "0.00"}",
                        style: HMSTextStyle.setTextStyle(
                            color: iconColor, fontSize: 12)),
                  ],
                ),
              );
            });
  }

  Widget localVideoStats(List<HMSLocalVideoStats?> videoStats) {
    Map<int, TableColumnWidth> columnWidth = {0: const FixedColumnWidth(50)};

    return Table(
      columnWidths: columnWidth,
      children: [
        TableRow(children: [
          Text("Layer",
              style: HMSTextStyle.setTextStyle(
                  color: iconColor, fontWeight: FontWeight.bold, fontSize: 10)),
          ...videoStats
              .map((layerStats) => Text(
                  HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(
                          layerStats?.hmsLayer)
                      .toUpperCase(),
                  style: HMSTextStyle.setTextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10)))
              .toList()
        ]),
        TableRow(children: [
          Text("Width",
              style: HMSTextStyle.setTextStyle(
                  color: iconColor, fontWeight: FontWeight.bold, fontSize: 10)),
          ...videoStats
              .map(
                (layerStats) => Text(
                  layerStats?.resolution.width.toStringAsFixed(2) ?? "0.00",
                  style:
                      HMSTextStyle.setTextStyle(color: iconColor, fontSize: 10),
                ),
              )
              .toList()
        ]),
        TableRow(children: [
          Text("Height",
              style: HMSTextStyle.setTextStyle(
                  color: iconColor, fontWeight: FontWeight.bold, fontSize: 10)),
          ...videoStats
              .map(
                (layerStats) => Text(
                  layerStats?.resolution.height.toStringAsFixed(2) ?? "0.00",
                  style:
                      HMSTextStyle.setTextStyle(color: iconColor, fontSize: 10),
                ),
              )
              .toList()
        ]),
        TableRow(children: [
          Text("FPS",
              style: HMSTextStyle.setTextStyle(
                  color: iconColor, fontWeight: FontWeight.bold, fontSize: 10)),
          ...videoStats
              .map(
                (layerStats) => Text(
                  layerStats?.frameRate.toStringAsFixed(2) ?? "0.00",
                  style:
                      HMSTextStyle.setTextStyle(color: iconColor, fontSize: 10),
                ),
              )
              .toList()
        ]),
        TableRow(children: [
          Text(
            "Bitrate(V)",
            style: HMSTextStyle.setTextStyle(
                color: iconColor, fontWeight: FontWeight.bold, fontSize: 10),
          ),
          ...videoStats
              .map(
                (layerStats) => Text(
                  layerStats?.bitrate.toStringAsFixed(2) ?? "0.00",
                  style:
                      HMSTextStyle.setTextStyle(color: iconColor, fontSize: 10),
                ),
              )
              .toList()
        ]),
        TableRow(children: [
          Text(
            "Quality Limitation",
            style: HMSTextStyle.setTextStyle(
                color: iconColor, fontWeight: FontWeight.bold, fontSize: 10),
          ),
          ...videoStats
              .map(
                (layerStats) => Text(
                  layerStats?.hmsQualityLimitationReasons?.reason.name ?? "",
                  style:
                      HMSTextStyle.setTextStyle(color: iconColor, fontSize: 10),
                ),
              )
              .toList()
        ]),
      ],
    );
  }
}
