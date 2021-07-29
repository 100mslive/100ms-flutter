import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/ui/meeting/video_view.dart';

class PeerItemOrganism extends StatelessWidget {
  final HMSTrack track;

  const PeerItemOrganism({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          Text(track.peer?.role?.name ?? '[Undefined Role]'),
          Text(track.peer?.name ?? '[Undefined Name]'),
          Text(track.peer?.customerDescription ?? '[Undefined Description]'),
          Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              print(
                  'height:${constraints.maxHeight} width: ${constraints.maxWidth}');
              return VideoView(
                track: track,
                args: {
                  'height': constraints.maxHeight,
                  'width': constraints.maxWidth,
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
