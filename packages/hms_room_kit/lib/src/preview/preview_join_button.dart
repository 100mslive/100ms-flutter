///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';

///This renders the join button text in the preview screen based on the condition
class PreviewJoinButton extends StatelessWidget {
  final PreviewStore previewStore;
  final bool isEmpty;

  const PreviewJoinButton(
      {super.key, required this.previewStore, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))),

      ///If the join button type is `join and go live` and the HLS streaming is not started
      ///we show the go live button
      ///
      ///If the join button type is `join and go live` and the HLS streaming is started
      ///we show the join now button
      ///If the join button type is `join now`, we show the join now button
      child: HMSRoomLayout.roleLayoutData?.screens?.preview?.joinForm
                      ?.joinBtnType ==
                  JoinButtonType.JOIN_BTN_TYPE_JOIN_AND_GO_LIVE &&
              !previewStore.isHLSStreamingStarted

          ///If the room join is in progress we show the loading indicator
          ///If the room join is not in progress we show the go live button
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "packages/hms_room_kit/lib/src/assets/icons/live.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      isEmpty
                          ? HMSThemeColors.onPrimaryLowEmphasis
                          : HMSThemeColors.onPrimaryHighEmphasis,
                      BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 8,
                ),
                HMSTitleText(
                  text: HMSRoomLayout.roleLayoutData?.screens?.preview?.joinForm
                          ?.goLiveBtnLabel ??
                      'Go Live',
                  textColor: isEmpty
                      ? HMSThemeColors.onPrimaryLowEmphasis
                      : HMSThemeColors.onPrimaryHighEmphasis,
                )
              ],
            )
          : Center(
              child: HMSTitleText(
                text: HMSRoomLayout
                        .data?[0].screens?.preview?.joinForm?.joinBtnLabel ??
                    'Join Now',
                textColor: isEmpty
                    ? HMSThemeColors.onPrimaryLowEmphasis
                    : HMSThemeColors.onPrimaryHighEmphasis,
              ),
            ),
    );
  }
}
