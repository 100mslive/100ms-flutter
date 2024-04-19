library;

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/src/widgets/chat_widgets/overlay_chat_component.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_only_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/tab_widgets/chat_participants_tab_bar.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/app_utilities_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';

///This renders the meeting bottom navigation bar
///It contains the leave, mic, camera, chat and menu buttons
///The mic and camera buttons are only rendered if the local peer has the
///permission to publish audio and video respectively
class MeetingBottomNavigationBar extends StatefulWidget {
  const MeetingBottomNavigationBar({super.key});

  @override
  State<MeetingBottomNavigationBar> createState() =>
      _MeetingBottomNavigationBarState();
}

class _MeetingBottomNavigationBarState
    extends State<MeetingBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (HMSRoomLayout.chatData?.isOverlay ?? false)
          Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isOverlayChatOpened,
              builder: (_, isOverlayChatOpened, __) {
                return isOverlayChatOpened
                    ? Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black.withAlpha(0),
                              Colors.black.withAlpha(64)
                            ])),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  15),
                          child: const OverlayChatComponent(),
                        ))
                    : const SizedBox();
              }),
        Selector<MeetingNavigationVisibilityController, bool>(
            selector: (_, meetingNavigationVisibilityController) =>
                meetingNavigationVisibilityController.showControls,
            builder: (_, showControls, __) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 5, bottom: 8.0),
                height: showControls ? 40 : 0,
                child: showControls
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                          ///Microphone button
                          ///This button is only rendered if the local peer has the permission to
                          ///publish audio
                          if (Provider.of<MeetingStore>(context)
                                  .localPeer
                                  ?.role
                                  .publishSettings
                                  ?.allowed
                                  .contains("audio") ??
                              false)
                            Selector<MeetingStore, bool>(
                                selector: (_, meetingStore) =>
                                    meetingStore.isMicOn,
                                builder: (_, isMicOn, __) {
                                  return HMSEmbeddedButton(
                                    onTap: () => {
                                      context
                                          .read<MeetingStore>()
                                          .toggleMicMuteState()
                                    },
                                    onColor: HMSThemeColors.backgroundDim,
                                    isActive: isMicOn,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        isMicOn
                                            ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                                            : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                                        colorFilter: ColorFilter.mode(
                                            HMSThemeColors
                                                .onSurfaceHighEmphasis,
                                            BlendMode.srcIn),
                                        semanticsLabel: "audio_mute_button",
                                      ),
                                    ),
                                  );
                                }),

                          ///Camera button
                          ///This button is only rendered if the local peer has the permission to
                          ///publish video
                          if (Provider.of<MeetingStore>(context)
                                  .localPeer
                                  ?.role
                                  .publishSettings
                                  ?.allowed
                                  .contains("video") ??
                              false)
                            Selector<MeetingStore, Tuple2<bool, bool>>(
                                selector: (_, meetingStore) => Tuple2(
                                    meetingStore.isVideoOn,
                                    meetingStore.meetingMode ==
                                        MeetingMode.audio),
                                builder: (_, data, __) {
                                  return HMSEmbeddedButton(
                                    onTap: () => {
                                      (data.item2)
                                          ? null
                                          : context
                                              .read<MeetingStore>()
                                              .toggleCameraMuteState(),
                                    },
                                    onColor: HMSThemeColors.backgroundDim,
                                    isActive: data.item1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          data.item1
                                              ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                                              : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                                          colorFilter: ColorFilter.mode(
                                              HMSThemeColors
                                                  .onSurfaceHighEmphasis,
                                              BlendMode.srcIn),
                                          semanticsLabel: "video_mute_button"),
                                    ),
                                  );
                                }),

                          ///Chat Button
                          if (HMSRoomLayout.chatData != null)
                            Selector<MeetingStore, Tuple2>(
                                selector: (_, meetingStore) => Tuple2(
                                    meetingStore.isNewMessageReceived,
                                    meetingStore.isOverlayChatOpened),
                                builder: (_, chatState, __) {
                                  return HMSEmbeddedButton(
                                    onTap: () => {
                                      if (HMSRoomLayout.chatData?.isOverlay ??
                                          false)
                                        {
                                          context
                                              .read<MeetingStore>()
                                              .toggleChatOverlay()
                                        }
                                      else
                                        {
                                          context
                                              .read<MeetingStore>()
                                              .setNewMessageFalse(),
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor:
                                                HMSThemeColors.surfaceDim,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
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
                                    onColor: HMSThemeColors.backgroundDim,
                                    isActive: !(chatState.item2 &&
                                        (HMSRoomLayout.chatData?.isOverlay ??
                                            false)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: chatState.item1 && !chatState.item2
                                          ? Badge(
                                              backgroundColor:
                                                  HMSThemeColors.primaryDefault,
                                              child: SvgPicture.asset(
                                                "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
                                                semanticsLabel: "chat_button",
                                                colorFilter: ColorFilter.mode(
                                                    HMSThemeColors
                                                        .onSurfaceHighEmphasis,
                                                    BlendMode.srcIn),
                                              ),
                                            )
                                          : SvgPicture.asset(
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
                                    child: const AppUtilitiesBottomSheet()),
                              )
                            },
                            onColor: HMSThemeColors.backgroundDim,
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
                    : const SizedBox(),
              );
            }),
      ],
    );
  }
}
