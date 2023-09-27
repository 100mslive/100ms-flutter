import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class StatsForNerds extends StatefulWidget {
  final List<PeerTrackNode> peerTrackNode;
  const StatsForNerds({Key? key, required this.peerTrackNode})
      : super(key: key);

  @override
  State<StatsForNerds> createState() => _StatsForNerdsState();
}

class _StatsForNerdsState extends State<StatsForNerds> {
  PeerTrackNode? valueChoose;
  String? statsType;
  late bool isStatsEnable;

  void _updateDropDownValue(dynamic newValue) {
    setState(() {
      valueChoose = newValue;
      if (valueChoose?.peer.isLocal ?? false) {
        if (valueChoose?.stats?.hmsLocalAudioStats != null) {
          statsType = "Regular Audio";
        } else if (valueChoose?.stats?.hmsLocalVideoStats?.isNotEmpty != null) {
          statsType =
              "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(valueChoose?.stats?.hmsLocalVideoStats?.first.hmsLayer)}";
        } else {
          statsType = null;
        }
      } else {
        if (valueChoose?.stats?.hmsRemoteAudioStats != null) {
          statsType = "Regular Audio";
        } else if (valueChoose?.stats?.hmsRemoteVideoStats != null) {
          statsType = "Regular Video";
        } else {
          statsType = null;
        }
      }
    });
  }

  void _updateStatsTypeDropDownvalue(dynamic newValue) {
    statsType = newValue;
  }

  @override
  void initState() {
    isStatsEnable = context.read<MeetingStore>().isStatsVisible;
    context.read<MeetingStore>().attachStatsListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HMSTitleText(
            text: "Stats for Nerds",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Switch(
                  value: isStatsEnable,
                  onChanged: (value) {
                    setState(() {
                      isStatsEnable = value;
                    });
                    context.read<MeetingStore>().changeStatsVisible();
                  }),
              HMSSubtitleText(
                text: "Show Stats on Tiles",
                fontSize: 15,
                letterSpacing: 0.15,
                textColor: themeDefaultColor,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          HMSSubtitleText(
            text: "Stats For",
            fontSize: 15,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                decoration: BoxDecoration(
                  color: themeSurfaceColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: borderColor,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                    child: HMSDropDown(
                        dropDownItems: <DropdownMenuItem>[
                      ...widget.peerTrackNode
                          .map((peerNode) => DropdownMenuItem(
                                value: peerNode,
                                child: HMSTitleText(
                                  text: peerNode.peer.name,
                                  textColor: themeDefaultColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ))
                          .toList(),
                    ],
                        dropdownHint: HMSTitleText(
                          text: "Select Peer",
                          textColor: themeDefaultColor,
                          fontWeight: FontWeight.w400,
                        ),
                        iconStyleData: IconStyleData(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconEnabledColor: themeDefaultColor,
                        ),
                        selectedValue: valueChoose,
                        updateSelectedValue: _updateDropDownValue)),
              ),
              const SizedBox(
                height: 10,
              ),
              if (valueChoose != null)
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    color: themeSurfaceColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: borderColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: HMSDropDown(
                          dropDownItems: <DropdownMenuItem>[
                        if (valueChoose!.stats?.hmsLocalAudioStats != null ||
                            valueChoose!.stats?.hmsRemoteAudioStats != null)
                          DropdownMenuItem(
                            value: "Regular Audio",
                            child: HMSTitleText(
                              text: "Regular Audio",
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        if (valueChoose!.stats?.hmsRemoteVideoStats != null)
                          DropdownMenuItem(
                            value: "Regular Video",
                            child: HMSTitleText(
                              text: "Regular Video",
                              textColor: themeDefaultColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ...?valueChoose!.stats?.hmsLocalVideoStats
                            ?.map(
                              (localVideoStats) => DropdownMenuItem(
                                value:
                                    "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(localVideoStats.hmsLayer)}",
                                child: HMSTitleText(
                                  text:
                                      "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(localVideoStats.hmsLayer)}",
                                  textColor: themeDefaultColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                            .toList()
                      ],
                          iconStyleData: IconStyleData(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconEnabledColor: themeDefaultColor,
                          ),
                          selectedValue: statsType,
                          updateSelectedValue: _updateStatsTypeDropDownvalue)),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (valueChoose != null && statsType != null)
            ListenableProvider.value(
                value: valueChoose,
                child: StatsUI(peerNode: valueChoose!, statsType: statsType!))
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor:
                      MaterialStateProperty.all(themeBottomSheetColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: const BorderSide(
                        width: 1, color: Color.fromRGBO(107, 125, 153, 1)),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              onPressed: () {
                context.read<MeetingStore>().removeStatsListener();
                Navigator.pop(context, false);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text('Close',
                    style: HMSTextStyle.setTextStyle(
                        color: themeDefaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.50)),
              )),
        )
      ],
    );
  }
}

class StatsUI extends StatelessWidget {
  final PeerTrackNode peerNode;
  final String statsType;
  const StatsUI({Key? key, required this.peerNode, required this.statsType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (statsType.toLowerCase().contains("audio") && peerNode.peer.isLocal) {
      return Selector<PeerTrackNode, HMSLocalAudioStats?>(
          selector: (_, peerTrackNode) =>
              peerTrackNode.stats?.hmsLocalAudioStats,
          builder: (_, hmsLocalAudioStats, __) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsLocalAudioStats?.bitrate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Sent",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalAudioStats?.bytesSent.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Round Trip",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalAudioStats?.roundTripTime.toStringAsFixed(2)}")
                    ],
                  ),
                )
              ],
            );
          });
    }
    if (statsType.toLowerCase().contains("audio") && !peerNode.peer.isLocal) {
      return Selector<PeerTrackNode, HMSRemoteAudioStats?>(
          selector: (_, peerTrackNode) =>
              peerTrackNode.stats?.hmsRemoteAudioStats,
          builder: (_, hmsRemoteAudioStats, __) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsRemoteAudioStats?.bitrate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Received",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteAudioStats?.bytesReceived.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Jitter",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsRemoteAudioStats?.jitter.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Lost",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteAudioStats?.packetsLost.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Received",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteAudioStats?.packetsReceived.toStringAsFixed(2)}")
                    ],
                  ),
                )
              ],
            );
          });
    }
    if (statsType.toLowerCase().contains("video") && peerNode.peer.isLocal) {
      return Selector<PeerTrackNode, HMSLocalVideoStats?>(
          selector: (_, peerTrackNode) => peerTrackNode
              .stats?.hmsLocalVideoStats
              ?.firstWhere((element) => statsType.toLowerCase().contains(
                  HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(
                      element.hmsLayer))),
          builder: (_, hmsLocalVideoStats, __) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsLocalVideoStats?.bitrate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Sent",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalVideoStats?.bytesSent.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Frame Rate",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalVideoStats?.frameRate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Round Trip",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalVideoStats?.roundTripTime.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Quality Limitation",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsLocalVideoStats?.hmsQualityLimitationReasons?.reason.name.toLowerCase()}")
                    ],
                  ),
                )
              ],
            );
          });
    }
    if (statsType.toLowerCase().contains("video") && !peerNode.peer.isLocal) {
      return Selector<PeerTrackNode, HMSRemoteVideoStats?>(
          selector: (_, peerTrackNode) =>
              peerTrackNode.stats?.hmsRemoteVideoStats,
          builder: (_, hmsRemoteVideoStats, __) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsRemoteVideoStats?.bitrate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Received",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteVideoStats?.bytesReceived.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Jitter",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text("${hmsRemoteVideoStats?.jitter.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "FPS",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteVideoStats?.frameRate.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Lost",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteVideoStats?.packetsLost.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Received",
                        style: HMSTextStyle.setTextStyle(
                            color: themeDefaultColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.50),
                      ),
                      Text(
                          "${hmsRemoteVideoStats?.packetsReceived.toStringAsFixed(2)}")
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return const Text("Stats not available");
  }
}
