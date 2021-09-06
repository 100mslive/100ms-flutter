import 'package:flutter/material.dart';

class ChangeTrackOptionDialog extends StatefulWidget {
  final String peerName;
  final isVideoMuted;
  final isAudioMuted;
  final Function(bool, bool) changeTrack;
  final Function() removePeer;
  const ChangeTrackOptionDialog({
    required this.isVideoMuted,
    required this.isAudioMuted,
    required this.changeTrack,
    required this.peerName,
    required this.removePeer
  });

  @override
  _ChangeTrackOptionDialogState createState() =>
      _ChangeTrackOptionDialogState();
}

class _ChangeTrackOptionDialogState extends State<ChangeTrackOptionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.peerName),
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  widget.changeTrack(!widget.isVideoMuted, true);
                },
                child: Row(
                  children: [
                    Icon(widget.isVideoMuted
                        ? Icons.videocam
                        : Icons.videocam_off),
                    SizedBox(
                      width: 16,
                    ),
                    Text("${widget.isVideoMuted ? "Unmute" : "Mute"} video")
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            
            GestureDetector(
              onTap: () {
                widget.changeTrack(!widget.isAudioMuted, false);
              },
              child: Row(
                children: [
                  Icon(widget.isAudioMuted ? Icons.mic_sharp : Icons.mic_off),
                  SizedBox(
                    width: 16,
                  ),
                  Text("${widget.isAudioMuted ? "Unmute" : "Mute"} audio")
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                widget.removePeer();
              },
              child: Row(
                children: [
                  Icon(Icons.highlight_remove_outlined),
                  SizedBox(
                    width: 16,
                  ),
                  Text("Remove Peer")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
