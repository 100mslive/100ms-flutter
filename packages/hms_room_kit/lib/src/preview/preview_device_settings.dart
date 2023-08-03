import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

///[PreviewDeviceSettings] is a widget that shows the list of available audio output devices
///and allows the user to select one of them
///
///By default Automatic is selected which means the audio output device will be the same as the
///system's audio output device
///
///Please note that this is only for android
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
        maxChildSize: 0.8,
        minChildSize: 0.3,
        initialChildSize: 0.3,
        builder: (context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backgroundDefault,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 24, right: 24),
              child: Selector<PreviewStore,
                      Tuple3<List<HMSAudioDevice>, int, HMSAudioDevice?>>(
                  selector: (_, previewStore) => Tuple3(
                      previewStore.availableAudioOutputDevices,
                      previewStore.availableAudioOutputDevices.length,
                      previewStore.currentAudioOutputDevice),
                  builder: (context, data, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Audio Output",
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: themeDefaultColor,
                                  letterSpacing: 0.15,
                                  fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: onSurfaceHighEmphasis,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Divider(
                            color: borderDefault,
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
                                                    onSurfaceHighEmphasis,
                                                    BlendMode.srcIn),
                                              ),
                                              title: HMSSubtitleText(
                                                fontSize: 14,
                                                lineHeight: 20,
                                                letterSpacing: 0.10,
                                                fontWeight: FontWeight.w600,
                                                text:
                                                    "${Utilities.getAudioDeviceName(data.item1[index])} (${Utilities.getAudioDeviceName(data.item3)})",
                                                textColor: themeDefaultColor,
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
                                                                onSurfaceHighEmphasis,
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
                                                    onSurfaceHighEmphasis,
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
                                                textColor: themeDefaultColor,
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
                                                                onSurfaceHighEmphasis,
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
                                          color: borderDefault,
                                          height: 5,
                                        )),
                                  ],
                                );
                              }),
                        )
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
