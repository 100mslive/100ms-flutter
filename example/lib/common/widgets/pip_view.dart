import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/peer_widgets/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_player.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PipView extends StatefulWidget {
  @override
  State<PipView> createState() => _PipViewState();
}

class _PipViewState extends State<PipView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Selector<MeetingStore, Tuple2<List<PeerTrackNode>, bool>>(
              selector: (_, meetingStore) => Tuple2(
                    meetingStore.peerTracks,
                    meetingStore.isHLSLink,
                  ),
              builder: (_, data, __) {
                return (data.item2)
                    ? Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.hasHlsStarted,
                        builder: (_, hasHlsStarted, __) {
                          return hasHlsStarted
                              ? Container(
                                  child: Center(
                                    child: HLSPlayer(),
                                  ),
                                )
                              : Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            "Waiting for HLS to start...",
                                            style: GoogleFonts.inter(
                                                color: iconColor, fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        })
                    : data.item1.length > 0
                        ? ChangeNotifierProvider.value(
                            key: ValueKey(data.item1[0].uid + "video_view"),
                            value: data.item1[0],
                            child: Selector<PeerTrackNode,
                                Tuple2<HMSVideoTrack?, bool>>(
                              selector: (_, peerTrackNode) => Tuple2(
                                  peerTrackNode.track,
                                  peerTrackNode.track?.isMute ?? true),
                              builder: (_, peerTrackToDisplay, __) {
                                return (peerTrackToDisplay.item1 == null ||
                                        peerTrackToDisplay.item2 ||
                                        peerTrackToDisplay.item1?.isDegraded ==
                                            true)
                                    ? Semantics(
                                        label: "fl_video_off",
                                        child: AudioLevelAvatar())
                                    : HMSVideoView(
                                        key: Key(
                                            peerTrackToDisplay.item1!.trackId +
                                                "pipView"),
                                        track: peerTrackToDisplay.item1!,
                                        scaleType:
                                            (peerTrackToDisplay.item1!.source !=
                                                    "REGULAR")
                                                ? ScaleType.SCALE_ASPECT_FIT
                                                : ScaleType.SCALE_ASPECT_FILL,
                                        setMirror: false,
                                        matchParent: false);
                              },
                            ))
                        : Container();
              })),
    );
  }
}
