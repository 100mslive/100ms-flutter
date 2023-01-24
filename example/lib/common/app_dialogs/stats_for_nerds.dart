import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:provider/provider.dart';

class StatsForNerds extends StatefulWidget {
  final List<PeerTrackNode> peerTrackNode;
  StatsForNerds({Key? key, required this.peerTrackNode}) : super(key: key);

  @override
  State<StatsForNerds> createState() => _StatsForNerdsState();
}

class _StatsForNerdsState extends State<StatsForNerds> {
  PeerTrackNode? valueChoose;
  String? statsType;
  late bool isStatsEnable;

  @override
  void initState() {
    isStatsEnable = context.read<MeetingStore>().isStatsVisible;
    context.read<MeetingStore>().attachStatsListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actionsPadding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      contentPadding: EdgeInsets.only(top: 20, bottom: 15, left: 24, right: 24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: "Stats for Nerds",
            fontSize: 20,
            letterSpacing: 0.15,
            textColor: themeDefaultColor,
          ),
          SizedBox(
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
              SubtitleText(
                text: "Show Stats on Tiles",
                fontSize: 15,
                letterSpacing: 0.15,
                textColor: themeDefaultColor,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          SubtitleText(
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
                padding: EdgeInsets.only(left: 10, right: 5),
                decoration: BoxDecoration(
                  color: themeSurfaceColor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: borderColor,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                  hint: TitleText(
                    text: "Select Peer",
                    textColor: themeDefaultColor,
                    fontWeight: FontWeight.w400,
                  ),
                  isExpanded: true,
                  dropdownWidth: width * 0.7,
                  buttonWidth: width * 0.7,
                  buttonHeight: 48,
                  itemHeight: 48,
                  value: valueChoose,
                  icon: Icon(Icons.keyboard_arrow_down),
                  buttonDecoration: BoxDecoration(
                    color: themeSurfaceColor,
                  ),
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: themeSurfaceColor,
                      border: Border.all(color: borderColor)),
                  offset: Offset(-10, -10),
                  iconEnabledColor: themeDefaultColor,
                  selectedItemHighlightColor: hmsdefaultColor,
                  onChanged: (dynamic newvalue) {
                    setState(() {
                      valueChoose = newvalue;
                      if (valueChoose?.peer.isLocal ?? false) {
                        if (valueChoose?.stats?.hmsLocalAudioStats != null) {
                          statsType = "Regular Audio";
                        } else if (valueChoose
                                ?.stats?.hmsLocalVideoStats?.isNotEmpty !=
                            null) {
                          statsType =
                              "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(valueChoose?.stats?.hmsLocalVideoStats?.first.hmsLayer)}";
                        } else {
                          statsType = null;
                        }
                      } else {
                        if (valueChoose?.stats?.hmsRemoteAudioStats != null) {
                          statsType = "Regular Audio";
                        } else if (valueChoose?.stats?.hmsRemoteVideoStats !=
                            null) {
                          statsType = "Regular Video";
                        } else {
                          statsType = null;
                        }
                      }
                    });
                  },
                  items: <DropdownMenuItem>[
                    ...widget.peerTrackNode
                        .map((peerNode) => DropdownMenuItem(
                              child: TitleText(
                                text: peerNode.peer.name,
                                textColor: themeDefaultColor,
                                fontWeight: FontWeight.w400,
                              ),
                              value: peerNode,
                            ))
                        .toList(),
                  ],
                )),
              ),
              SizedBox(
                height: 10,
              ),
              if (valueChoose != null)
                Container(
                  padding: EdgeInsets.only(left: 10, right: 5),
                  decoration: BoxDecoration(
                    color: themeSurfaceColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: borderColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                    isExpanded: true,
                    dropdownWidth: width * 0.7,
                    buttonWidth: width * 0.7,
                    buttonHeight: 48,
                    itemHeight: 48,
                    value: statsType,
                    icon: Icon(Icons.keyboard_arrow_down),
                    buttonDecoration: BoxDecoration(
                      color: themeSurfaceColor,
                    ),
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: themeSurfaceColor,
                        border: Border.all(color: borderColor)),
                    offset: Offset(-10, -10),
                    iconEnabledColor: themeDefaultColor,
                    selectedItemHighlightColor: hmsdefaultColor,
                    onChanged: (dynamic newvalue) {
                      setState(() {
                        statsType = newvalue;
                      });
                    },
                    items: <DropdownMenuItem>[
                      if (valueChoose!.stats?.hmsLocalAudioStats != null ||
                          valueChoose!.stats?.hmsRemoteAudioStats != null)
                        DropdownMenuItem(
                          child: TitleText(
                            text: "Regular Audio",
                            textColor: themeDefaultColor,
                            fontWeight: FontWeight.w400,
                          ),
                          value: "Regular Audio",
                        ),
                      if (valueChoose!.stats?.hmsRemoteVideoStats != null)
                        DropdownMenuItem(
                          child: TitleText(
                            text: "Regular Video",
                            textColor: themeDefaultColor,
                            fontWeight: FontWeight.w400,
                          ),
                          value: "Regular Video",
                        ),
                      ...?valueChoose!.stats?.hmsLocalVideoStats
                          ?.map(
                            (localVideoStats) => DropdownMenuItem(
                              child: TitleText(
                                text:
                                    "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(localVideoStats.hmsLayer)}",
                                textColor: themeDefaultColor,
                                fontWeight: FontWeight.w400,
                              ),
                              value:
                                  "Regular Video - ${HMSSimulcastLayerValue.getValueFromHMSSimulcastLayer(localVideoStats.hmsLayer)}",
                            ),
                          )
                          .toList()
                    ],
                  )),
                ),
            ],
          ),
          SizedBox(
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
                    side: BorderSide(
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
                    style: GoogleFonts.inter(
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
  StatsUI({Key? key, required this.peerNode, required this.statsType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (statsType.toLowerCase().contains("audio") && peerNode.peer.isLocal)
      return Selector<PeerTrackNode, HMSLocalAudioStats?>(
          selector: (_, peerTrackNode) =>
              peerTrackNode.stats?.hmsLocalAudioStats,
          builder: (_, hmsLocalAudioStats, __) {
            return Wrap(
              spacing: 10,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Sent",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Round Trip",
                        style: GoogleFonts.inter(
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
    if (statsType.toLowerCase().contains("audio") && !peerNode.peer.isLocal)
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Received",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Jitter",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Lost",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Received",
                        style: GoogleFonts.inter(
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
    if (statsType.toLowerCase().contains("video") && peerNode.peer.isLocal)
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Sent",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Frame Rate",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Round Trip",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Quality Limitation",
                        style: GoogleFonts.inter(
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
    if (statsType.toLowerCase().contains("video") && !peerNode.peer.isLocal)
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bitrate",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Bytes Received",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Jitter",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "FPS",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Lost",
                        style: GoogleFonts.inter(
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Packet Received",
                        style: GoogleFonts.inter(
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

    return Container(
      child: Text("Stats not available"),
    );
  }
}
