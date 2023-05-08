//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class RemotePeerTileDialog extends StatefulWidget {
  final String peerName;
  final bool isVideoMuted;
  final bool isAudioMuted;
  final bool mute;
  final bool unMute;
  final bool removeOthers;
  final bool roles;
  final bool simulcast;
  final bool pinTile;
  final bool? isCaptureSnapshot;
  final bool isSpotlightedPeer;
  final Function(bool, bool) changeVideoTrack;
  final Function(bool, bool) changeAudioTrack;
  final Function() removePeer;
  final Function() changeRole;
  final Function() changeLayer;
  final Function() changePinTileStatus;
  final Function()? captureSnapshot;
  final Function() setOnSpotlight;
  const RemotePeerTileDialog(
      {required this.isVideoMuted,
      required this.isAudioMuted,
      required this.changeVideoTrack,
      required this.changeAudioTrack,
      required this.peerName,
      required this.removePeer,
      required this.changeRole,
      required this.mute,
      required this.unMute,
      required this.removeOthers,
      required this.roles,
      required this.simulcast,
      required this.changeLayer,
      required this.pinTile,
      required this.changePinTileStatus,
      this.isCaptureSnapshot,
      this.captureSnapshot,
      required this.setOnSpotlight,
      this.isSpotlightedPeer = false});

  @override
  _RemotePeerTileDialogState createState() => _RemotePeerTileDialogState();
}

class _RemotePeerTileDialogState extends State<RemotePeerTileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: themeBottomSheetColor,
      title: Text(
        widget.peerName,
        style: GoogleFonts.inter(color: iconColor, fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((widget.isVideoMuted && widget.unMute) ||
                (!widget.isVideoMuted && widget.mute))
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changeVideoTrack(!widget.isVideoMuted, true);
                  },
                  child: Row(
                    children: [
                      if (widget.isVideoMuted)
                        SvgPicture.asset(
                          "assets/icons/cam_state_on.svg",
                          color: iconColor,
                        )
                      else
                        SvgPicture.asset(
                          "assets/icons/cam_state_off.svg",
                          color: iconColor,
                        ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.isVideoMuted ? "Unmute" : "Mute"} video",
                        style: GoogleFonts.inter(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(
              width: 20,
            ),
            if ((widget.isAudioMuted && widget.unMute) ||
                (!widget.isAudioMuted && widget.mute))
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changeAudioTrack(!widget.isAudioMuted, false);
                  },
                  child: Row(
                    children: [
                      if (widget.isAudioMuted)
                        SvgPicture.asset(
                          "assets/icons/mic_state_on.svg",
                          color: iconColor,
                        )
                      else
                        SvgPicture.asset(
                          "assets/icons/mic_state_off.svg",
                          color: iconColor,
                        ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.isAudioMuted ? "Unmute" : "Mute"} audio",
                        style: GoogleFonts.inter(color: iconColor),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              width: 20,
            ),
            if (widget.removeOthers)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.removePeer();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/peer_remove.svg",
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Remove Peer",
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
            if (widget.simulcast)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changeLayer();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/layers.svg",
                        color: iconColor,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Streaming Quality",
                        style: GoogleFonts.inter(color: iconColor),
                      )
                    ],
                  ),
                ),
              ),
            if (widget.isCaptureSnapshot != null && widget.isCaptureSnapshot!)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.captureSnapshot!();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Capture Snapshot",
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
                  widget.changePinTileStatus();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/pin.svg",
                      color: iconColor,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      widget.pinTile ? "Unpin Tile" : "Pin Tile",
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
                      "assets/icons/spotlight.svg",
                      color: iconColor,
                    ),
                    SizedBox(
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
