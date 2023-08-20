//package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/audio_level_avatar.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/name_and_network.dart';
import 'package:provider/provider.dart';

//Package imports

class StateChangeListener extends StatefulWidget {
  const StateChangeListener({Key? key}) : super(key: key);

  @override
  State<StateChangeListener> createState() => _StateChangeListenerState();
}

class _StateChangeListenerState extends State<StateChangeListener> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: !data,
              child:
                  LayoutBuilder(builder: (context, BoxConstraints constraints) {
                return Container(
                  decoration: BoxDecoration(
                      color: HMSThemeColors.backgroundDefault,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: AudioLevelAvatar()
                      ),
                      NameAndNetwork(maxWidth: constraints.maxWidth),
                    ],
                  ),
                );
              }));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.isFirstFrameRendered);
  }
}
