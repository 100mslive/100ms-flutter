import 'package:example_riverpod/meeting/peer_track_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoTiles extends StatelessWidget {
  final List<PeerTrackNode> peerTracks;
  const VideoTiles({Key? key, required this.peerTracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: peerTracks.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisExtent: MediaQuery.of(context).size.width / 2),
        itemBuilder: (context, index) {
          final peerTrackProvider =
              ChangeNotifierProvider<PeerTrackNode>((ref) {
            return peerTracks[index];
          });
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Consumer(
              builder: (context, ref, child) {
                HMSVideoTrack? videoTrack = ref.watch(peerTrackProvider).track;
                HMSPeer? peer = ref.watch(peerTrackProvider).peer;
                if (videoTrack != null && videoTrack.isMute == false) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Stack(
                      children: [
                        //To know more about HMSVideoView checkout the docs here: https://www.100ms.live/docs/flutter/v2/how--to-guides/set-up-video-conferencing/render-video/overview
                        HMSVideoView(
                          track: videoTrack,
                          scaleType: ScaleType.SCALE_ASPECT_FILL,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            peer.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 36,
                                child: Text(
                                  peer.name[0],
                                  style: const TextStyle(
                                      fontSize: 36, color: Colors.white),
                                )),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                peer.name,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
