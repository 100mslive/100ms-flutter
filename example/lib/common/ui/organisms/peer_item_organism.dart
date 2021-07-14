import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';

class PeerItemOrganism extends StatelessWidget {
  final HMSPeer peer;

  const PeerItemOrganism({Key? key, required this.peer}) : super(key: key);

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
          Text(peer.role ?? '[Undefined Role]'),
          Text(peer.name),
          Text(peer.customerDescription ?? '[Undefined Description]'),
        ],
      ),
    );
  }
}
