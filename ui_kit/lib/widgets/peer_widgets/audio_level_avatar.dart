import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/model/peer_track_node.dart';
import 'package:provider/provider.dart';

class AudioLevelAvatar extends StatefulWidget {
  const AudioLevelAvatar({Key? key}) : super(key: key);

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
                    radius: 36,
                    child: Text(
                      Utilities.getAvatarTitle(
                          context.read<PeerTrackNode>().peer.name),
                      style:
                          GoogleFonts.inter(fontSize: 36, color: Colors.white),
                    ))
                : AvatarGlow(
                    repeat: true,
                    showTwoGlows: true,
                    duration: const Duration(seconds: 1),
                    endRadius:
                        (audioLevel != -1) ? 36 + (audioLevel).toDouble() : 36,
                    glowColor: Utilities.getBackgroundColour(
                        context.read<PeerTrackNode>().peer.name),
                    child: CircleAvatar(
                        backgroundColor: Utilities.getBackgroundColour(
                            context.read<PeerTrackNode>().peer.name),
                        radius: 36,
                        child: Text(
                          Utilities.getAvatarTitle(
                              context.read<PeerTrackNode>().peer.name),
                          style: GoogleFonts.inter(
                              fontSize: 36, color: Colors.white),
                        )),
                  );
          }),
    );
  }
}
