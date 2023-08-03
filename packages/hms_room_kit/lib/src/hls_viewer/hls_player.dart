///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_stats_view.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///This widget is used to show the HLS Player
///It uses the [HMSHLSPlayer] widget from the [hmssdk_flutter] package
///It also uses the [HLSStatsView] widget to show the stats of the HLS Player
class HLSPlayer extends StatelessWidget {
  final double? ratio;
  const HLSPlayer({Key? key, this.ratio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        body: Stack(
          children: [
            Center(
                child: Selector<MeetingStore, double>(
                    selector: (_, meetingStore) => meetingStore.hlsAspectRatio,
                    builder: (_, ratio, __) {
                      return AspectRatio(
                        aspectRatio: ratio,
                        child: HMSHLSPlayer(
                          key: key,
                          showPlayerControls: false,
                          isHLSStatsRequired:
                              context.read<MeetingStore>().isHLSStatsEnabled,
                        ),
                      );
                    })),
            Selector<MeetingStore, bool>(
                selector: (_, meetingStore) => meetingStore.isHLSStatsEnabled,
                builder: (_, isHLSStatsEnabled, __) {
                  return isHLSStatsEnabled
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: ChangeNotifierProvider.value(
                            value: context.read<MeetingStore>(),
                            child: const HLSStatsView(),
                          ),
                        )
                      : Container();
                }),
          ],
        ));
  }
}
