//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class LocalPeerTileDialog extends StatefulWidget {
  final String peerName;
  final bool isAudioMode;
  final bool roles;
  final Function() toggleCamera;
  final Function() changeName;
  final Function() changeRole;
  const LocalPeerTileDialog({
    required this.isAudioMode,
    required this.toggleCamera,
    required this.peerName,
    required this.changeRole,
    required this.roles,
    required this.changeName,
  });

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
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!widget.isAudioMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    widget.toggleCamera();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/camera.svg",
                        color: iconColor,
                      ),
                      SizedBox(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  widget.changeName();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/pencil.svg",
                      color: iconColor,
                    ),
                    SizedBox(
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changeRole();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/role_change.svg",
                        color: iconColor,
                      ),
                      SizedBox(
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
          ],
        ),
      ),
    );
  }
}
