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

/// Returns the Grid for inset mode
Widget insetGridView(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required bool isPortrait,
    required Size size}) {
  return GridView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        if (peerTracks[index].track != null &&
            peerTracks[index].track?.source != "REGULAR") {
          return ChangeNotifierProvider.value(
            key: ValueKey("${peerTracks[index].uid}video_view"),
            value: peerTracks[index],

            ///Here we check whether the screen shared is local or remote
            child: peerTracks[index].peer.isLocal

                ///If this is true we render the local screen share tile which says "You are sharing your screen"
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
                        const SizedBox(
                          height: 18,
                        ),
                        Text("You are sharing your screen",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: themeDefaultColor,
                              fontSize: 20,
                              letterSpacing: 0.15,
                              height: 24 / 20,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        HMSButton(
                            buttonBackgroundColor: errorColor,
                            width: MediaQuery.of(context).size.width * 0.6,
                            onPressed: () {
                              context.read<MeetingStore>().stopScreenShare();
                            },
                            childWidget: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
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
                              ),
                            ))
                      ],
                    ),
                  )

                ///Here we render the remote peer screen with the screen share
                : PeerTile(
                    islongPressEnabled: false,
                    key: Key("${peerTracks[index].uid}video_tile"),
                    scaleType: ScaleType.SCALE_ASPECT_FIT,
                    // itemHeight: size.height,
                    // itemWidth: size.width,
                  ),
          );
        }
        return (!peerTracks[index].peer.isLocal)
            ? ChangeNotifierProvider.value(
                key: ValueKey("${peerTracks[index].uid}video_view"),
                value: peerTracks[index],
                child: const PeerTile(
                    // itemHeight: size.height,
                    // itemWidth: size.width,
                    ))
            : Container();
      },
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: true,
          pattern: isPortrait
              ? portraitPattern(peerTracks, screenShareCount, size, context)
              : landscapePattern(itemCount, screenShareCount, size, context)));
}

///This returns the grid pattern for the grid view
///The logic is as below:
///1. We first check the screen share count and add the tiles for screen share
///2. Then we check the pinned tile count and add the tiles for pinned tiles
///3. Then we check the normal tile count and add the tiles for normal tiles until the count is divisible by 3
///4. For remaining tiles if count is 1 we add a tile of complete screen width
///5. For remaining tiles if count is 2 we add a tile of half screen width
List<StairedGridTile> portraitPattern(List<PeerTrackNode> peerTrack,
    int screenShareCount, Size size, BuildContext context) {
  double ratio = (size.height - 3) / size.width;
  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int pinTileCount = 0;
  while ((pinTileCount + screenShareCount < peerTrack.length) &&
      peerTrack[pinTileCount + screenShareCount].pinTile) {
    tiles.add(StairedGridTile(1, ratio));
    pinTileCount++;
  }

  ///Checking the number of tiles left after adding screen share and pinned tiles
  int normalTile = peerTrack.length - screenShareCount - pinTileCount;

  ///Checking the remainder when divided by 3
  int tileLeft = normalTile % 3;

  ///Here we add the tiles with 1/3 of the screen height
  for (int i = 0; i < (normalTile - tileLeft); i++) {
    tiles.add(StairedGridTile(0.33, ratio / 3));
  }

  ///Here if the remainder is 1 we add a tile with full screen height
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else {
    ///Here if the remainder is 2 we add a tile with half screen height
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(0.5, ratio / 2));
  }
  return tiles;
}

List<StairedGridTile> landscapePattern(
    int itemCount, int screenShareCount, Size size, BuildContext context) {
  double ratio = Utilities.getHLSRatio(size, context);
  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int normalTile = (itemCount - screenShareCount);
  int gridView = normalTile ~/ 2;
  int tileLeft = normalTile - (gridView * 2);
  for (int i = 0; i < (normalTile - tileLeft); i++) {
    tiles.add(StairedGridTile(1, ratio / 0.5));
  }
  if (tileLeft == 1) tiles.add(StairedGridTile(1, ratio));

  return tiles;
}
