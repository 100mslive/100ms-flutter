///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_cross_button.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

///This renders the audio device selection bottom sheet only on android
///It contains the list of available audio devices
class PreviewDeviceSettings extends StatefulWidget {
  const PreviewDeviceSettings({
    Key? key,
  }) : super(key: key);
  @override
  State<PreviewDeviceSettings> createState() => _PreviewDeviceSettingsState();
}

class _PreviewDeviceSettingsState extends State<PreviewDeviceSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        maxChildSize:
            (context.read<PreviewStore>().availableAudioOutputDevices.length +
                    1.2) *
                0.1,
        minChildSize:
            (context.read<PreviewStore>().availableAudioOutputDevices.length +
                    1) *
                0.1,
        initialChildSize:
            (context.read<PreviewStore>().availableAudioOutputDevices.length +
                    1) *
                0.1,
        builder: (context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: HMSThemeColors.backgroundDefault,
            ),

            ///We are using the selector to rebuild the widget only when the available audio devices list changes
            ///or the current audio device changes
            child: Selector<PreviewStore,
                    Tuple3<List<HMSAudioDevice>, int, HMSAudioDevice?>>(
                selector: (_, previewStore) => Tuple3(
                    previewStore.availableAudioOutputDevices,
                    previewStore.availableAudioOutputDevices.length,
                    previewStore.currentAudioOutputDevice),
                builder: (context, data, _) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                HMSTitleText(
                                  text: "Audio Output",
                                  textColor:
                                      HMSThemeColors.onSurfaceHighEmphasis,
                                  letterSpacing: 0.15,
                                ),
                              ],
                            ),
                            const Row(
                              children: [HMSCrossButton()],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            color: HMSThemeColors.borderDefault,
                            height: 5,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              controller: scrollController,
                              itemCount: data.item2,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<PreviewStore>()
                                            .switchAudioOutput(
                                                audioDevice: data.item1[index]);
                                        Navigator.pop(context);
                                      },

                                      ///Here we are checking if the current audio device is automatic or not
                                      ///If it is automatic then we render the automatic icon
                                      ///else we render the audio device icon
                                      ///
                                      ///If the current audio device is the selected audio device then we render the tick icon
                                      ///else we render an empty container
                                      child: data.item1[index] ==
                                              HMSAudioDevice.AUTOMATIC
                                          ? ListTile(
                                              horizontalTitleGap: 2,
                                              enabled: false,
                                              contentPadding: EdgeInsets.zero,
                                              leading: SvgPicture.asset(
                                                "packages/hms_room_kit/lib/src/assets/icons/${Utilities.getAudioDeviceIconName(data.item3)}.svg",
                                                fit: BoxFit.scaleDown,
                                                colorFilter: ColorFilter.mode(
                                                    HMSThemeColors
                                                        .onSurfaceHighEmphasis,
                                                    BlendMode.srcIn),
                                              ),
                                              title: HMSSubtitleText(
                                                fontSize: 14,
                                                lineHeight: 20,
                                                letterSpacing: 0.10,
                                                fontWeight: FontWeight.w600,
                                                text:
                                                    "${Utilities.getAudioDeviceName(data.item1[index])} (${Utilities.getAudioDeviceName(data.item3)})",
                                                textColor: HMSThemeColors
                                                    .onSurfaceHighEmphasis,
                                              ),
                                              trailing: context
                                                          .read<PreviewStore>()
                                                          .currentAudioDeviceMode ==
                                                      HMSAudioDevice.AUTOMATIC
                                                  ? SizedBox(
                                                      height: 24,
                                                      width: 24,
                                                      child: SvgPicture.asset(
                                                        "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                                        fit: BoxFit.scaleDown,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                HMSThemeColors
                                                                    .onSurfaceHighEmphasis,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                            )
                                          : ListTile(
                                              horizontalTitleGap: 2,
                                              enabled: false,
                                              contentPadding: EdgeInsets.zero,
                                              leading: SvgPicture.asset(
                                                "packages/hms_room_kit/lib/src/assets/icons/${Utilities.getAudioDeviceIconName(data.item1[index])}.svg",
                                                fit: BoxFit.scaleDown,
                                                colorFilter: ColorFilter.mode(
                                                    HMSThemeColors
                                                        .onSurfaceHighEmphasis,
                                                    BlendMode.srcIn),
                                              ),
                                              title: HMSSubtitleText(
                                                text: Utilities
                                                    .getAudioDeviceName(
                                                        data.item1[index]),
                                                fontSize: 14,
                                                lineHeight: 20,
                                                letterSpacing: 0.10,
                                                fontWeight: FontWeight.w600,
                                                textColor: HMSThemeColors
                                                    .onSurfaceHighEmphasis,
                                              ),
                                              trailing: data.item1[index] ==
                                                      context
                                                          .read<PreviewStore>()
                                                          .currentAudioDeviceMode
                                                  ? SizedBox(
                                                      height: 24,
                                                      width: 24,
                                                      child: SvgPicture.asset(
                                                        "packages/hms_room_kit/lib/src/assets/icons/tick.svg",
                                                        fit: BoxFit.scaleDown,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                                HMSThemeColors
                                                                    .onSurfaceHighEmphasis,
                                                                BlendMode
                                                                    .srcIn),
                                                      ),
                                                    )
                                                  : const SizedBox(
                                                      height: 24,
                                                      width: 24,
                                                    ),
                                            ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Divider(
                                          color: HMSThemeColors.borderDefault,
                                          height: 5,
                                        )),
                                  ],
                                );
                              }),
                        )
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
