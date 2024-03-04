///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///This renders the text based on the number of participants who are already in the room
///If there is only a single peer in room then we render "1 other in session"
///For more than one peer we render it as "{number_of_peers} in session"
///
///Please note that this will only be rendered if the room state is enabled for the role with peer-list
///Checkout the docs for room-state here: https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/preview#get-onpeerupdate-and-onroomupdate-while-in-preview-mode
class PreviewParticipantsText extends StatelessWidget {
  final int peerCount;

  const PreviewParticipantsText({super.key, required this.peerCount});

  @override
  Widget build(BuildContext context) {
    return HMSTitleText(
        text: "$peerCount ${peerCount > 1 ? "others" : "other"} in session",
        lineHeight: 20,
        fontSize: 14,
        letterSpacing: 0.25,
        textColor: HMSThemeColors.onSurfaceHighEmphasis);
  }
}
