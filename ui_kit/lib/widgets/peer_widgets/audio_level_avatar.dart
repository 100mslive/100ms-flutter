import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:provider/provider.dart';

class AudioLevelAvatar extends StatefulWidget {
  final double avatarRadius;
  final double avatarTitleFontSize;
  const AudioLevelAvatar(
      {Key? key, this.avatarRadius = 36, this.avatarTitleFontSize = 36})
      : super(key: key);

  @override
  State<AudioLevelAvatar> createState() => _AudioLevelAvatarState();
}

class _AudioLevelAvatarState extends State<AudioLevelAvatar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<PeerTrackNode, int>(
          selector: (_, peerTrackNode) => peerTrackNode.audioLevel,
          builder: (_, audioLevel, __) {
            return audioLevel == -1
                ? CircleAvatar(
                    backgroundColor: Utilities.getBackgroundColour(
                        context.read<PeerTrackNode>().peer.name),
                    radius: widget.avatarRadius,
                    child: Text(
                      Utilities.getAvatarTitle(
                          context.read<PeerTrackNode>().peer.name),
                      style: GoogleFonts.inter(
                          fontSize: widget.avatarTitleFontSize,
                          color: onSurfaceHighEmphasis),
                    ))
                : AvatarGlow(
                    repeat: true,
                    showTwoGlows: true,
                    duration: const Duration(seconds: 1),
                    endRadius: (audioLevel != -1)
                        ? widget.avatarRadius + (audioLevel).toDouble()
                        : widget.avatarRadius,
                    glowColor: Utilities.getBackgroundColour(
                        context.read<PeerTrackNode>().peer.name),
                    child: CircleAvatar(
                        backgroundColor: Utilities.getBackgroundColour(
                            context.read<PeerTrackNode>().peer.name),
                        radius: widget.avatarRadius,
                        child: Text(
                          Utilities.getAvatarTitle(
                              context.read<PeerTrackNode>().peer.name),
                          style: GoogleFonts.inter(
                              fontSize: widget.avatarTitleFontSize,
                              color: onSurfaceHighEmphasis),
                        )),
                  );
          }),
    );
  }
}
