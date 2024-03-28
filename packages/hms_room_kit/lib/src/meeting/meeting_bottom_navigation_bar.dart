///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/audio_settings_bottom_sheet.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
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
        Selector<MeetingNavigationVisibilityController, bool>(
            selector: (_, meetingNavigationVisibilityController) =>
                meetingNavigationVisibilityController.showControls,
            builder: (_, showControls, __) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 5, bottom: 30.0),
                child: showControls
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                              isMicOn
                                                  ? HMSThemeColors
                                                      .onSurfaceHighEmphasis
                                                  : HMSThemeColors
                                                      .backgroundDim,
                                              BlendMode.srcIn),
                                          semanticsLabel: "audio_mute_button",
                                        ),
                                      ),
                                    );
                                  }),

                            ///Camera button
                            ///This button is only rendered if the local peer has the permission to
                            ///publish video
                            if ((Provider.of<MeetingStore>(context)
                                        .localPeer
                                        ?.role
                                        .publishSettings
                                        ?.allowed
                                        .contains("video") ??
                                    false) &&
                                (Constant.prebuiltOptions?.isVideoCall ??
                                    false))
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
                                                data.item1
                                                    ? HMSThemeColors
                                                        .onSurfaceHighEmphasis
                                                    : HMSThemeColors
                                                        .backgroundDim,
                                                BlendMode.srcIn),
                                            semanticsLabel:
                                                "video_mute_button"),
                                      ),
                                    );
                                  }),

                            ///This renders the screen share option
                            if ((context
                                        .read<MeetingStore>()
                                        .localPeer
                                        ?.role
                                        .publishSettings
                                        ?.allowed
                                        .contains("screen") ??
                                    false) &&
                                (Constant.prebuiltOptions?.isVideoCall ??
                                    false))
                              Selector<MeetingStore, bool>(
                                  selector: (_, meetingStore) =>
                                      meetingStore.isScreenShareOn,
                                  builder: (_, isScreenShareOn, __) {
                                    return HMSEmbeddedButton(
                                      onTap: () => {
                                        if (isScreenShareOn)
                                          {
                                            context
                                                .read<MeetingStore>()
                                                .stopScreenShare()
                                          }
                                        else
                                          {
                                            context
                                                .read<MeetingStore>()
                                                .startScreenShare()
                                          }
                                      },
                                      onColor: HMSThemeColors.backgroundDim,
                                      isActive: !isScreenShareOn,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          "packages/hms_room_kit/lib/src/assets/icons/screen_share.svg",
                                          colorFilter: ColorFilter.mode(
                                              !isScreenShareOn
                                                  ? HMSThemeColors
                                                      .onSurfaceHighEmphasis
                                                  : HMSThemeColors
                                                      .backgroundDim,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    );
                                  }),

                            ///This renders the audio device selection button
                            ///If the role is allowed to publish audio, we render the audio device selection button
                            ///else we render an empty SizedBox
                            Selector<MeetingStore,
                                    Tuple2<HMSAudioDevice?, bool>>(
                                selector: (_, meetingStore) => Tuple2(
                                    meetingStore.currentAudioOutputDevice,
                                    meetingStore.isSpeakerOn),
                                builder: (_, data, __) {
                                  return HMSEmbeddedButton(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (ctx) =>
                                                ChangeNotifierProvider.value(
                                                    value: context
                                                        .read<MeetingStore>(),
                                                    child:
                                                        const AudioSettingsBottomSheet()));
                                      },
                                      onColor: HMSThemeColors.backgroundDim,
                                      isActive: data.item1 ==
                                              HMSAudioDevice.SPEAKER_PHONE
                                          ? false
                                          : true,
                                      child: SvgPicture.asset(
                                        'packages/hms_room_kit/lib/src/assets/icons/${!data.item2 ? "speaker_state_off" : Utilities.getAudioDeviceIconName(data.item1)}.svg',
                                        colorFilter: ColorFilter.mode(
                                            data.item1 ==
                                                    HMSAudioDevice.SPEAKER_PHONE
                                                ? HMSThemeColors.baseBlack
                                                : HMSThemeColors
                                                    .onSurfaceHighEmphasis,
                                            BlendMode.srcIn),
                                        fit: BoxFit.scaleDown,
                                        semanticsLabel: "settings_button",
                                      ));
                                }),

                            if (!(Constant.prebuiltOptions?.isVideoCall ??
                                true))
                              HMSEmbeddedButton(
                                  onTap: () async {
                                    context
                                        .read<MeetingStore>()
                                        .endRoom(false, "Call ended");
                                  },
                                  isActive: true,
                                  onColor: HMSThemeColors.alertErrorDefault,
                                  child: SvgPicture.asset(
                                    'packages/hms_room_kit/lib/src/assets/icons/close.svg',
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    fit: BoxFit.scaleDown,
                                    semanticsLabel: "end_call_button",
                                  )),
                          ],
                        ),
                      )
                    : const SizedBox(),
              );
            }),
      ],
    );
  }
}
