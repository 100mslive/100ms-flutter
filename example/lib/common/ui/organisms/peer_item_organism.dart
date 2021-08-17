import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerItemOrganism extends StatelessWidget {
  final HMSTrack track;
  final bool isVideoMuted;

  PeerItemOrganism({Key? key, required this.track, this.isVideoMuted = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              if (isVideoMuted) {
                List<String> parts = track.peer?.name.split(" ") ?? [];

                late String name;
                if (parts.length == 1)
                  name = parts[0][0];
                else
                  name = parts.map((e) => e.substring(0, 1)).join();
                return Container(
                  child: Center(child: CircleAvatar(child: Text(name))),
                );
              }
              return HMSVideoView(
                track: track,
                args: {
                  'height': constraints.maxHeight,
                  'width': constraints.maxWidth,
                },
              );
            },
          )),
          SizedBox(
            height: 16,
          ),
          Text(track.peer?.name ?? '')
        ],
      ),
    );
  }
}
