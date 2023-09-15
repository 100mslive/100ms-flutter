//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/peer_tile.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

Widget fullScreenMode(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required bool isPortrait,
    required Size size}) {
  return GridView.builder(
      shrinkWrap: true,
      cacheExtent: size.width,
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        if (peerTracks[index].track?.source != "REGULAR") {
          return ChangeNotifierProvider.value(
            key: ValueKey(peerTracks[index].uid),
            value: peerTracks[index],
            child: peerTracks[index].peer.isLocal
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: HMSThemeColors.surfaceDim,
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          height: 55.2,
                        ),
                        Text(
                          "You are sharing your screen",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: themeDefaultColor,
                              fontSize: 20,
                              letterSpacing: 0.15,
                              height: 24 / 20),
                        ),
                        HMSButton(
                            buttonBackgroundColor: errorColor,
                            width: MediaQuery.of(context).size.width * 0.6,
                            onPressed: () {
                              context.read<MeetingStore>().stopScreenShare();
                            },
                            childWidget: Row(
                              children: [
                                SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/close.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                HMSTitleText(
                                    text: "Stop Screenshare",
                                    textColor: enabledTextColor)
                              ],
                            ))
                      ],
                    ),
                  )
                : PeerTile(
                    key: Key(peerTracks[index].uid),
                    scaleType: ScaleType.SCALE_ASPECT_FIT,
                    // itemHeight: size.height,
                    // itemWidth: size.width,
                  ),
          );
        }
        return ChangeNotifierProvider.value(
            key: ValueKey(peerTracks[index].uid),
            value: peerTracks[index],
            child: PeerTile(
              key: ValueKey(peerTracks[index].uid),
              // itemHeight: size.height,
              // itemWidth: size.width,
            ));
      },
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: false,
          pattern: [StairedGridTile(1, Utilities.getHLSRatio(size, context))]));
}
