//Package imports

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_uikit/common/app_color.dart';

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
      {super.key, required this.isAudioMode,
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
  _LocalPeerTileDialogState createState() => _LocalPeerTileDialogState();
}

class _LocalPeerTileDialogState extends State<LocalPeerTileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.peerName,
        style: GoogleFonts.inter(color: iconColor, fontWeight: FontWeight.bold),
      ),
      backgroundColor: themeBottomSheetColor,
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isAudioMode && widget.isVideoOn)
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.toggleCamera();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hmssdk_uikit/lib/assets/icons/camera.svg",
                        color: iconColor,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Toggle Camera",
                        style: GoogleFonts.inter(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
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
                      "packages/hmssdk_uikit/lib/assets/icons/pencil.svg",
                      color: iconColor,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Change Name",
                      style: GoogleFonts.inter(color: iconColor),
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
                        "packages/hmssdk_uikit/lib/assets/icons/role_change.svg",
                        color: iconColor,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Change Role",
                        style: GoogleFonts.inter(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
            if (widget.isVideoOn)
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
                        style: GoogleFonts.inter(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
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
                      "packages/hmssdk_uikit/lib/assets/icons/spotlight.svg",
                      color: iconColor,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      widget.isSpotlightedPeer
                          ? "Remove From Spotlight"
                          : "Spotlight Tile",
                      style: GoogleFonts.inter(color: iconColor),
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
