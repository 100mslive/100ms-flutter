///Package imports
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

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
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          previewStore.isAudioOn
                              ? HMSThemeColors.onSurfaceHighEmphasis
                              : HMSThemeColors.backgroundDim,
                          BlendMode.srcIn),
                      fit: BoxFit.scaleDown,
                      semanticsLabel: "audio_mute_button",
                    ),
                  ),

                ///This renders the [Video Button] only if the
                ///Peer role has the permission to publish video
                ///and the Peer is not null
                // if (previewStore.peer != null &&
                //     previewStore.peer!.role.publishSettings!.allowed
                //         .contains("video"))
                //   HMSEmbeddedButton(
                //     onTap: () async => (previewStore.localTracks.isEmpty)
                //         ? null
                //         : previewStore.toggleCameraMuteState(),
                //     isActive: previewStore.isVideoOn,
                //     child: SvgPicture.asset(
                //       previewStore.isVideoOn
                //           ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                //           : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                //       colorFilter: ColorFilter.mode(
                //           previewStore.isVideoOn
                //               ? HMSThemeColors.onSurfaceHighEmphasis
                //               : HMSThemeColors.backgroundDim,
                //           BlendMode.srcIn),
                //       fit: BoxFit.scaleDown,
                //       semanticsLabel: "video_mute_button",
                //     ),
                //   ),

                ///This renders the [Switch Camera Button] only if the
                ///Peer role has the permission to publish video
                ///and the Peer is not null
                if (previewStore.peer != null &&
                    previewStore.peer!.role.publishSettings!.allowed
                        .contains("video") &&
                    (Constant.prebuiltOptions?.isVideoCall ?? false))
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
                      isActive: previewStore.currentAudioOutputDevice ==
                              HMSAudioDevice.SPEAKER_PHONE
                          ? false
                          : true,
                      child: SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/${previewStore.isRoomMute ? "speaker_state_off" : Utilities.getAudioDeviceIconName(previewStore.currentAudioOutputDevice)}.svg',
                        colorFilter: ColorFilter.mode(
                            previewStore.currentAudioOutputDevice ==
                                    HMSAudioDevice.SPEAKER_PHONE
                                ? HMSThemeColors.baseBlack
                                : HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                        semanticsLabel: "settings_button",
                      )),
                HMSEmbeddedButton(
                    onTap: () {
                      previewStore.leave();
                      Navigator.pop(context);
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
        : const SizedBox();
  }
}
