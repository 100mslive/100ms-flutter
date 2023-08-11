//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports

class NetworkIconWidget extends StatelessWidget {
  const NetworkIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int?>(
        builder: (_, networkQuality, __) {
          return (networkQuality != null && networkQuality != -1)
              ? SvgPicture.asset(
                  'packages/hms_room_kit/lib/src/assets/icons/network_$networkQuality.svg',
                  height: 20,
                  semanticsLabel: "fl_network_icon_label",
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.networkQuality);
  }
}
