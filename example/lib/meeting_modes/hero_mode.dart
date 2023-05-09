//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_button.dart';
import 'package:hmssdk_flutter_example/common/widgets/peer_tile.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/model/peer_track_node.dart';

Widget heroMode(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required bool isPortrait,
    required Size size}) {
  return GridView.builder(
      shrinkWrap: true,
      cacheExtent: 600,
      physics: PageScrollPhysics(),
      itemCount: itemCount,
      scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
      itemBuilder: (context, index) {
        if (peerTracks[index].track?.source != "REGULAR") {
          return ChangeNotifierProvider.value(
            key: ValueKey(peerTracks[index].uid),
            value: peerTracks[index],
            child: peerTracks[index].peer.isLocal
                ? Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/screen_share.svg",
                          color: Colors.white,
                          height: 55.2,
                        ),
                        SizedBox(
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
                        SizedBox(
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
                                  SvgPicture.asset("assets/icons/close.svg"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TitleText(
                                      text: "Stop Screenshare",
                                      textColor: enabledTextColor)
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                : PeerTile(
                    key: Key(peerTracks[index].uid),
                    scaleType: ScaleType.SCALE_ASPECT_FIT,
                    itemHeight: size.height,
                    itemWidth: size.width,
                  ),
          );
        }
        return ChangeNotifierProvider.value(
            key: ValueKey(peerTracks[index].uid),
            value: peerTracks[index],
            child: PeerTile(
              key: ValueKey(peerTracks[index].uid),
              itemHeight: size.height,
              itemWidth: size.width,
            ));
      },
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: false,
          pattern: isPortrait
              ? portraitPattern(itemCount, screenShareCount, size, context)
              : landscapePattern(itemCount, screenShareCount, size, context)));
}

List<StairedGridTile> portraitPattern(
    int itemCount, int screenShareCount, Size size, BuildContext context) {
  double ratio = 1 / Utilities.getHLSRatio(size, context);

  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int normalTile = (itemCount - screenShareCount);
  if (normalTile == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else {
    tiles.add(StairedGridTile(1, ratio / 0.8));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
  }
  int tileLeft = normalTile % 4;
  for (int i = 0; i < (normalTile - tileLeft - 4); i++) {
    tiles.add(StairedGridTile(0.5, ratio));
  }
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else if (tileLeft == 2) {
    tiles.add(StairedGridTile(1, ratio / 0.5));
    tiles.add(StairedGridTile(1, ratio / 0.5));
  } else {
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
    tiles.add(StairedGridTile(1, ratio / (1 / 3)));
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
  if (normalTile == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else {
    tiles.add(StairedGridTile(1, ratio / 0.8));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
    tiles.add(StairedGridTile(0.33, ratio / 0.6));
  }
  int gridView = normalTile ~/ 2;
  int tileLeft = normalTile - (gridView * 2);
  for (int i = 0; i < (normalTile - tileLeft - 4); i++) {
    tiles.add(StairedGridTile(1, ratio / 0.5));
  }
  if (tileLeft == 1) tiles.add(StairedGridTile(1, ratio));

  return tiles;
}
