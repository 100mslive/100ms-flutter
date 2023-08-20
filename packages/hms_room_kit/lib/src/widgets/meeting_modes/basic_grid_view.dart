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

Widget basicGridView(
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
                : PeerTile(
                    islongPressEnabled: false,
                    key: Key("${peerTracks[index].uid}video_tile"),
                    scaleType: ScaleType.SCALE_ASPECT_FIT,
                    // itemHeight: size.height,
                    // itemWidth: size.width,
                  ),
          );
        }
        return ChangeNotifierProvider.value(
            key: ValueKey("${peerTracks[index].uid}video_view"),
            value: peerTracks[index],
            child: PeerTile(
              key: ValueKey("${peerTracks[index].uid}audio_view"),
              // itemHeight: size.height,
              // itemWidth: size.width,
            ));
      },
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: true,
          pattern: isPortrait
              ? portraitPattern(peerTracks, screenShareCount, size, context)
              : landscapePattern(itemCount, screenShareCount, size, context)));
}

List<StairedGridTile> portraitPattern(List<PeerTrackNode> peerTrack,
    int screenShareCount, Size size, BuildContext context) {
  double ratio = Utilities.getHLSRatio(size, context);
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
  int normalTile = peerTrack.length - screenShareCount - pinTileCount;
  int tileLeft = normalTile % 4;
  for (int i = 0; i < (normalTile - tileLeft); i++) {
    tiles.add(StairedGridTile(0.5, ratio));
  }
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else if (tileLeft == 2) {
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(0.5, ratio / 2));
  } else {
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(1, ratio));
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
