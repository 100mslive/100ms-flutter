//Package imports

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_text_style.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/constants.dart';

class LocalPeerTileDialog extends StatefulWidget {
  final String peerName;
  final bool isAudioMode;
  final bool roles;
  final bool isVideoOn;
  final Function() toggleCamera;
  final Function() changeName;
  final Function() changeRole;
  final Function()? toggleFlash;
  final Function() setOnSpotlight;
  final bool isSpotlightedPeer;
  const LocalPeerTileDialog(
      {super.key,
      required this.isAudioMode,
      this.isVideoOn = false,
      required this.toggleCamera,
      required this.peerName,
      required this.changeRole,
      required this.roles,
      required this.changeName,
      this.toggleFlash,
      required this.setOnSpotlight,
      this.isSpotlightedPeer = false});

  @override
  LocalPeerTileDialogState createState() => LocalPeerTileDialogState();
}

class LocalPeerTileDialogState extends State<LocalPeerTileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.peerName,
        style: HMSTextStyle.setTextStyle(
            color: iconColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: themeBottomSheetColor,
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                widget.changeName();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "packages/hms_room_kit/lib/src/assets/icons/pencil.svg",
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Change Name",
                      style: HMSTextStyle.setTextStyle(color: iconColor),
                    )
                  ],
                ),
              ),
            ),
            if (widget.roles)
              GestureDetector(
                onTap: () {
                  widget.changeRole();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/role_change.svg",
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Change Role",
                        style: HMSTextStyle.setTextStyle(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
            if (widget.isVideoOn && Constant.debugMode)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.toggleFlash!();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      const Icon(Icons.flashlight_on_outlined),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Toggle Flash",
                        style: HMSTextStyle.setTextStyle(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
            if (Constant.debugMode)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.setOnSpotlight();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hms_room_kit/lib/src/assets/icons/spotlight.svg",
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        widget.isSpotlightedPeer
                            ? "Remove From Spotlight"
                            : "Spotlight Tile",
                        style: HMSTextStyle.setTextStyle(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
