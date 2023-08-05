import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hms_prebuilt_options.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subtitle_text.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/widgets/hms_buttons/hms_back_button.dart';

class PreviewPermissions extends StatefulWidget {
  final String roomCode;
  final HMSPrebuiltOptions? options;
  final void Function() callback;

  const PreviewPermissions(
      {super.key,
      required this.roomCode,
      this.options,
      required this.callback});

  @override
  State<PreviewPermissions> createState() => _PreviewPermissionsState();
}

class _PreviewPermissionsState extends State<PreviewPermissions> {
  void _getPermissions() async {
    var res = await Utilities.getPermissions();

    if (res) {
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Positioned(
              top: Platform.isIOS ? 50 : 35,
              left: 10,
              child: HMSBackButton(onPressed: () => {Navigator.pop(context)})),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/permission_lock.svg",
                      fit: BoxFit.scaleDown,
                      semanticsLabel: "audio_mute_button",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HMSTitleText(
                      text: "Enable permissions",
                      textColor: onSurfaceHighEmphasis,
                      fontSize: 24,
                      lineHeight: 32,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    HMSSubtitleText(
                        text: "Just a few things before you join",
                        fontSize: 14,
                        lineHeight: 20,
                        textColor: onSurfaceLowEmphasis),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                  child: SizedBox(
                    width: size.width - 40,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _getPermissions();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(primaryDefault),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HMSTitleText(
                            text: "Grant Permissions",
                            textColor: onSurfaceHighEmphasis),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
