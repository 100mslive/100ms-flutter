import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/widgets/hms_dropdown.dart';
import 'package:hmssdk_flutter_example/common/widgets/subtitle_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class AudioSettingsBottomSheet extends StatefulWidget {
  AudioSettingsBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  State<AudioSettingsBottomSheet> createState() =>
      _AudioSettingsBottomSheetState();
}

class _AudioSettingsBottomSheetState extends State<AudioSettingsBottomSheet> {
  GlobalKey? dropdownKey;

  void _updateDropDownValue(dynamic newValue) {
    if (newValue != null) {
      Navigator.pop(context);
      context.read<MeetingStore>().switchAudioOutput(audioDevice: newValue);
      dropdownKey = null;
    }
  }

  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    MeetingStore _meetingStore = context.read<MeetingStore>();
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Selector<MeetingStore,
                Tuple3<List<HMSAudioDevice>, int, HMSAudioDevice?>>(
            selector: (_, meetingStore) => Tuple3(
                meetingStore.availableAudioOutputDevices,
                meetingStore.availableAudioOutputDevices.length,
                meetingStore.currentAudioOutputDevice),
            builder: (context, data, _) {
              if (dropdownKey != null && dropdownKey!.currentWidget != null) {
                Navigator.pop(dropdownKey!.currentContext!);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: borderColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: hmsWhiteColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Audio Settings",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              color: themeDefaultColor,
                              letterSpacing: 0.15,
                              fontWeight: FontWeight.w600),
                        ),
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
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Divider(
                      color: dividerColor,
                      height: 5,
                    ),
                  ),
                  Text("Speakers",
                      style: GoogleFonts.inter(
                          color: themeDefaultColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.25)),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 5),
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
                            dropdownKey: dropdownKey,
                            buttonStyleData: ButtonStyleData(
                              height: 48,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: themeSurfaceColor),
                              offset: Offset(-10, -10),
                            ),
                            dropDownItems: <DropdownMenuItem>[
                              ...data.item1
                                  .sortedBy((element) => element.toString())
                                  .map((device) => DropdownMenuItem(
                                        key: UniqueKey(),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/music_wave.svg",
                                              color: themeDefaultColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: SubtitleText(
                                                text: device.name,
                                                textColor: themeDefaultColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        value: device,
                                      ))
                                  .toList(),
                            ],
                            selectedValue: Platform.isAndroid
                                ? data.item3
                                : _meetingStore.currentAudioDeviceMode,
                            updateSelectedValue: _updateDropDownValue)),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
