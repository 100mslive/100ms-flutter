///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/network_icon_widget.dart';
import 'package:hms_room_kit/src/widgets/peer_widgets/peer_name.dart';

///[NameAndNetwork] is a widget that is used to render the name and network of the peer
///The widget takes following parameters:
///[maxWidth] - The maximum width of the widget, this is taken to calculate the maximum width for the name to be rendered such that it doesn't overflow
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
