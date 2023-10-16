///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/audio_settings_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';

///This widget is used to show the header of the meeting screen
///It contains the logo, live indicator, recording indicator, number of peers
///and the switch camera and audio device selection buttons
class MeetingHeader extends StatefulWidget {
  const MeetingHeader({super.key});

  @override
  State<MeetingHeader> createState() => _MeetingHeaderState();
}

class _MeetingHeaderState extends State<MeetingHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ///This renders the logo, live indicator, recording indicator, number of peers
        Row(
          children: [
            ///This renders the logo
            ///If the logo is null, we render an empty SizedBox
            ///If the logo is an svg, we render the svg
            ///If the logo is an image, we render the image
            HMSRoomLayout.roleLayoutData?.logo?.url == null
                ? Container()
                : HMSRoomLayout.roleLayoutData!.logo!.url!.contains("svg")
                    ? SvgPicture.network(
                        HMSRoomLayout.roleLayoutData!.logo!.url!,
                        height: 30,
                        width: 30,
                      )
                    : Image.network(
                        HMSRoomLayout.roleLayoutData!.logo!.url!,
                        height: 30,
                        width: 30,
                      ),
            const SizedBox(
              width: 12,
            ),

            ///This renders the live status
            ///If the HLS streaming is started, we render the live indicator
            ///else we render an empty Container
            ///
            ///For hls streaming status we use the streamingType map from the [MeetingStore]
            ///
            ///If recording initialising state is true we show the loader
            Selector<MeetingStore, bool>(
                selector: (_, meetingStore) =>
                    meetingStore.streamingType['hls'] ?? false,
                builder: (_, isHLSStarted, __) {
                  return isHLSStarted
                      ? Container(
                          height: 24,
                          width: 43,
                          decoration: BoxDecoration(
                              color: HMSThemeColors.alertErrorDefault,
                              borderRadius: BorderRadius.circular(4)),
                          child: Center(
                            child: HMSTitleText(
                                text: "LIVE",
                                fontSize: 10,
                                lineHeight: 16,
                                letterSpacing: 1.5,
                                textColor: HMSThemeColors.alertErrorBrighter),
                          ),
                        )
                      : Container();
                }),
            const SizedBox(
              width: 8,
            ),

            ///This renders the recording status
            ///If the recording is started, we render the recording indicator
            ///else we render an empty Container
            ///
            ///For recording status we use the recordingType map from the [MeetingStore]
            Selector<MeetingStore, Tuple4<bool, bool, bool, bool>>(
                selector: (_, meetingStore) => Tuple4(
                    meetingStore.recordingType["browser"] ?? false,
                    meetingStore.recordingType["server"] ?? false,
                    meetingStore.recordingType["hls"] ?? false,
                    meetingStore.isRecordingInInitialisingState),
                builder: (_, data, __) {
                  return (data.item1 || data.item2 || data.item3)
                      ? SvgPicture.asset(
                          "packages/hms_room_kit/lib/src/assets/icons/record.svg",
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                              HMSThemeColors.alertErrorDefault,
                              BlendMode.srcIn),
                        )
                      : data.item4
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: HMSThemeColors.onSurfaceHighEmphasis,
                              ))
                          : Container();
                }),
            const SizedBox(
              width: 8,
            ),

            ///This renders the number of peers
            ///If the HLS streaming is started, we render the number of peers
            ///else we render an empty Container
            Selector<MeetingStore, Tuple2<bool, int>>(
                selector: (_, meetingStore) => Tuple2(
                    meetingStore.streamingType['hls'] ?? false,
                    meetingStore.peersInRoom),
                builder: (_, data, __) {
                  return data.item1
                      ? Container(
                          width: 59,
                          height: 24,
                          constraints:
                              const BoxConstraints(minWidth: 59, maxWidth: 70),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: HMSThemeColors.borderBright, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: HMSThemeColors.backgroundDim
                                  .withOpacity(0.64)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "packages/hms_room_kit/lib/src/assets/icons/watching.svg",
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(
                                    HMSThemeColors.onSurfaceHighEmphasis,
                                    BlendMode.srcIn),
                                semanticsLabel: "fl_watching",
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              HMSTitleText(
                                  text: Utilities.formatNumber(data.item2),
                                  fontSize: 10,
                                  lineHeight: 10,
                                  letterSpacing: 1.5,
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis)
                            ],
                          ))
                      : Container();
                })
          ],
        ),
        Row(
          children: [
            ///This renders the switch camera button
            ///If the role is allowed to publish video, we render the switch camera button
            ///else we render an empty SizedBox
            ///
            ///If the video is on we disable the button
            Selector<MeetingStore, Tuple2<bool, List<String>?>>(
                selector: (_, meetingStore) => Tuple2(
                    meetingStore.isVideoOn,
                    meetingStore.localPeer?.role.publishSettings?.allowed ??
                        []),
                builder: (_, data, __) {
                  return (data.item2?.contains("video") ?? false)
                      ? HMSEmbeddedButton(
                          onTap: () => {
                            if (data.item1)
                              {context.read<MeetingStore>().switchCamera()}
                          },
                          isActive: true,
                          onColor: HMSThemeColors.backgroundDim,
                          child: SvgPicture.asset(
                            "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                            colorFilter: ColorFilter.mode(
                                data.item1
                                    ? HMSThemeColors.onSurfaceHighEmphasis
                                    : HMSThemeColors.onSurfaceLowEmphasis,
                                BlendMode.srcIn),
                            fit: BoxFit.scaleDown,
                            semanticsLabel: "fl_switch_camera",
                          ),
                        )
                      : const SizedBox();
                }),
            const SizedBox(
              width: 16,
            ),

            ///This renders the audio device selection button
            ///If the role is allowed to publish audio, we render the audio device selection button
            ///else we render an empty SizedBox
            Selector<MeetingStore, HMSAudioDevice?>(
                selector: (_, meetingStore) =>
                    meetingStore.currentAudioDeviceMode,
                builder: (_, audioDevice, __) {
                  return HMSEmbeddedButton(
                      onTap: () {
                        ///If the platform is iOS, we use the iOS UI to switch audio output
                        ///on Android we use the [AudioSettingsBottomSheet] to switch audio output
                        if (Platform.isIOS) {
                          context
                              .read<MeetingStore>()
                              .switchAudioOutputUsingiOSUI();
                        } else {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (ctx) => ChangeNotifierProvider.value(
                                  value: context.read<MeetingStore>(),
                                  child: const AudioSettingsBottomSheet()));
                        }
                      },
                      onColor: HMSThemeColors.backgroundDim,
                      isActive: true,
                      child: SvgPicture.asset(
                        'packages/hms_room_kit/lib/src/assets/icons/${Utilities.getAudioDeviceIconName(audioDevice)}.svg',
                        colorFilter: ColorFilter.mode(
                            HMSThemeColors.onSurfaceHighEmphasis,
                            BlendMode.srcIn),
                        fit: BoxFit.scaleDown,
                        semanticsLabel: "settings_button",
                      ));
                }),
          ],
        )
      ],
    );
  }
}
