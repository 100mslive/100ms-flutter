library;

///Package import
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/network_icon_widget.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';

///[NameAndNetwork] is a widget that is used to render the name and network icon
///of the peer
class NameAndNetwork extends StatelessWidget {
  final double maxWidth;

  const NameAndNetwork({Key? key, required this.maxWidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      //Bottom left
      bottom: 5,
      left: 5,
      child: Container(
        decoration: BoxDecoration(
            color: HMSThemeColors.backgroundDim.withOpacity(0.64),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 4, top: 4, bottom: 4),

            ///We render name and network in a row
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Phone icon is only rendered if its a SIP peer
                if (context.read<PeerTrackNode>().peer.type == HMSPeerType.sip)
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: SvgPicture.asset(
                      'packages/hms_room_kit/lib/src/assets/icons/sip_call.svg',
                      height: 12,
                      semanticsLabel: "fl_sip_call_icon_label",
                    ),
                  ),
                PeerName(
                  maxWidth: maxWidth,
                ),
                const SizedBox(
                  width: 4,
                ),
                const NetworkIconWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
