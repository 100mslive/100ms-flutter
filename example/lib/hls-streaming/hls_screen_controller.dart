import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_broadcaster_page.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_viewer_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSScreenController extends StatefulWidget {
  final String meetingLink;
  final String user;
  final bool isAudioOn;
  final int? localPeerNetworkQuality;
  const HLSScreenController(
      {Key? key,
      required this.meetingLink,
      required this.user,
      required this.isAudioOn,
      required this.localPeerNetworkQuality})
      : super(key: key);

  @override
  State<HLSScreenController> createState() => _HLSScreenControllerState();
}

class _HLSScreenControllerState extends State<HLSScreenController> {
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
    if (Provider.of<MeetingStore>(context).localPeer != null &&
        Provider.of<MeetingStore>(context)
            .localPeer!
            .role
            .name
            .contains("hls-")) {
      return HLSViewerPage();
    } else {
      return HLSBroadcasterPage(
        meetingLink: widget.meetingLink,
        isAudioOn: widget.isAudioOn,
      );
    }
  }
}
