//Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

//Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';

///[VideoView] is a widget that renders the video of a peer
///It renders the video of the peer if the peer is not muted
///If the peer is muted it renders the avatar
///If the peer is offscreen it renders the avatar
///
///It takes following parameters
///[matchParent] - If true, the video will take the size of the parent widget
///[viewSize] - The size of the video
///[setMirror] - If true, the video will be mirrored
///[scaleType] - The scale type of the video
///[uid] - The uid of the peer
///[avatarRadius] - The radius of the avatar
///[avatarTitleFontSize] - The font size of the avatar title
///[avatarTitleTextLineHeight] - The line height of the avatar title
class VideoView extends StatefulWidget {
  final bool matchParent;

  final Size? viewSize;
  final bool setMirror;
  final ScaleType scaleType;
  final String uid;
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;
  final HMSTextureViewController? videoViewController;

  const VideoView(
      {Key? key,
      this.viewSize,
      this.setMirror = false,
      this.matchParent = true,
      required this.uid,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL,
      this.avatarRadius = 34,
      this.avatarTitleFontSize = 34,
      this.avatarTitleTextLineHeight = 32,
      this.videoViewController})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    ///We use the [Selector] widget to rebuild the widget when the peer track node changes
    return Selector<PeerTrackNode, Tuple3<HMSVideoTrack?, bool, bool>>(
        builder: (_, data, __) {
          ///If the peer track node is null or the peer is muted or the peer is offscreen
          ///We render the avatar
          if ((data.item1 == null) || data.item2 || data.item3) {
            return Semantics(
                label: "fl_video_off",
                child: AudioLevelAvatar(
                  avatarRadius: widget.avatarRadius,
                  avatarTitleFontSize: widget.avatarTitleFontSize,
                  avatarTitleTextLineHeight: widget.avatarTitleTextLineHeight,
                ));
          } else {
            ///If the peer is not muted and not offscreen
            ///We render the video
            ///
            ///If we the video track source is not REGULAR i.e. it is a screen share or someother video track
            ///we set the scaletype as FIT
            ///
            ///If the video track source is REGULAR i.e. it is a camera video track
            ///we set the scaletype as FILL
            return (data.item1?.source != "REGULAR")
                ? InteractiveViewer(
                    // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                    // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                    child: HMSTextureView(
                      controller: widget.videoViewController,
                      key: Key(data.item1!.trackId),
                      scaleType: ScaleType.SCALE_ASPECT_FIT,
                      track: data.item1!,
                      setMirror: false,
                      disableAutoSimulcastLayerSelect:
                          !(context.read<MeetingStore>().isAutoSimulcast),
                    ),
                  )
                : SizedBox(
                    // [key] property can be used to forcefully rebuild the video widget by setting a unique key everytime.
                    // Similarly to avoid rebuilding the key should be kept the same for particular HMSVideoView.
                    child: HMSTextureView(
                      controller: widget.videoViewController,
                      key: Key(data.item1!.trackId),
                      scaleType: ScaleType.SCALE_ASPECT_FILL,
                      track: data.item1!,
                      setMirror: data.item1.runtimeType == HMSLocalVideoTrack,
                      disableAutoSimulcastLayerSelect:
                          !(context.read<MeetingStore>().isAutoSimulcast),
                    ),
                  );
          }
        },
        selector: (_, peerTrackNode) => Tuple3(peerTrackNode.track,
            peerTrackNode.isOffscreen, (peerTrackNode.track?.isMute ?? true)));
  }
}
