import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///This renders the text based on the number of participants who are already in the room
///If there is only a single peer in room then we render "1 other in session"
///For more than one peer we render it as "{number_of_peers} in session"
///
///Please note that this will only be rendered if the room state is enabled for the role with peer-list
///Checkout the docs for room-state here: https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/preview#get-onpeerupdate-and-onroomupdate-while-in-preview-mode
class PreviewParticipantsText extends StatelessWidget {
  final List<HMSPeer> peers;

  const PreviewParticipantsText({super.key, required this.peers});

  @override
  Widget build(BuildContext context) {
    return HMSSubtitleText(
        text:
            "${peers.length} ${peers.length > 1 ? "others" : "other"} in session",
        fontWeight: FontWeight.w600,
        fontSize: 14,
        textColor: onSurfaceHighEmphasis);
  }
}
