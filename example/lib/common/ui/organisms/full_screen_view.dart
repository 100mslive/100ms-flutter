//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';

Widget fullScreenView(
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
      physics: PageScrollPhysics(),
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
                          color: iconColor,
                        ),
                        Text(
                          "You are sharing your screen",
                          style: GoogleFonts.inter(
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : VideoTile(
                    key: Key(peerTracks[index].uid),
                    scaleType: ScaleType.SCALE_ASPECT_FIT,
                    itemHeight: size.height,
                    itemWidth: size.width,
                  ),
          );
        }

        if (screenShareCount == 0 &&
            index < 4 &&
            peerTracks[index].isOffscreen) {
          peerTracks[index].setOffScreenStatus(false);
        }
        return ChangeNotifierProvider.value(
            key: ValueKey(peerTracks[index].uid),
            value: peerTracks[index],
            child: VideoTile(
              key: ValueKey(peerTracks[index].uid),
              itemHeight: size.height,
              itemWidth: size.width,
            ));
      },
      controller: Provider.of<MeetingStore>(context).controller,
      gridDelegate: SliverStairedGridDelegate(
          startCrossAxisDirectionReversed: false,
          pattern: [StairedGridTile(1, Utilities.getRatio(size, context))]));
}
