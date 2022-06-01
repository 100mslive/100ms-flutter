//Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class ChangeTrackOptionDialog extends StatefulWidget {
  final String peerName;
  final isVideoMuted;
  final isAudioMuted;
  final Function(bool, bool) changeVideoTrack;
  final Function(bool, bool) changeAudioTrack;
  final Function() removePeer;
  final mute;
  final unMute;
  final removeOthers;
  const ChangeTrackOptionDialog(
      {required this.isVideoMuted,
      required this.isAudioMuted,
      required this.changeVideoTrack,
      required this.changeAudioTrack,
      required this.peerName,
      required this.removePeer,
      required this.mute,
      required this.unMute,
      required this.removeOthers});

  @override
  _ChangeTrackOptionDialogState createState() =>
      _ChangeTrackOptionDialogState();
}

class _ChangeTrackOptionDialogState extends State<ChangeTrackOptionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        
        widget.peerName,
        style: GoogleFonts.inter(color:iconColor),
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
                      Icon(widget.isVideoMuted
                          ? Icons.videocam
                          : Icons.videocam_off),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.isVideoMuted ? "Unmute" : "Mute"} video",
                        style: GoogleFonts.inter(color:iconColor),
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
                      Icon(widget.isAudioMuted
                          ? Icons.mic_sharp
                          : Icons.mic_off),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "${widget.isAudioMuted ? "Unmute" : "Mute"} audio",
                        style: GoogleFonts.inter(color:iconColor),
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
                      Icon(Icons.highlight_remove_outlined),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "Remove Peer",
                        style: GoogleFonts.inter(color:iconColor),
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
