///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

///[HLSPlayer] is a component that is used to show the HLS Player
class HLSPlayer extends StatelessWidget {
  final double? ratio;
  const HLSPlayer({Key? key, this.ratio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///We use the hlsAspectRatio from the [MeetingStore] to set the aspect ratio of the player
    ///By default the aspect ratio is 9:16
    return Selector<MeetingStore, double>(
        selector: (_, meetingStore) => meetingStore.hlsAspectRatio,
        builder: (_, ratio, __) {
          return GestureDetector(
            child: AspectRatio(
              aspectRatio: ratio,
              child: InkWell(
                onTap: () =>
                    context.read<HLSPlayerStore>().toggleButtonsVisibility(),
                splashFactory: NoSplash.splashFactory,
                child: IgnorePointer(
                  child: HMSHLSPlayer(
                    key: key,
                    showPlayerControls: false,
                    isHLSStatsRequired:
                        context.read<MeetingStore>().isHLSStatsEnabled,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
