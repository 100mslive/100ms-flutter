// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// SDK imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// Package imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class PeerItemOrganism extends StatefulWidget {
  final double height;
  final double width;
  final bool isLocal;
  final bool setMirror;
  final PeerTrackNode peerTrackNodeStore;

  PeerItemOrganism(
      {Key? key,
      //required this.peerTracKNode,
      this.height = 200.0,
      this.width = 200.0,
      this.isLocal = false,
      this.setMirror = false,
      required this.peerTrackNodeStore})
      : super(key: key);

  @override
  _PeerItemOrganismState createState() => _PeerItemOrganismState();
}

class _PeerItemOrganismState extends State<PeerItemOrganism> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PeerItemOrganism ${widget.peerTrackNodeStore.track.toString()}");
    return Container();
  }
}
