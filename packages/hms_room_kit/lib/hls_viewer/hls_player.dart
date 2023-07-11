import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/hls_viewer/hls_stats_view.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

//Project imports

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
