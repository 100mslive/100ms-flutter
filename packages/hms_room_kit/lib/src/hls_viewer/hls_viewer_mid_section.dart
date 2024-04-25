library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';

///[HLSViewerMidSection] renders the mid section of the HLS Viewer containing the pause/play button
class HLSViewerMidSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<HLSPlayerStore, bool>(
        selector: (_, hlsPlayerStore) =>
            hlsPlayerStore.areStreamControlsVisible,
        builder: (_, areStreamControlsVisible, __) {
          return areStreamControlsVisible
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: InkWell(
                        onTap: () =>
                            {HMSHLSPlayerController.seekBackward(seconds: 10)},
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/seek_backward.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.baseWhite, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {
                        context.read<HLSPlayerStore>().toggleStreamPlaying(),
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor:
                            HMSThemeColors.backgroundDim.withOpacity(0.64),
                        child: Center(
                          child: Container(
                            child: Selector<HLSPlayerStore, bool>(
                                selector: (_, hlsPlayerStore) =>
                                    hlsPlayerStore.isStreamPlaying,
                                builder: (_, isStreamPlaying, __) {
                                  return SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/${isStreamPlaying ? "pause" : "play"}.svg",
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.baseWhite,
                                        BlendMode.srcIn),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: InkWell(
                        onTap: () =>
                            {HMSHLSPlayerController.seekForward(seconds: 10)},
                        child: SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/seek_forward.svg",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.baseWhite, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox();
        });
  }
}
