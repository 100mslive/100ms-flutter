import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
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
      child: Selector<MeetingStore, int>(
          selector: (_, meetingStore) =>
              meetingStore.isActiveSpeaker(context.read<PeerTrackNode>().uid),
          builder: (_, isSpeaking, __) {
            return isSpeaking == -1
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
                    duration: Duration(seconds: 1),
                    endRadius:
                        (isSpeaking != -1) ? 36 + (isSpeaking).toDouble() : 36,
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
