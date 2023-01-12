//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/audio_level_avatar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/data_store/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

class VideoView extends StatefulWidget {
  final matchParent;

  final Size? viewSize;
  final bool setMirror;
  final double itemHeight;
  final ScaleType scaleType;
  final double itemWidth;
  final String uid;
  VideoView(
      {Key? key,
      this.viewSize,
      this.setMirror = false,
      this.matchParent = true,
      this.itemHeight = 200,
      this.itemWidth = 200,
      required this.uid,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple3<HMSVideoTrack?, bool, bool>>(
        builder: (_, data, __) {
          if ((data.item1 == null) || data.item2 || data.item3) {
            return Semantics(label: "fl_video_off", child: AudioLevelAvatar());
          } else {
            return (data.item1?.source != "REGULAR")
                ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: InteractiveViewer(
                      // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                      // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                      child: HMSVideoView(
                        key: Key(data.item1!.trackId),
                        scaleType: widget.scaleType,
                        track: data.item1!,
                        setMirror: false,
                        matchParent: false,
                        disableAutoSimulcastLayerSelect:
                            !(context.read<MeetingStore>().isAutoSimulcast),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Container(
                      height: widget.itemHeight,
                      width: widget.itemWidth,
                      // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                      // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                      child: HMSVideoView(
                        key: Key(data.item1!.trackId),
                        scaleType: ScaleType.SCALE_ASPECT_FILL,
                        track: data.item1!,
                        setMirror: data.item1.runtimeType == HMSLocalVideoTrack
                            ? context.read<MeetingStore>().isMirror
                            : false,
                        matchParent: false,
                        disableAutoSimulcastLayerSelect:
                            !(context.read<MeetingStore>().isAutoSimulcast),
                      ),
                    ),
                  );
          }
        },
        selector: (_, peerTrackNode) => Tuple3(
            peerTrackNode.track,
            (peerTrackNode.isOffscreen),
            (peerTrackNode.track?.isMute ?? true)));
  }
}
