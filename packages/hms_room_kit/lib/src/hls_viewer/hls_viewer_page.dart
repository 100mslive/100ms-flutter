import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_waiting_ui.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HLSViewerPage extends StatefulWidget {
  const HLSViewerPage({
    Key? key,
  }) : super(key: key);
  @override
  State<HLSViewerPage> createState() => _HLSViewerPageState();
}

class _HLSViewerPageState extends State<HLSViewerPage> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HLSPlayerStore>().startTimerToHideButtons();
      });
    }
  }

  void _setStreamStatus(bool hasHlsStarted) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HLSPlayerStore>().setStreamPlaying(hasHlsStarted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool ans = await UtilityComponents.onBackPressed(context) ?? false;
        return ans;
      },
      child: Selector<MeetingStore, Tuple2<bool, HMSException?>>(
          selector: (_, meetingStore) =>
              Tuple2(meetingStore.isRoomEnded, meetingStore.hmsException),
          builder: (_, data, __) {
            if (data.item2 != null &&
                (data.item2?.code?.errorCode == 1003 ||
                    data.item2?.code?.errorCode == 2000 ||
                    data.item2?.code?.errorCode == 4005)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                UtilityComponents.showErrorDialog(
                    context: context,
                    errorMessage:
                        "Error Code: ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description}",
                    errorTitle: data.item2!.message ?? "",
                    actionMessage: "Leave Room",
                    action: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    });
              });
            }
            if (data.item1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Utilities.showToast(context.read<MeetingStore>().description);
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
            return Selector<MeetingStore, bool>(
                selector: (_, meetingStore) => meetingStore.isPipActive,
                builder: (_, isPipActive, __) {
                  return isPipActive
                      ? HMSHLSPlayer()
                      : Scaffold(
                          body: Theme(
                            data: ThemeData(
                                brightness: Brightness.dark,
                                primaryColor: HMSThemeColors.primaryDefault,
                                scaffoldBackgroundColor:
                                    HMSThemeColors.backgroundDefault),
                            child: SingleChildScrollView(
                              child: Stack(
                                children: [
                                  Selector<MeetingStore, bool>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.hasHlsStarted,
                                      builder: (_, hasHlsStarted, __) {
                                        _setStreamStatus(hasHlsStarted);
                                        return (hasHlsStarted)
                                            ? Selector<HLSPlayerStore, bool>(
                                                selector: (_, hlsPlayerStore) =>
                                                    hlsPlayerStore
                                                        .areStreamControlsVisible,
                                                builder: (_,
                                                    areStreamControlsVisible,
                                                    __) {
                                                  return SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: HLSPlayer(
                                                      key: Key(context
                                                              .read<
                                                                  MeetingStore>()
                                                              .localPeer
                                                              ?.peerId ??
                                                          "HLS_PLAYER"),
                                                      ratio: Utilities
                                                          .getHLSPlayerDefaultRatio(
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size),
                                                    ),
                                                  );
                                                })
                                            : SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: const HLSWaitingUI());
                                      }),

                                  ///Will only be displayed when the controls are visible
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Selector<HLSPlayerStore, bool>(
                                            selector: (_, hlsPlayerStore) =>
                                                hlsPlayerStore
                                                    .areStreamControlsVisible,
                                            builder: (_,
                                                areStreamControlsVisible, __) {
                                              return areStreamControlsVisible
                                                  ? const HLSViewerHeader()
                                                  : Container();
                                            }),
                                        const HLSViewerBottomNavigationBar()
                                      ],
                                    ),
                                  ),

                                  Selector<MeetingStore, HMSRoleChangeRequest?>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.currentRoleChangeRequest,
                                      builder: (_, roleChangeRequest, __) {
                                        if (roleChangeRequest != null) {
                                          HMSRoleChangeRequest currentRequest =
                                              roleChangeRequest;
                                          context
                                              .read<MeetingStore>()
                                              .currentRoleChangeRequest = null;
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            UtilityComponents
                                                .showRoleChangeDialog(
                                                    currentRequest, context);
                                          });
                                        }
                                        return const SizedBox();
                                      }),
                                  Selector<MeetingStore, bool>(
                                      selector: (_, meetingStore) =>
                                          meetingStore.reconnecting,
                                      builder: (_, reconnecting, __) {
                                        if (reconnecting) {
                                          return UtilityComponents
                                              .showReconnectingDialog(context);
                                        }
                                        return const SizedBox();
                                      }),
                                ],
                              ),
                            ),
                          ),
                        );
                });
          }),
    );
  }
}
