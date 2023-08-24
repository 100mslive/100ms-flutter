import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_chat_component.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/hls_more_options.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:provider/provider.dart';

class HLSViewerBottomNavigationBar extends StatelessWidget {
  const HLSViewerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            HMSThemeColors.backgroundDim.withAlpha(0),
            HMSThemeColors.backgroundDim.withAlpha(64)
          ])),
      child: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 32.0 : 8),
        child: Column(
          children: [
            Selector<HLSPlayerStore, bool>(
                selector: (_, hlsPlayerStore) => hlsPlayerStore.isChatOpened,
                builder: (_, isChatOpened, __) {
                  return isChatOpened ? const HLSChatComponent() : Container();
                }),
            Selector<HLSPlayerStore, bool>(
                selector: (_, hlsPlayerStore) =>
                    hlsPlayerStore.areStreamControlsVisible,
                builder: (_, areStreamControlsVisible, __) {
                  return areStreamControlsVisible
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ///Leave Button
                            HMSEmbeddedButton(
                              onTap: () async => {
                                await UtilityComponents.onBackPressed(context)
                              },
                              offColor: HMSThemeColors.alertErrorDefault,
                              disabledBorderColor:
                                  HMSThemeColors.alertErrorDefault,
                              isActive: false,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "packages/hms_room_kit/lib/src/assets/icons/leave.svg",
                                  colorFilter: ColorFilter.mode(
                                      HMSThemeColors.alertErrorBrighter,
                                      BlendMode.srcIn),
                                  semanticsLabel: "leave_room_button",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),

                            ///Hand Raise Button
                            Selector<MeetingStore, bool>(
                                selector: (_, meetingStore) =>
                                    meetingStore.isRaisedHand,
                                builder: (_, isRaisedHand, __) {
                                  return HMSEmbeddedButton(
                                    onTap: () => {
                                      // context
                                      //     .read<MeetingStore>()
                                      //     .changeMetadata(),
                                      context
                                          .read<MeetingStore>()
                                          .previewForRole("host")
                                    },
                                    enabledBorderColor: HMSThemeColors
                                        .backgroundDim
                                        .withAlpha(64),
                                    onColor: HMSThemeColors.backgroundDim
                                        .withAlpha(64),
                                    isActive: !isRaisedHand,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/hand_outline.svg",
                                        colorFilter: ColorFilter.mode(
                                            HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            BlendMode.srcIn),
                                        semanticsLabel: "chat_button",
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 24,
                            ),

                            ///Chat Button
                            Selector<HLSPlayerStore, bool>(
                                selector: (_, hlsPlayerStore) =>
                                    hlsPlayerStore.isChatOpened,
                                builder: (_, isChatOpened, __) {
                                  return HMSEmbeddedButton(
                                    onTap: () => {
                                      context
                                          .read<HLSPlayerStore>()
                                          .toggleIsChatOpened()
                                    },
                                    enabledBorderColor: HMSThemeColors
                                        .backgroundDim
                                        .withAlpha(64),
                                    onColor: HMSThemeColors.backgroundDim
                                        .withAlpha(64),
                                    offColor: HMSThemeColors.backgroundDim
                                        .withAlpha(64),
                                    isActive: !isChatOpened,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                        colorFilter: ColorFilter.mode(
                                            HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            BlendMode.srcIn),
                                        semanticsLabel: "chat_button",
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 24,
                            ),

                            ///Menu Button
                            HMSEmbeddedButton(
                              onTap: () async => {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: HMSThemeColors.surfaceDim,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16)),
                                  ),
                                  context: context,
                                  builder: (ctx) => ChangeNotifierProvider.value(
                                      value: context.read<MeetingStore>(),
                                      child: const HLSMoreOptionsBottomSheet()),
                                )
                              },
                              enabledBorderColor:
                                  HMSThemeColors.backgroundDim.withAlpha(64),
                              onColor:
                                  HMSThemeColors.backgroundDim.withAlpha(64),
                              isActive: true,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/menu.svg",
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    semanticsLabel: "more_button"),
                              ),
                            ),
                          ],
                        )
                      : Container();
                }),
          ],
        ),
      ),
    );
  }
}
