///Package imports
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview/preview_get_participants_text.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///This widget renders the UI for whether the HLS is running in the room
///If the HLS is running, it will show the LIVE tag
///Please note that this will only be rendered if the room state is enabled for the role from dashboard
///This also renders the number of participants in the room in a chip
///Please note that this will only be rendered if the room state is enabled for the role with peer-list
///
///Checkout the docs for room-state here: https://www.100ms.live/docs/flutter/v2/how-to-guides/set-up-video-conferencing/preview#get-onpeerupdate-and-onroomupdate-while-in-preview-mode
class PreviewParticipantChip extends StatelessWidget {
  final PreviewStore previewStore;
  final double width;

  const PreviewParticipantChip(
      {super.key, required this.previewStore, required this.width});

  @override
  Widget build(BuildContext context) {
    var peerCount =
        previewStore.peerCount + (previewStore.peer == null ? 0 : 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///This will only be rendered if the room state is enabled for the role from dashboard and the HLS is running in the room
        previewStore.isHLSStreamingStarted
            ? Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: HMSThemeColors.alertErrorDefault,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/white_dot.svg",
                          width: 20,
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 6),
                          child: HMSSubtitleText(
                              text: "LIVE",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.25,
                              textColor: HMSThemeColors.onSurfaceHighEmphasis),
                        ),
                      ],
                    ),
                  )),
                ),
              )
            : Container(),

        ///This will only be rendered if room state is enabled for the role
        peerCount == 0
            ? Container()
            : Container(
                height: 40,
                decoration: BoxDecoration(
                    color: HMSThemeColors.surfaceDefault,
                    border: Border.all(
                        width: 1, color: HMSThemeColors.borderDefault),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, left: 20, right: 16),
                    child: peerCount == 1
                        ? HMSTitleText(
                            text: "You are the first to join",
                            fontSize: 14,
                            lineHeight: 20,
                            letterSpacing: 0.25,
                            textColor: HMSThemeColors.onSurfaceHighEmphasis)
                        : PreviewParticipantsText(
                            peerCount: previewStore.peerCount,
                          ),
                  ),
                ),
              ),
      ],
    );
  }
}
