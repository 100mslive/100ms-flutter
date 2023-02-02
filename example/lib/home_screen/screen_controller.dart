import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hls_viewer/hls_viewer_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:provider/provider.dart';

class ScreenController extends StatefulWidget {
  final String meetingLink;
  final String user;
  final int? localPeerNetworkQuality;
  final bool isStreamingLink;
  final bool isRoomMute;
  final bool showStats;
  final bool mirrorCamera;
  final String? streamUrl;
  final HMSRole? role;
  const ScreenController(
      {Key? key,
      required this.meetingLink,
      required this.user,
      required this.localPeerNetworkQuality,
      this.isStreamingLink = false,
      this.isRoomMute = false,
      this.showStats = false,
      this.mirrorCamera = true,
      this.streamUrl,
      this.role})
      : super(key: key);

  @override
  State<ScreenController> createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  @override
  void initState() {
    super.initState();
    initMeeting();
    setInitValues();
  }

  void initMeeting() async {
    bool ans = await context
        .read<MeetingStore>()
        .join(widget.user, widget.meetingLink);
    if (!ans) {
      Utilities.showToast("Unable to Join");
      Navigator.of(context).pop();
    }
  }

  void setInitValues() async {
    context.read<MeetingStore>().localPeerNetworkQuality =
        widget.localPeerNetworkQuality;
    context.read<MeetingStore>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    if ((Provider.of<MeetingStore>(context).localPeer != null &&
            Provider.of<MeetingStore>(context)
                .localPeer!
                .role
                .name
                .contains("hls-")) ||
        ((widget.role?.name.contains("hls-") ?? false) &&
            widget.streamUrl != null)) {
      return HLSViewerPage(
        streamUrl: widget.streamUrl,
      );
    } else {
      return MeetingPage(
        isStreamingLink: widget.isStreamingLink,
        meetingLink: widget.meetingLink,
        isRoomMute: widget.isRoomMute,
      );
    }
  }
}
