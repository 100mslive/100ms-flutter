///dart imports
library;

import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';

///[PreviewHeader] is the header of the preview screen
///It contains the logo, title, subtitle and the participant chip
///The participant chip is only visible when the room state is enabled
///and the peer list is not empty and the peer role has the permission to receive room state
class PreviewHeader extends StatelessWidget {
  final PreviewStore previewStore;
  final String userName;
  final String? imgUrl;
  final bool isVideoCall;
  const PreviewHeader(
      {super.key,
      required this.previewStore,
      this.imgUrl,
      required this.userName,
      this.isVideoCall = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: previewStore.isVideoOn
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.45, 1],
                  colors: [
                    HMSThemeColors.backgroundDim.withOpacity(1),
                    HMSThemeColors.backgroundDim.withOpacity(0)
                  ],
                )
              : null),
      child: Padding(
        padding: EdgeInsets.only(
          top: (!(previewStore.peer?.role.publishSettings!.allowed
                      .contains("video") ??
                  false)
              ? MediaQuery.of(context).size.height * 0.4
              : Platform.isIOS
                  ? 50
                  : 35),
        ),
        child: Row(
          crossAxisAlignment: isVideoCall?CrossAxisAlignment.start:CrossAxisAlignment.center,
          children: [
            if (imgUrl != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ClipOval(
                    child: Image.network(
                  imgUrl!,
                  height: 56,
                  width: 56,
                )),
              ),
            Column(
              children: [
                HMSTitleText(
                  text: userName,
                  textColor: HMSThemeColors.onSurfaceHighEmphasis,
                  fontSize: 24,
                  lineHeight: 32,
                ),
                const SizedBox(
                  height: 4,
                ),
                HMSSubheadingText(
                    text: isVideoCall ? "Video Calling..." : "Calling...",
                    textColor: HMSThemeColors.onSurfaceMediumEmphasis)
              ],
            )
          ],
        ),
      ),
    );
  }
}
