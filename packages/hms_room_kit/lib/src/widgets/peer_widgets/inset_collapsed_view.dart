import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:provider/provider.dart';

class InsetCollapsedView extends StatefulWidget {
  const InsetCollapsedView({super.key});

  @override
  State<InsetCollapsedView> createState() => _InsetCollapsedViewState();
}

class _InsetCollapsedViewState extends State<InsetCollapsedView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 126,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HMSThemeColors.surfaceDefault),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
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
                          height: 20,
                          width: 20,
                          onTap: () =>
                              context.read<MeetingStore>().toggleMicMuteState(),
                          isActive: false,
                          borderRadius: 4,
                          offColor: HMSThemeColors.surfaceBright,
                          disabledBorderColor: HMSThemeColors.surfaceBright,
                          child: SvgPicture.asset(
                            isMicOn
                                ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                                : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                            semanticsLabel: "audio_mute_button",
                          ),
                        );
                      }),
                const SizedBox(
                  width: 8,
                ),
                if (Provider.of<MeetingStore>(context)
                        .localPeer
                        ?.role
                        .publishSettings
                        ?.allowed
                        .contains("video") ??
                    false)
                  Selector<MeetingStore, bool>(
                      selector: (_, meetingStore) => meetingStore.isVideoOn,
                      builder: (_, isMicOn, __) {
                        return HMSEmbeddedButton(
                          height: 20,
                          width: 20,
                          onTap: () => context
                              .read<MeetingStore>()
                              .toggleCameraMuteState(),
                          isActive: false,
                          borderRadius: 4,
                          offColor: HMSThemeColors.surfaceBright,
                          disabledBorderColor: HMSThemeColors.surfaceBright,
                          child: SvgPicture.asset(
                            isMicOn
                                ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                                : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                            height: 16,
                            width: 16,
                            colorFilter: ColorFilter.mode(
                                HMSThemeColors.onSurfaceHighEmphasis,
                                BlendMode.srcIn),
                            semanticsLabel: "video_mute_button",
                          ),
                        );
                      }),
                const SizedBox(
                  width: 8,
                ),
                HMSSubheadingText(
                    text: "You",
                    textColor: HMSThemeColors.onSurfaceHighEmphasis),
              ],
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "packages/hms_room_kit/lib/src/assets/icons/maximize.svg",
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(
                      HMSThemeColors.onSurfaceHighEmphasis, BlendMode.srcIn),
                  semanticsLabel: "maximize_button",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
