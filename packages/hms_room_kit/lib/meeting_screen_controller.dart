import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/utility_components.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/hls_viewer/hls_viewer_page.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_page.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class MeetingScreenController extends StatefulWidget {
  final String meetingLink;
  final String user;
  final int? localPeerNetworkQuality;
  final bool isRoomMute;
  final bool showStats;
  final bool mirrorCamera;
  final HMSRole? role;
  final HMSConfig? config;
  const MeetingScreenController(
      {Key? key,
      required this.meetingLink,
      required this.user,
      required this.localPeerNetworkQuality,
      this.isRoomMute = false,
      this.showStats = false,
      this.mirrorCamera = true,
      this.role,
      this.config})
      : super(key: key);

  @override
  State<MeetingScreenController> createState() =>
      _MeetingScreenControllerState();
}

class _MeetingScreenControllerState extends State<MeetingScreenController> {
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
    if (ans != null && mounted) {
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
            HLSPlayerStore hlsPlayerStore = HLSPlayerStore();
            return ListenableProvider.value(
                value: hlsPlayerStore, child: const HLSViewerPage());
          }
          return MeetingPage(
            meetingLink: widget.meetingLink,
            isRoomMute: widget.isRoomMute,
          );
        },
        selector: (_, meetingStore) => meetingStore.localPeer?.role.name);
  }
}
