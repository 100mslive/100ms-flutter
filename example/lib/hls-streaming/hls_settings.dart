import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_device_settings.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSSettings extends StatefulWidget {
  @override
  State<HLSSettings> createState() => _HLSSettingsState();
}

class _HLSSettingsState extends State<HLSSettings> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "More Options",
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: defaultColor,
                            letterSpacing: 0.15,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Divider(
                  color: dividerColor,
                  height: 5,
                ),
              ),
              if (Platform.isAndroid)
                ListTile(
                  horizontalTitleGap: 2,
                  onTap: () async {
                    Navigator.pop(context);
                    List<HMSAudioDevice> audioDeviceList = await context
                        .read<MeetingStore>()
                        .getAudioDevicesList();
                    HMSAudioDevice currentAudioDevice = await context
                        .read<MeetingStore>()
                        .getCurrentAudioDevice();
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: bottomSheetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      context: context,
                      builder: (ctx) => ChangeNotifierProvider.value(
                          value: context.read<MeetingStore>(),
                          child: HLSDeviceSettings(
                            audioDeviceList: audioDeviceList,
                            currentAudioDevice: currentAudioDevice,
                          )),
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    "assets/icons/settings.svg",
                    fit: BoxFit.scaleDown,
                  ),
                  title: Text(
                    "Device Settings",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: defaultColor,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ListTile(
                horizontalTitleGap: 2,
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  String name = await UtilityComponents.showNameChangeDialog(
                      context: context,
                      placeholder: "Enter Name",
                      prefilledValue:
                          context.read<MeetingStore>().localPeer?.name ?? "");
                  if (name.isNotEmpty) {
                    context.read<MeetingStore>().changeName(name: name);
                  }
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  "assets/icons/pencil.svg",
                  fit: BoxFit.scaleDown,
                ),
                title: Text(
                  "Change Name",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: defaultColor,
                      letterSpacing: 0.25,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                horizontalTitleGap: 2,
                onTap: () {
                  Navigator.pop(context);
                  context.read<MeetingStore>().toggleSpeaker();
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  "assets/icons/speaker_state_on.svg",
                  fit: BoxFit.scaleDown,
                ),
                title: Text(
                  "Change Speaker State",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: defaultColor,
                      letterSpacing: 0.25,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ListTile(
                horizontalTitleGap: 2,
                onTap: () {
                  context.read<MeetingStore>().switchCamera();
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(
                  "assets/icons/camera.svg",
                  fit: BoxFit.scaleDown,
                ),
                title: Text(
                  "Switch Camera",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: defaultColor,
                      letterSpacing: 0.25,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
