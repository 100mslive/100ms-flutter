library;

///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[HLSPlayerSeekbar] is the seekbar for the HLS Player
class HLSPlayerSeekbar extends StatefulWidget {
  @override
  State<HLSPlayerSeekbar> createState() => _HLSPlayerSeekbarState();
}

class _HLSPlayerSeekbarState extends State<HLSPlayerSeekbar> {
  double seekBarValue = 0;
  double minValue = 0, maxValue = 0;

  @override
  void initState() {
    super.initState();
    if (context
            .read<MeetingStore>()
            .hmsRoom
            ?.hmshlsStreamingState
            ?.variants[0]
            ?.startedAt !=
        null) {
      maxValue = DateTime.now()
          .difference(context
              .read<MeetingStore>()
              .hmsRoom!
              .hmshlsStreamingState!
              .variants[0]!
              .startedAt!)
          .inSeconds
          .toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
          trackHeight: 4,
          trackShape: RoundedRectSliderTrackShape(),
          inactiveTrackColor: HMSThemeColors.baseWhite,
          activeTrackColor: HMSThemeColors.primaryDefault,
          thumbColor: HMSThemeColors.primaryDefault,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 0)),
      child: Selector<HLSPlayerStore, Duration>(
          selector: (_, hlsPlayerStore) => hlsPlayerStore.timeFromLive,
          builder: (_, timeFromLive, __) {
            maxValue = DateTime.now()
                .difference(context
                    .read<MeetingStore>()
                    .hmsRoom!
                    .hmshlsStreamingState!
                    .variants[0]!
                    .startedAt!)
                .inSeconds
                .toDouble();
            seekBarValue = maxValue - timeFromLive.inSeconds;
            log("Seekbar Value $seekBarValue max value $maxValue");
            minValue = 0;
            return Slider(
              value: seekBarValue,
              onChanged: (value) {
                if (value > seekBarValue) {
                  HMSHLSPlayerController.seekForward(
                      seconds: (value - seekBarValue).toInt());
                } else {
                  HMSHLSPlayerController.seekForward(
                      seconds: (seekBarValue - value).toInt());
                }
              },
              min: minValue,
              max: maxValue,
            );
          }),
    );
    // Container(
    //   height: 4,
    //   child: Stack(
    //     children: [
    //       if (context
    //               .read<MeetingStore>()
    //               .hmsRoom
    //               ?.hmshlsStreamingState
    //               ?.variants[0]
    //               ?.playlistType ==
    //           HMSHLSPlaylistType.dvr)
    //         Container(
    //           height: 4,
    //           color: HMSThemeColors.baseWhite,
    //         ),
    //       SliderTheme(
    //         data: SliderThemeData(
    //             thumbColor: HMSThemeColors.primaryDefault,
    //             thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)),
    //         child: Selector<HLSPlayerStore, Duration>(
    //             selector: (_, hlsPlayerStore) => hlsPlayerStore.timeFromLive,
    //             builder: (_, timeFromLive, __) {
    //               seekBarValue = maxValue - timeFromLive.inSeconds;
    //               maxValue = DateTime.now()
    //                   .difference(context
    //                       .read<MeetingStore>()
    //                       .hmsRoom!
    //                       .hmshlsStreamingState!
    //                       .variants[0]!
    //                       .startedAt!)
    //                   .inSeconds
    //                   .toDouble();
    //               minValue = 0;
    //               return Slider(
    //                 value: seekBarValue,
    //                 onChanged: (_) {},
    //                 min: minValue,
    //                 max: maxValue,
    //                 thumbColor: HMSThemeColors.primaryDefault,
    //               );
    //             }),
    //       ),
    //       // Selector<HLSPlayerStore, Duration>(
    //       //     selector: (_, hlsPlayerStore) => hlsPlayerStore.timeFromLive,
    //       //     builder: (_, timeFromLive, __) {
    //       //       log("Time from Live in seconds ${timeFromLive.inSeconds}");
    //       //       return FractionallySizedBox(
    //       //           widthFactor: 1 - (timeFromLive.inSeconds) / 20,
    //       //           child: Container(
    //       //             height: 4,
    //       //             color: HMSThemeColors.primaryDefault,
    //       //           ));
    //       //     }),
    //     ],
    //   ),
    // );
  }
}
