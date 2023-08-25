import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

class PreviewForRoleBottomSheet extends StatefulWidget {
  final MeetingStore meetingStore;
  final HMSRoleChangeRequest? roleChangeRequest;
  const PreviewForRoleBottomSheet(
      {super.key, required this.meetingStore, required this.roleChangeRequest});

  @override
  State<PreviewForRoleBottomSheet> createState() =>
      _PreviewForRoleBottomSheetState();
}

class _PreviewForRoleBottomSheetState extends State<PreviewForRoleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            color: HMSThemeColors.surfaceDim,
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HMSTitleText(
                      text: "You’re invited to join the stage",
                      textColor: HMSThemeColors.onSurfaceHighEmphasis,
                      fontSize: 20,
                      letterSpacing: 0.15,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HMSTitleText(
                      text: "Setup your audio and video before joining",
                      textColor: HMSThemeColors.onSurfaceMediumEmphasis,
                      fontSize: 14,
                      lineHeight: 20,
                      letterSpacing: 0.25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (widget.meetingStore.localPeer != null &&
                            widget.meetingStore.previewForRoleAudioTrack !=
                                null)
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isMicOn,
                              builder: (_, isMicOn, __) {
                                return HMSEmbeddedButton(
                                  onTap: () async =>
                                      widget.meetingStore.toggleMicMuteState(),
                                  isActive: isMicOn,
                                  onColor: HMSThemeColors.surfaceDim,
                                  child: SvgPicture.asset(
                                    isMicOn
                                        ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                                        : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    fit: BoxFit.scaleDown,
                                    semanticsLabel: "audio_mute_button",
                                  ),
                                );
                              }),
                        const SizedBox(
                          width: 16,
                        ),
                        if (widget.meetingStore.localPeer != null &&
                            widget.meetingStore.previewForRoleVideoTrack !=
                                null)
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isVideoOn,
                              builder: (_, isVideoOn, __) {
                                return HMSEmbeddedButton(
                                  onTap: () async => widget.meetingStore
                                      .toggleCameraMuteState(),
                                  isActive: isVideoOn,
                                  onColor: HMSThemeColors.surfaceDim,
                                  child: SvgPicture.asset(
                                    isVideoOn
                                        ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                                        : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                                    colorFilter: ColorFilter.mode(
                                        HMSThemeColors.onSurfaceHighEmphasis,
                                        BlendMode.srcIn),
                                    fit: BoxFit.scaleDown,
                                    semanticsLabel: "video_mute_button",
                                  ),
                                );
                              }),
                        const SizedBox(
                          width: 16,
                        ),
                        if (widget.meetingStore.localPeer != null &&
                            widget.meetingStore.previewForRoleVideoTrack !=
                                null)
                          Selector<MeetingStore, bool>(
                              selector: (_, meetingStore) =>
                                  meetingStore.isVideoOn,
                              builder: (_, isVideoOn, __) {
                                return HMSEmbeddedButton(
                                  onTap: () async =>
                                      widget.meetingStore.switchCamera(),
                                  isActive: true,
                                  onColor: HMSThemeColors.surfaceDim,
                                  child: SvgPicture.asset(
                                    "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                                    colorFilter: ColorFilter.mode(
                                        isVideoOn
                                            ? HMSThemeColors
                                                .onSurfaceHighEmphasis
                                            : HMSThemeColors
                                                .onSurfaceLowEmphasis,
                                        BlendMode.srcIn),
                                    fit: BoxFit.scaleDown,
                                    semanticsLabel: "switch_camera_button",
                                  ),
                                );
                              }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(
                            HMSThemeColors.surfaceDim),
                        backgroundColor: MaterialStateProperty.all(
                            HMSThemeColors.primaryDefault),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.roleChangeRequest != null) {
                        context
                            .read<MeetingStore>()
                            .acceptChangeRole(widget.roleChangeRequest!);
                      }
                    },
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: HMSTitleText(
                            text: "Join Now",
                            textColor: HMSThemeColors.onPrimaryHighEmphasis),
                      ),
                    )),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(
                            HMSThemeColors.surfaceDim),
                        backgroundColor: MaterialStateProperty.all(
                            HMSThemeColors.surfaceDim),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: BorderSide(
                              color: HMSThemeColors.secondaryDefault),
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<MeetingStore>().cancelPreview();
                    },
                    child: SizedBox(
                      height: 48,
                      child: Center(
                        child: HMSTitleText(
                            text: "Decline",
                            textColor: HMSThemeColors.onPrimaryHighEmphasis),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
