///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_only_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/tab_widgets/chat_participants_tab_bar.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_chat_component.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/hls_more_options.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';

///[HLSViewerBottomNavigationBar] is the bottom navigation bar for the HLS Viewer
class HLSViewerBottomNavigationBar extends StatelessWidget {
  const HLSViewerBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(64)])),
      child: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 32.0 : 8),

        ///Here we render the chat component if the chat is opened
        ///We also render the leave button, hand raise button, chat button and the menu button
        child: Column(
          children: [
            ///Chat Component only visible when the chat is opened
            if (HMSRoomLayout.chatData != null)
              Selector<HLSPlayerStore, bool>(
                  selector: (_, hlsPlayerStore) => hlsPlayerStore.isChatOpened,
                  builder: (_, isChatOpened, __) {
                    if (isChatOpened) {
                      Provider.of<MeetingStore>(context, listen: true)
                          .isNewMessageReceived = false;
                    }
                    return isChatOpened
                        ? const HLSChatComponent()
                        : Container();
                  }),

            ///Bottom Navigation Bar
            ///We render the leave button, hand raise button, chat button and the menu button
            ///We only render the bottom navigation bar when the stream controls are visible
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
                                  "packages/hms_room_kit/lib/src/assets/icons/exit_room.svg",
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
                                      context
                                          .read<MeetingStore>()
                                          .toggleLocalPeerHandRaise(),
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
                                        semanticsLabel: "hand_raise_button",
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 24,
                            ),

                            ///Chat Button
                            if (HMSRoomLayout.chatData != null)
                              Selector<HLSPlayerStore, bool>(
                                  selector: (_, hlsPlayerStore) =>
                                      hlsPlayerStore.isChatOpened,
                                  builder: (_, isChatOpened, __) {
                                    return HMSEmbeddedButton(
                                      onTap: () => {
                                        if (HMSRoomLayout.chatData?.isOverlay ??
                                            false)
                                          {
                                            context
                                                .read<HLSPlayerStore>()
                                                .toggleIsChatOpened()
                                          }
                                        else
                                          {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  HMSThemeColors.surfaceDim,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16)),
                                              ),
                                              context: context,
                                              builder: (ctx) =>
                                                  ChangeNotifierProvider.value(
                                                      value: context
                                                          .read<MeetingStore>(),
                                                      child: HMSRoomLayout
                                                              .isParticipantsListEnabled
                                                          ? const ChatParticipantsTabBar(
                                                              tabIndex: 0,
                                                            )
                                                          : const ChatOnlyBottomSheet()),
                                            )
                                          }
                                      },
                                      enabledBorderColor: HMSThemeColors
                                          .backgroundDim
                                          .withAlpha(64),
                                      onColor: HMSThemeColors.backgroundDim
                                          .withAlpha(64),
                                      isActive: !isChatOpened,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Selector<MeetingStore, bool>(
                                              selector: (_, meetingStore) =>
                                                  meetingStore
                                                      .isNewMessageReceived,
                                              builder: (_, isNewMessageReceived,
                                                  __) {
                                                return isNewMessageReceived
                                                    ? Badge(
                                                        backgroundColor:
                                                            HMSThemeColors
                                                                .primaryDefault,
                                                        child: SvgPicture.asset(
                                                          "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                                          semanticsLabel:
                                                              "chat_button",
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  HMSThemeColors
                                                                      .onSurfaceHighEmphasis,
                                                                  BlendMode
                                                                      .srcIn),
                                                        ),
                                                      )
                                                    : SvgPicture.asset(
                                                        "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                HMSThemeColors
                                                                    .onSurfaceHighEmphasis,
                                                                BlendMode
                                                                    .srcIn),
                                                        semanticsLabel:
                                                            "chat_button",
                                                      );
                                              })),
                                    );
                                  }),

                            if (HMSRoomLayout.chatData != null)
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
