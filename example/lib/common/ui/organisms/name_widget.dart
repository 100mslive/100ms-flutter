//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

class NameWidget extends StatefulWidget {
  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, Tuple4<String, bool, bool, bool>>(
        selector: (_, peerTrackNode) => Tuple4(
            peerTrackNode.peer.name,
            peerTrackNode.track?.isDegraded ?? false,
            peerTrackNode.peer.isLocal,
            peerTrackNode.track?.isMute ?? true),
        builder: (_, data, __) {
          return data.item4
              ? Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  child: HLSSubtitleText(
                    text:
                        "${data.item3 ? "You (" : ""}${data.item1}${data.item3 ? ")" : ""} ${data.item2 ? " Degraded" : ""}",
                    textColor: defaultColor,
                    lineHeight: 20,
                    fontSize: 14,
                    letterSpacing: 0.25,
                  ))
              : SizedBox();
        });
  }
}
