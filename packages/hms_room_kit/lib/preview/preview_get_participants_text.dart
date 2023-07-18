import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/widgets/common_widgets/subtitle_text.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewParticipantsText extends StatelessWidget {
  final List<HMSPeer> peers;
  final double width;

  const PreviewParticipantsText(
      {super.key, required this.peers, required this.width});

  double _getRemainingWidth(int peerCount, double width) {
    double remainingWidth = width * 0.33;
    if (peerCount < 10) {
      remainingWidth = width * 0.33;
    } else if (peerCount < 100) {
      remainingWidth = width * 0.30;
    } else if (peerCount < 1000) {
      remainingWidth = width * 0.28;
    } else if (peerCount <= 10000) {
      remainingWidth = width * 0.25;
    } else {
      remainingWidth = width * 0.2;
    }
    return remainingWidth;
  }

  @override
  Widget build(BuildContext context) {
    String message = "";
    switch (peers.length) {
      case 1:
        message = peers[0].name;
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.28),
              child: SubtitleText(
                text: message,
                textColor: onSurfaceHighEmphasis,
                textAlign: TextAlign.center,
              ),
            ),
            SubtitleText(text: " has joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 2:
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: " joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 3:
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: ", +1 other", textColor: onSurfaceHighEmphasis)
          ],
        );
      default:
        double totalWidth = _getRemainingWidth(peers.length, width);
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: totalWidth * 0.3),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: totalWidth * 0.7),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(
                text: ", +${peers.length - 2} others",
                textColor: onSurfaceHighEmphasis)
          ],
        );
    }
  }
}
