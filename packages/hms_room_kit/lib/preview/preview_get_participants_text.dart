import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/widgets/common_widgets/subtitle_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewParticipantsText extends StatelessWidget {
  final List<HMSPeer> peers;

  const PreviewParticipantsText({super.key, required this.peers});

  @override
  Widget build(BuildContext context) {
    return SubtitleText(
        text:
            "${peers.length} ${peers.length > 1 ? "others" : "other"} in session",
        textColor: onSurfaceHighEmphasis);
  }
}
