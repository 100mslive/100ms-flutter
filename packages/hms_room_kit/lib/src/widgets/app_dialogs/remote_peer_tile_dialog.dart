//Package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/src/common/app_color.dart';
import 'package:hms_room_kit/src/common/constants.dart';

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
  final bool isSpotlightedPeer;
  final Function(bool, bool) changeVideoTrack;
  final Function(bool, bool) changeAudioTrack;
  final Function() removePeer;
  final Function() changeRole;
  final Function() changeLayer;
  final Function() changePinTileStatus;
  final Function() setOnSpotlight;
  const RemotePeerTileDialog(
      {super.key,
      required this.isVideoMuted,
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
      required this.setOnSpotlight,
      this.isSpotlightedPeer = false});

  @override
  RemotePeerTileDialogState createState() => RemotePeerTileDialogState();
}

class RemotePeerTileDialogState extends State<RemotePeerTileDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: themeBottomSheetColor,
      title: Text(
        widget.peerName,
        style: GoogleFonts.inter(color: iconColor, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((widget.isVideoMuted && widget.unMute) ||
                (!widget.isVideoMuted && widget.mute))
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changeVideoTrack(!widget.isVideoMuted, true);
                  },
                  child: Row(
                    children: [
                      if (widget.isVideoMuted)
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/assets/icons/cam_state_on.svg",
                          colorFilter:
                              ColorFilter.mode(iconColor, BlendMode.srcIn),
                        )
                      else
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/assets/icons/cam_state_off.svg",
                          colorFilter:
                              ColorFilter.mode(iconColor, BlendMode.srcIn),
                        ),
                      const SizedBox(
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
            const SizedBox(
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
                          "packages/hms_room_kit/lib/assets/icons/mic_state_on.svg",
                          colorFilter:
                              ColorFilter.mode(iconColor, BlendMode.srcIn),
                        )
                      else
                        SvgPicture.asset(
                          "packages/hms_room_kit/lib/assets/icons/mic_state_off.svg",
                          colorFilter:
                              ColorFilter.mode(iconColor, BlendMode.srcIn),
                        ),
                      const SizedBox(
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
            const SizedBox(
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
                        "packages/hms_room_kit/lib/assets/icons/peer_remove.svg",
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
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
                        "packages/hms_room_kit/lib/assets/icons/role_change.svg",
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
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
            if (Constant.debugMode)
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
                          "packages/hms_room_kit/lib/assets/icons/layers.svg",
                          colorFilter:
                              ColorFilter.mode(iconColor, BlendMode.srcIn),
                        ),
                        const SizedBox(
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
            if (Constant.debugMode)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    widget.changePinTileStatus();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "packages/hms_room_kit/lib/assets/icons/pin.svg",
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
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
                        "packages/hms_room_kit/lib/assets/icons/spotlight.svg",
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
