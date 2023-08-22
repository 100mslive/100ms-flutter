import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/enums/session_store_keys.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/app_utilities_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/chat_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ///Leave Button
        HMSEmbeddedButton(
          onTap: () async => {await UtilityComponents.onBackPressed(context)},
          offColor: HMSThemeColors.alertErrorDefault,
          disabledBorderColor: HMSThemeColors.alertErrorDefault,
          isActive: false,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/leave.svg",
              colorFilter: ColorFilter.mode(
                  HMSThemeColors.alertErrorBrighter, BlendMode.srcIn),
              semanticsLabel: "leave_room_button",
            ),
          ),
        ),

        ///Microphone button
        if (Provider.of<MeetingStore>(context)
                .localPeer
                ?.role
                .publishSettings
                ?.allowed
                .contains("audio") ??
            false)
          Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isMicOn,
              builder: (_, isMicOn, __) {
                return HMSEmbeddedButton(
                  onTap: () =>
                      {context.read<MeetingStore>().toggleMicMuteState()},
                  disabledBorderColor: HMSThemeColors.surfaceBrighter,
                  enabledBorderColor: HMSThemeColors.borderBright,
                  offColor: HMSThemeColors.surfaceBrighter,
                  onColor: HMSThemeColors.backgroundDim,
                  isActive: isMicOn,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      isMicOn
                          ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                          : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                      colorFilter: ColorFilter.mode(
                          HMSThemeColors.onSurfaceHighEmphasis,
                          BlendMode.srcIn),
                      semanticsLabel: "audio_mute_button",
                    ),
                  ),
                );
              }),

        ///Camera button
        if (Provider.of<MeetingStore>(context)
                .localPeer
                ?.role
                .publishSettings
                ?.allowed
                .contains("video") ??
            false)
          Selector<MeetingStore, Tuple2<bool, bool>>(
              selector: (_, meetingStore) => Tuple2(meetingStore.isVideoOn,
                  meetingStore.meetingMode == MeetingMode.audio),
              builder: (_, data, __) {
                return HMSEmbeddedButton(
                  onTap: () => {
                    (data.item2)
                        ? null
                        : context.read<MeetingStore>().toggleCameraMuteState(),
                  },
                  disabledBorderColor: HMSThemeColors.surfaceBrighter,
                  enabledBorderColor: HMSThemeColors.borderBright,
                  offColor: HMSThemeColors.surfaceBrighter,
                  onColor: HMSThemeColors.backgroundDim,
                  isActive: data.item1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                        data.item1
                            ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                            : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        semanticsLabel: "video_mute_button"),
                  ),
                );
              }),

        ///Chat Button
        HMSEmbeddedButton(
          onTap: () => {
            context.read<MeetingStore>().getSessionMetadata(
                SessionStoreKeyValues.getNameFromMethod(
                    SessionStoreKey.pinnedMessageSessionKey)),
            context.read<MeetingStore>().setNewMessageFalse(),
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: HMSThemeColors.backgroundDefault,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              context: context,
              builder: (ctx) => ChangeNotifierProvider.value(
                  value: context.read<MeetingStore>(),
                  child: const ChatBottomSheet()),
            )
          },
          enabledBorderColor: HMSThemeColors.borderBright,
          onColor: HMSThemeColors.backgroundDim,
          isActive: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "packages/hms_room_kit/lib/src/assets/icons/message_badge_off.svg",
              colorFilter: ColorFilter.mode(
                  HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
              semanticsLabel: "chat_button",
            ),
          ),
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
                  child: const AppUtilitiesBottomSheet()),
            )
          },
          enabledBorderColor: HMSThemeColors.borderBright,
          onColor: HMSThemeColors.backgroundDim,
          isActive: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
                "packages/hms_room_kit/lib/src/assets/icons/menu.svg",
                colorFilter: ColorFilter.mode(
                    HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                semanticsLabel: "more_button"),
          ),
        ),
      ],
    );
  }
}
