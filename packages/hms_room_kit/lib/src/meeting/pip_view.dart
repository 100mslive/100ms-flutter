import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class PipView extends StatefulWidget {
  const PipView({super.key});

  @override
  State<PipView> createState() => _PipViewState();
}

class _PipViewState extends State<PipView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<MeetingStore, List<PeerTrackNode>>(
          selector: (_, meetingStore) => meetingStore.peerTracks,
          builder: (_, data, __) {
            return data.isNotEmpty
                ? ChangeNotifierProvider.value(
                    key: ValueKey("${data[0].uid}video_view"),
                    value: data[0],
                    child:
                        Selector<PeerTrackNode, Tuple2<HMSVideoTrack?, bool>>(
                      selector: (_, peerTrackNode) => Tuple2(
                          peerTrackNode.track,
                          peerTrackNode.track?.isMute ?? true),
                      builder: (_, peerTrackToDisplay, __) {
                        return (peerTrackToDisplay.item1 == null ||
                                peerTrackToDisplay.item2 ||
                                peerTrackToDisplay.item1?.isDegraded == true)
                            ? Semantics(
                                label: "fl_video_off",
                                child: const AudioLevelAvatar())
                            : HMSVideoView(
                                key: Key(
                                    "${peerTrackToDisplay.item1!.trackId}pipView"),
                                track: peerTrackToDisplay.item1!,
                                scaleType: (peerTrackToDisplay.item1!.source !=
                                        "REGULAR")
                                    ? ScaleType.SCALE_ASPECT_FIT
                                    : ScaleType.SCALE_ASPECT_FILL,
                                setMirror: false);
                      },
                    ))
                : Container();
          }),
    );
  }
}
