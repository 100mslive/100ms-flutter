library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/video_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/rtc_stats_view.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/screen_share_tile_name.dart';
import 'package:hms_room_kit/src/widgets/whiteboard_screenshare/whiteboard_screenshare_store.dart';

///[ScreenshareTile] is a widget that is used to render the screenshare tile
///It is used to render the screenshare of the peer
class ScreenshareTile extends StatelessWidget {
  const ScreenshareTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoView(
          uid: context.read<PeerTrackNode>().uid,
          scaleType: ScaleType.SCALE_ASPECT_FIT,
        ),
        Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                context.read<WhiteboardScreenshareStore>().toggleFullScreen();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: HMSThemeColors.backgroundDim.withAlpha(64),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Selector<WhiteboardScreenshareStore, bool>(
                      selector: (_, whiteboardScreenshareStore) =>
                          whiteboardScreenshareStore.isFullScreen,
                      builder: (_, isFullScreen, __) {
                        return SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/${isFullScreen ? "minimize" : "maximize"}.svg",
                          height: 16,
                          width: 16,
                          semanticsLabel: "maximize_label",
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                        );
                      }),
                ),
              ),
            )),
        Positioned(
          //Bottom left
          bottom: 5,
          left: 5,
          child: Container(
            decoration: BoxDecoration(
                color: HMSThemeColors.backgroundDim.withOpacity(0.64),
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 4, top: 4, bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                      height: 20,
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    LayoutBuilder(
                        builder: (context, BoxConstraints constraints) {
                      return ScreenshareTileName(
                          maxWidth: constraints.maxWidth);
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
        const RTCStatsView(isLocal: false),
      ],
    );
  }
}
