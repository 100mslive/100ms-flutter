import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

//Project imports

class HLSPlayer extends StatelessWidget {
  final double? ratio;
  const HLSPlayer({Key? key, this.ratio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, double>(
        selector: (_, meetingStore) => meetingStore.hlsAspectRatio,
        builder: (_, ratio, __) {
          return GestureDetector(
            child: AspectRatio(
              aspectRatio: ratio,
              child: HMSHLSPlayer(
                key: key,
                showPlayerControls: false,
                isHLSStatsRequired:
                    context.read<MeetingStore>().isHLSStatsEnabled,
              ),
            ),
          );
        });
  }
}
