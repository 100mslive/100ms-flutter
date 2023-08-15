//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports

class NetworkIconWidget extends StatelessWidget {
  const NetworkIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple2<int?, bool>>(
        builder: (_, networkQuality, __) {
          return networkQuality.item2
              ? SvgPicture.asset(
                  'packages/hms_room_kit/lib/src/assets/icons/degraded_network.svg',
                  height: 20,
                  semanticsLabel: "fl_network_icon_label",
                )
              : (networkQuality.item1 != null && networkQuality.item1 != -1)
                  ? SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/network_${networkQuality.item1}.svg',
                      height: 20,
                      semanticsLabel: "fl_network_icon_label",
                    )
                  : Container();
        },
        selector: (_, peerTrackNode) => Tuple2(peerTrackNode.networkQuality,
            peerTrackNode.track?.isDegraded ?? false));
  }
}
