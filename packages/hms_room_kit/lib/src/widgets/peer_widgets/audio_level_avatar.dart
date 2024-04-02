///Package imports
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';

///[AudioLevelAvatar] is a widget that is used to render the audio level avatar
///It is used to render the audio level of the peer
class AudioLevelAvatar extends StatefulWidget {
  final double avatarRadius;
  final double avatarTitleFontSize;
  final double avatarTitleTextLineHeight;

  const AudioLevelAvatar(
      {Key? key,
      this.avatarRadius = 34,
      this.avatarTitleFontSize = 34,
      this.avatarTitleTextLineHeight = 32})
      : super(key: key);

  @override
  State<AudioLevelAvatar> createState() => _AudioLevelAvatarState();
}

class _AudioLevelAvatarState extends State<AudioLevelAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(

        ///[Selector] is used to rebuild the widget when the audio level changes
        child: Selector<PeerTrackNode, String>(
            selector: (_, peerTrackNode) => peerTrackNode.peer.name,
            builder: (_, peerName, __) {
              return HMSCircularAvatar(
                name: peerName,
                avatarRadius: widget.avatarRadius,
                avatarTitleFontSize: widget.avatarTitleFontSize,
                avatarTitleTextLineHeight: widget.avatarTitleTextLineHeight,
              );
            }));
  }
}
