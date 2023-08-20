//Package imports
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoView extends StatefulWidget {
  final bool matchParent;

  final Size? viewSize;
  final bool setMirror;
  final ScaleType scaleType;
  final String uid;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  const VideoView(
      {Key? key,
      this.viewSize,
      this.setMirror = false,
      this.matchParent = true,
      required this.uid,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL,
      this.avatarRadius = 34,
      this.avatarTitleFontSize = 34,
      this.avatarTitleTextLineHeight = 32})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  void _onFirstFrameRendered() {
    log("Vkohli onFirstFrameRendered called");
    context.read<PeerTrackNode>().setIsFirstFrameRendered(true);
  }

  void _onResolutionChanged() {
    log("Vkohli onResolutionChanged called");
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple3<HMSVideoTrack?, bool, bool>>(
        builder: (_, data, __) {
          if ((data.item1 == null) || data.item2 || data.item3) {
            return Semantics(
                label: "fl_video_off",
                child: AudioLevelAvatar(
                  avatarRadius: widget.avatarRadius,
                  avatarTitleFontSize: widget.avatarTitleFontSize,
                  avatarTitleTextLineHeight: widget.avatarTitleTextLineHeight,
                ));
          } else {
            return (data.item1?.source != "REGULAR")
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: InteractiveViewer(
                      // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                      // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                      child: HMSVideoView(
                        key: Key(data.item1!.trackId),
                        scaleType: widget.scaleType,
                        track: data.item1!,
                        setMirror: false,
                        disableAutoSimulcastLayerSelect:
                            !(context.read<MeetingStore>().isAutoSimulcast),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: SizedBox(
                      // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                      // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                      child: HMSVideoView(
                        key: Key(data.item1!.trackId),
                        scaleType: ScaleType.SCALE_ASPECT_FILL,
                        track: data.item1!,
                        setMirror: data.item1.runtimeType == HMSLocalVideoTrack,
                        disableAutoSimulcastLayerSelect:
                            !(context.read<MeetingStore>().isAutoSimulcast),
                        onFirstFrameRendered: () => _onFirstFrameRendered(),
                        onResolutionChanged: () => _onResolutionChanged(),
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
