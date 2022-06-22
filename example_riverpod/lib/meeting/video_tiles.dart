import 'package:example_riverpod/meeting/peer_track_node.dart';
import 'package:example_riverpod/service/utility_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoTiles extends StatelessWidget {
  final List<PeerTrackNode> peerTracks;
  const VideoTiles({Key? key, required this.peerTracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: peerTracks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 2),
      itemBuilder: (context, index) {
        final peerTrackProvider = ChangeNotifierProvider<PeerTrackNode>((ref) {
          return peerTracks[index];
        });
        return Stack(
          children: [
            Consumer(
              builder: (context, ref, child) {
                HMSVideoTrack? videoTrack = ref.watch(peerTrackProvider).track;
                if (videoTrack != null && videoTrack.isMute == false) {
                  return HMSVideoView(
                    track: videoTrack,
                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                  );
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: CircleAvatar(
                            backgroundColor: Utilities.getBackgroundColour(
                                ref.read(peerTrackProvider).peer.name),
                            radius: 36,
                            child: Text(
                              Utilities.getAvatarTitle(
                                  ref.read(peerTrackProvider).peer.name),
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ))),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer(builder: (context, ref, child) {
                HMSPeer hmsPeer = ref.watch(peerTrackProvider).peer;
                return Text(hmsPeer.name);
              }),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Consumer(builder: (context, ref, child) {
                HMSAudioTrack? audioTrack =
                    ref.watch(peerTrackProvider).audioTrack;
                if (audioTrack != null && audioTrack.isMute == false) {
                  return const SizedBox();
                } else {
                  return const Icon(
                    Icons.mic_off,
                    color: Colors.red,
                  );
                }
              }),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(border: Border.all(width: 1)))
          ],
        );
      },
    );
  }
}
