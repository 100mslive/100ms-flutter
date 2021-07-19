import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/ui/meeting/video_view.dart';
class PeerItemOrganism extends StatelessWidget {
  final HMSPeer peer;

  const PeerItemOrganism({Key? key, required this.peer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: 300.0,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(left:8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        children: [
          Text(peer.role ?? '[Undefined Role]'),
          Text(peer.name),
          Text(peer.customerDescription ?? '[Undefined Description]'),
      Expanded(child: LayoutBuilder(
        builder: (context, constraints) {
          return VideoView(
            peer: peer,
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
