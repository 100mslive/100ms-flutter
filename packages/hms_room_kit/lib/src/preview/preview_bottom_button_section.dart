///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///Project imports
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview/preview_device_settings.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';

///This renders the bottom button section
///It contains the audio, video, switch camera and audio device selection buttons
class PreviewBottomButtonSection extends StatelessWidget {
  final PreviewStore previewStore;
  const PreviewBottomButtonSection({super.key, required this.previewStore});

  @override
  Widget build(BuildContext context) {
    ///If the peer is not null, we render the buttons
    ///else we render an empty SizedBox
    return (previewStore.peer != null)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ///This renders the [Audio Button] only if the
                  ///Peer role has the permission to publish audio
                  ///and the Peer is not null
                  if (previewStore.peer != null &&
                      previewStore.peer!.role.publishSettings!.allowed
                          .contains("audio"))
                    HMSEmbeddedButton(
                      onTap: () async => previewStore.toggleMicMuteState(),
                      isActive: previewStore.isAudioOn,
                      child: SvgPicture.asset(
                        previewStore.isAudioOn
                            ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                            : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                        semanticsLabel: "audio_mute_button",
                      ),
                    ),
                  const SizedBox(
                    width: 16,
                  ),

                  ///This renders the [Video Button] only if the
                  ///Peer role has the permission to publish video
                  ///and the Peer is not null
                  if (previewStore.peer != null &&
                      previewStore.peer!.role.publishSettings!.allowed
                          .contains("video"))
                    HMSEmbeddedButton(
                      onTap: () async => (previewStore.localTracks.isEmpty)
                          ? null
                          : previewStore.toggleCameraMuteState(),
                      isActive: previewStore.isVideoOn,
                      child: SvgPicture.asset(
                        previewStore.isVideoOn
                            ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                            : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                        semanticsLabel: "video_mute_button",
                      ),
                    ),
                  const SizedBox(
                    width: 16,
                  ),

                  ///This renders the [Switch Camera Button] only if the
                  ///Peer role has the permission to publish video
                  ///and the Peer is not null
                  if (previewStore.peer != null &&
                      previewStore.peer!.role.publishSettings!.allowed
                          .contains("video"))
                    HMSEmbeddedButton(
                      onTap: () async => previewStore.switchCamera(),
                      isActive: true,
                      child: SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                        colorFilter: ColorFilter.mode(
                            previewStore.isVideoOn
                                ? HMSThemeColors.onSurfaceHighEmphasis
                                : HMSThemeColors.onSurfaceLowEmphasis,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                        semanticsLabel: "switch_camera_button",
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  ///This renders the [Noise Cancellation Button] only if the
                  ///Peer role has the permission to publish audio
                  ///and the Peer is not null
                  ///and the noise cancellation is available
                  ///and mic is unmuted
                  if ((previewStore.peer?.role.publishSettings?.allowed
                              .contains("audio") ??
                          false) &&
                      previewStore.isNoiseCancellationAvailable &&
                      previewStore.isAudioOn)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: HMSEmbeddedButton(
                          onTap: () {
                            previewStore.toggleNoiseCancellation();
                          },
                          isActive: !previewStore.isNoiseCancellationEnabled,
                          child: SvgPicture.asset(
                            'packages/hms_room_kit/lib/src/assets/icons/music_wave.svg',
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                            fit: BoxFit.scaleDown,
                            semanticsLabel: "noise_cancellation_button",
                          )),
                    ),

                  ///This renders the [Audio Device Selection Button] only if the
                  ///Peer role has the permission to publish audio
                  ///and the Peer is not null
                  if (previewStore.peer != null &&
                      previewStore.peer!.role.publishSettings!.allowed
                          .contains("audio"))
                    HMSEmbeddedButton(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (ctx) => ChangeNotifierProvider.value(
                                  value: previewStore,
                                  child: const PreviewDeviceSettings()));
                        },
                        isActive: true,
                        child: SvgPicture.asset(
                          'packages/hms_room_kit/lib/src/assets/icons/${previewStore.isRoomMute ? "speaker_state_off" : Utilities.getAudioDeviceIconName(previewStore.currentAudioOutputDevice)}.svg',
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.onSurfaceHighEmphasis,
                              BlendMode.srcIn),
                          fit: BoxFit.scaleDown,
                          semanticsLabel: "settings_button",
                        )),
                ],
              )
            ],
          )
        : const SizedBox();
  }
}
