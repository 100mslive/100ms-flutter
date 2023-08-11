import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/widgets/bottom_sheets/audio_settings_bottom_sheet.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
        Row(
          children: [
            HMSRoomLayout.data?[0].logo?.url == null
                ? Container()
                : Image.network(
                    HMSRoomLayout.data![0].logo!.url!,
                    height: 30,
                    width: 30,
                  ),
            const SizedBox(
              width: 12,
            ),
            Selector<MeetingStore, Tuple3<bool, bool,bool>>(
                selector: (_, meetingStore) => Tuple3(
                    meetingStore.recordingType["browser"] ?? false,
                    meetingStore.recordingType["server"] ?? false,
                    meetingStore.recordingType["hls"] ?? false,
                    ),
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
                      : Container();
                })
          ],
        ),
        Row(
          children: [
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
            Selector<MeetingStore, HMSAudioDevice?>(
                selector: (_, meetingStore) =>
                    meetingStore.currentAudioDeviceMode,
                builder: (_, audioDevice, __) {
                  return HMSEmbeddedButton(
                      onTap: () {
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
