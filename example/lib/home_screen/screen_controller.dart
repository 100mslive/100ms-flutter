import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
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
  final HMSRole? role;
  final HMSConfig? config;
  const ScreenController(
      {Key? key,
      required this.meetingLink,
      required this.user,
      required this.localPeerNetworkQuality,
      this.isStreamingLink = false,
      this.isRoomMute = false,
      this.showStats = false,
      this.mirrorCamera = true,
      this.role,
      this.config})
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
    Utilities.initForegroundTask();
  }

  void initMeeting() async {
    HMSException? ans = await context
        .read<MeetingStore>()
        .join(widget.user, widget.meetingLink, roomConfig: widget.config);
    if (ans != null) {
      UtilityComponents.showErrorDialog(
          context: context,
          errorMessage: "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
          errorTitle: ans.message ?? "Join Error",
          actionMessage: "OK",
          action: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
    }
  }

  void setInitValues() async {
    context.read<MeetingStore>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
        builder: (_, data, __) {
          if (data?.contains("hls-") ?? false) {
            return HLSViewerPage();
          }
          return MeetingPage(
            isStreamingLink: widget.isStreamingLink,
            meetingLink: widget.meetingLink,
            isRoomMute: widget.isRoomMute,
          );
        },
        selector: (_, meetingStore) => meetingStore.localPeer?.role.name);
  }
}
