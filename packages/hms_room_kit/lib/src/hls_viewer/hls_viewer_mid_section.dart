import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:provider/provider.dart';

class HLSViewerMidSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<HLSPlayerStore, bool>(
            selector: (_, hlsPlayerStore) =>
                hlsPlayerStore.areStreamControlsVisible,
            builder: (_, areStreamControlsVisible, __) {
        return areStreamControlsVisible? GestureDetector(
          onTap: () => {
            context.read<HLSPlayerStore>().toggleStreamPlaying(),
          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor: HMSThemeColors.backgroundDim.withOpacity(0.64),
            child: Center(
              child: Container(
                child: Selector<HLSPlayerStore, bool>(
                    selector: (_, hlsPlayerStore) => hlsPlayerStore.isStreamPlaying,
                    builder: (_, isStreamPlaying, __) {
                      return SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/${isStreamPlaying ? "pause" : "play"}.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.baseWhite, BlendMode.srcIn),
                      );
                    }),
              ),
            ),
          ),
        ): const SizedBox();
      }
    );
  }
}
