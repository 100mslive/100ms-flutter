//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

class NetworkIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, int?>(
        builder: (_, networkQuality, __) {
          return (networkQuality != null && networkQuality != -1)
              ? Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/network_$networkQuality.svg',
                      height: 20,
                      semanticsLabel: "fl_network_icon_label",
                    ),
                  ],
                )
              : Container();
        },
        selector: (_, peerTrackNode) => peerTrackNode.networkQuality);
  }
}
