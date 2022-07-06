import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_broadcaster_page.dart';
import 'package:hmssdk_flutter_example/hls-streaming/hls_viewer_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSScreenController extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (Provider.of<MeetingStore>(context).localPeer != null &&
        Provider.of<MeetingStore>(context)
            .localPeer!
            .role
            .name
            .contains("hls")) {
      return HLSViewerPage(
          meetingLink: meetingLink,
          user: user,
          localPeerNetworkQuality: localPeerNetworkQuality);
    } else {
      return HLSBroadcasterPage(
          meetingLink: meetingLink,
          user: user,
          isAudioOn: isAudioOn,
          localPeerNetworkQuality: localPeerNetworkQuality);
    }
  }
}
