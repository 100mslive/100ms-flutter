import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/hls_viewer/hls_stats_view.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

//Project imports

class HLSPlayer extends StatefulWidget {
  final double? ratio;
  const HLSPlayer({Key? key, this.ratio}) : super(key: key);
  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInFadeOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: GlobalKey(),
        body: Stack(
          children: [
            Center(
                child: Selector<MeetingStore, double>(
                    selector: (_, meetingStore) => meetingStore.hlsAspectRatio,
                    builder: (_, ratio, __) {
                      return AspectRatio(
                        aspectRatio: ratio,
                        child: HMSHLSPlayer(
                          showPlayerControls: true,
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
            if (!context.read<MeetingStore>().isPipActive)
              Positioned(
                bottom: 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    HMSHLSPlayerController.seekToLivePosition();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 15,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Go Live",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  var meetingStore = context.read<MeetingStore>();
                  if (meetingStore.isLandscapeLocked) {
                    meetingStore.setLandscapeLock(false);
                    if (meetingStore.isDefaultAspectRatioSelected) {
                      meetingStore.setAspectRatio(9 / 16);
                    }
                  } else {
                    meetingStore.setLandscapeLock(true);
                    if (meetingStore.isDefaultAspectRatioSelected) {
                      meetingStore.setAspectRatio(16 / 9);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/rotate.svg",
                    color: iconColor,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
