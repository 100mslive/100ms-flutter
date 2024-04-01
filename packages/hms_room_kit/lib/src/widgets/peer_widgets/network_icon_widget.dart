///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/model/peer_track_node.dart';

///[NetworkIconWidget] is a widget that is used to render the network icon
class NetworkIconWidget extends StatelessWidget {
  const NetworkIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ///[Selector] is used to rebuild the widget when the network quality changes
    ///[networkQuality] is a tuple of [int] and [bool]
    ///[int] represents the network quality
    ///[bool] represents whether the track is degraded or not
    return Selector<PeerTrackNode, Tuple2<int?, bool>>(
        builder: (_, networkQuality, __) {
          ///If the track is degraded, we render the degraded network icon
          ///If the network quality is not null and not -1,
          ///and the peer is a regular peer
          ///we render the network icon
          return context.read<PeerTrackNode>().peer.type == HMSPeerType.regular
              ? networkQuality.item2
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
                      : const SizedBox()
              : const SizedBox();
        },
        selector: (_, peerTrackNode) => Tuple2(peerTrackNode.networkQuality,
            peerTrackNode.track?.isDegraded ?? false));
  }
}
