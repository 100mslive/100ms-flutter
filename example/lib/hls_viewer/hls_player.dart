import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_stats_view.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';

class HLSPlayer extends StatefulWidget {
  final double? ratio;
  HLSPlayer({Key? key, this.ratio}) : super(key: key);
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
                      return Container();
                      // AspectRatio(
                      //   aspectRatio: ratio,
                      //   child: HMSHLSPlayer(
                      //     showPlayerControls: true,
                      //     isHLSStatsRequired:
                      //         context.read<MeetingStore>().isHLSStatsEnabled,
                      //   ),
                      // );
                    })),
            // Selector<MeetingStore, bool>(
            //     selector: (_, meetingStore) => meetingStore.isHLSStatsEnabled,
            //     builder: (_, isHLSStatsEnabled, __) {
            //       return isHLSStatsEnabled
            //           ? Align(
            //               alignment: Alignment.topLeft,
            //               child: ChangeNotifierProvider.value(
            //                 value: context.read<MeetingStore>(),
            //                 child: HLSStatsView(),
            //               ),
            //             )
            //           : Container();
            //     }),
            if (!context.read<MeetingStore>().isPipActive)
              Positioned(
                bottom: 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    // HMSHLSPlayerController.seekToLivePosition();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                  var _meetingStore = context.read<MeetingStore>();
                  if (_meetingStore.isLandscapeLocked) {
                    _meetingStore.setLandscapeLock(false);
                    if (_meetingStore.isDefaultAspectRatioSelected) {
                      _meetingStore.setAspectRatio(9 / 16);
                    }
                  } else {
                    _meetingStore.setLandscapeLock(true);
                    if (_meetingStore.isDefaultAspectRatioSelected) {
                      _meetingStore.setAspectRatio(16 / 9);
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
