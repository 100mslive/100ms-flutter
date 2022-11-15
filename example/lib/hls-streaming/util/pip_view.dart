import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_level_avatar.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer.dart';
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
          child: Selector<MeetingStore,
                  Tuple4<List<PeerTrackNode>, bool, int, int>>(
              selector: (_, meetingStore) => Tuple4(
                  meetingStore.peerTracks,
                  meetingStore.isHLSLink,
                  meetingStore.screenShareCount,
                  meetingStore.peerTracks.length),
              builder: (_, data, __) {
                late int peerIndex;
                if (!data.item2) {
                  if (data.item4 != 1) {
                    peerIndex = data.item1.indexWhere(
                      (element) => (element.peer.isLocal == false ||
                          element.track?.source != "REGULAR"),
                    );
                  } else {
                    peerIndex = 0;
                  }
                }
                return (data.item2)
                    ? Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.hasHlsStarted,
                        builder: (_, hasHlsStarted, __) {
                          return hasHlsStarted
                              ? Container(
                                  child: Center(
                                    child: HLSPlayer(
                                        streamUrl: context
                                            .read<MeetingStore>()
                                            .streamUrl),
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
                    : ChangeNotifierProvider.value(
                        key: ValueKey(data.item1[peerIndex].uid + "video_view"),
                        value: data.item1[peerIndex],
                        child: Selector<PeerTrackNode,
                            Tuple2<HMSVideoTrack?, bool>>(
                          selector: (_, peerTrackNode) => Tuple2(
                              peerTrackNode.track,
                              peerTrackNode.track?.isMute ?? true),
                          builder: (_, peerTrackToDisplay, __) {
                            return (peerTrackToDisplay.item1 == null ||
                                    peerTrackToDisplay.item2)
                                ? Semantics(
                                    label: "fl_video_off",
                                    child: AudioLevelAvatar())
                                : HMSVideoView(
                                    key: Key(peerTrackToDisplay.item1!.trackId +
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
                        ));
              })),
    );
  }
}
