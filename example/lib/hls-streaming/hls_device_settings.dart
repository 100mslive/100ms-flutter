import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_subtitle_text.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

class HLSDeviceSettings extends StatefulWidget {
  final List<HMSAudioDevice> audioDeviceList;
  final HMSAudioDevice currentAudioDevice;
  HLSDeviceSettings(
      {Key? key,
      required this.audioDeviceList,
      required this.currentAudioDevice})
      : super(key: key);
  @override
  State<HLSDeviceSettings> createState() => _HLSDeviceSettingsState();
}

class _HLSDeviceSettingsState extends State<HLSDeviceSettings> {
  String? valueChoose;

  @override
  void initState() {
    super.initState();
    valueChoose = widget.currentAudioDevice.name;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
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
                      color: defaultColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Text(
                    "Device Settings",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        color: defaultColor,
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
                    color: defaultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25)),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 5),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: borderColor, style: BorderStyle.solid, width: 0.80),
              ),
              child: DropdownButtonHideUnderline(
                child: Selector<MeetingStore,
                        Tuple2<List<HMSRole>, List<HMSPeer>>>(
                    selector: (_, meetingStore) =>
                        Tuple2(meetingStore.roles, meetingStore.peers),
                    builder: (context, data, _) {
                      return DropdownButton2(
                        isExpanded: true,
                        buttonHeight: 48,
                        itemHeight: 45,
                        selectedItemHighlightColor: hmsdefaultColor,
                        value: valueChoose,
                        icon: Icon(Icons.keyboard_arrow_down),
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: surfaceColor),
                        offset: Offset(-10, -10),
                        iconEnabledColor: iconColor,
                        onChanged: (dynamic newvalue) {
                          context.read<MeetingStore>().switchAudioOutput(
                              HMSAudioDeviceValues.getHMSAudioDeviceFromName(
                                  newvalue));
                          setState(() {
                            this.valueChoose = newvalue as String;
                          });
                        },
                        items: <DropdownMenuItem>[
                          ...widget.audioDeviceList
                              .sortedBy((element) => element.toString())
                              .map((device) => DropdownMenuItem(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/music_wave.svg"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          child: HLSSubtitleText(
                                            text: device.name,
                                            textColor: defaultColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: device.name,
                                  ))
                              .toList(),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
