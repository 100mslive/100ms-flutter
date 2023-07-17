import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/preview/preview_store.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_dropdown.dart';
import 'package:hms_room_kit/widgets/common_widgets/subheading_text.dart';
import 'package:hms_room_kit/widgets/common_widgets/subtitle_text.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class PreviewDeviceSettings extends StatefulWidget {
  const PreviewDeviceSettings({
    Key? key,
  }) : super(key: key);
  @override
  State<PreviewDeviceSettings> createState() => _PreviewDeviceSettingsState();
}

class _PreviewDeviceSettingsState extends State<PreviewDeviceSettings> {
  GlobalKey? dropdownKey;

  void _updateDropDownValue(dynamic newValue) {
    if (newValue != null) {
      context.read<PreviewStore>().switchAudioOutput(audioDevice: newValue);
    }
    dropdownKey = null;
  }

  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 24, right: 24),
        child: Selector<PreviewStore,
                Tuple3<List<HMSAudioDevice>, int, HMSAudioDevice?>>(
            selector: (_, previewStore) => Tuple3(
                previewStore.availableAudioOutputDevices,
                previewStore.availableAudioOutputDevices.length,
                previewStore.currentAudioOutputDevice),
            builder: (context, data, _) {
              if (dropdownKey != null && dropdownKey!.currentWidget != null) {
                Navigator.pop(dropdownKey!.currentContext!);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Device Settings",
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: themeDefaultColor,
                            letterSpacing: 0.15,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/close_button.svg",
                          width: 40,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Divider(
                      color: dividerColor,
                      height: 5,
                    ),
                  ),
                  SubheadingText(
                    text: "Speakers",
                    textColor: onSurfaceHighEmphasis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Platform.isIOS
                      ? ListTile(
                          horizontalTitleGap: 2,
                          onTap: () {
                            Navigator.pop(context);
                            context
                                .read<PreviewStore>()
                                .switchAudioOutputUsingiOSUI();
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: SvgPicture.asset(
                            "assets/icons/music_wave.svg",
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                onSurfaceHighEmphasis, BlendMode.srcIn),
                          ),
                          title: SubtitleText(
                            text: "Switch Audio Output Device",
                            textColor: onSurfaceHighEmphasis,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          decoration: BoxDecoration(
                            color: themeSurfaceColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: borderColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: HMSDropDown(
                                  dropDownItems: <DropdownMenuItem>[
                                ...data.item1
                                    .sortedBy((element) => element.toString())
                                    .map((device) => DropdownMenuItem(
                                          key: UniqueKey(),
                                          value: device,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/music_wave.svg",
                                                colorFilter: ColorFilter.mode(
                                                    themeDefaultColor,
                                                    BlendMode.srcIn),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SubtitleText(
                                                text: device.name,
                                                textColor: themeDefaultColor,
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              ],
                                  buttonStyleData:
                                      const ButtonStyleData(height: 48),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 45,
                                  ),
                                  iconStyleData: IconStyleData(
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconEnabledColor: iconColor),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: themeSurfaceColor),
                                    offset: const Offset(-10, -10),
                                  ),
                                  selectedValue: Platform.isAndroid
                                      ? data.item3
                                      : data.item1[0],
                                  updateSelectedValue: _updateDropDownValue)),
                        ),
                ],
              );
            }),
      ),
    );
  }
}
