library;

///Dart imports
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/widgets/toasts/toast_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_left_room_screen.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_viewer_header.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_bottom_sheet.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_header.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_player_store.dart';
import 'package:hms_room_kit/src/hls_viewer/hls_waiting_ui.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[HLSViewerPage] is the page that is used to render the HLS Viewer
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
      ///We start the timer to hide the controls
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<HLSPlayerStore>().startTimerToHideButtons();
      });
    }
  }

  ///This function is used to set the stream status
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
      child: Selector<MeetingStore, Tuple4<bool, HMSException?, bool, bool>>(
          selector: (_, meetingStore) => Tuple4(
              meetingStore.isRoomEnded,
              meetingStore.hmsException,
              meetingStore.isRoomEnded,
              meetingStore.localPeer?.role.permissions.hlsStreaming ?? false),
          builder: (_, failureData, __) {
            if (failureData.item1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HMSLeftRoomScreen(
                          isEndRoomCalled: failureData.item3,
                          doesRoleHasStreamPermission: failureData.item4,
                        )));
              });
            }
            return Selector<MeetingStore, bool>(
                selector: (_, meetingStore) => meetingStore.isPipActive,
                builder: (_, isPipActive, __) {
                  return isPipActive
                      ? HMSHLSPlayer()
                      : Scaffold(
                          backgroundColor: HMSThemeColors.backgroundDim,
                          body: Theme(
                            data: ThemeData(
                                brightness: Brightness.dark,
                                primaryColor: HMSThemeColors.primaryDefault,
                                scaffoldBackgroundColor:
                                    HMSThemeColors.backgroundDim),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    Selector<MeetingStore, bool>(
                                        selector: (_, meetingStore) =>
                                            meetingStore.hasHlsStarted,
                                        builder: (_, hasHlsStarted, __) {
                                          _setStreamStatus(hasHlsStarted);
                                          return (hasHlsStarted)
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
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
                                                )
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
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Selector<HLSPlayerStore, bool>(
                                              selector: (_, hlsPlayerStore) =>
                                                  hlsPlayerStore
                                                      .areStreamControlsVisible,
                                              builder: (_,
                                                  areStreamControlsVisible,
                                                  __) {
                                                return AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  height:
                                                      areStreamControlsVisible
                                                          ? 100
                                                          : 0,
                                                  child: areStreamControlsVisible
                                                      ? const HLSViewerHeader()
                                                      : Container(),
                                                );
                                              }),
                                          const HLSViewerBottomNavigationBar()
                                        ],
                                      ),
                                    ),

                                    ///This renders the preview for role component
                                    Selector<
                                            MeetingStore,
                                            Tuple3<
                                                HMSLocalVideoTrack?,
                                                HMSLocalAudioTrack?,
                                                HMSRoleChangeRequest?>>(
                                        selector: (_, meetingStore) => Tuple3(
                                            meetingStore
                                                .previewForRoleVideoTrack,
                                            meetingStore
                                                .previewForRoleAudioTrack,
                                            meetingStore
                                                .currentRoleChangeRequest),
                                        builder: (_, previewForRoleTracks, __) {
                                          ///If the preview for role tracks are not null
                                          ///we show the preview for role component
                                          ///else we show and empty Container
                                          if (previewForRoleTracks.item1 != null ||
                                              previewForRoleTracks.item2 !=
                                                  null ||
                                              previewForRoleTracks.item3 !=
                                                  null) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                    (timeStamp) {
                                              ///For preview for role component we use the [showGeneralDialog]
                                              showGeneralDialog(
                                                  context: context,
                                                  pageBuilder: (ctx, _, __) {
                                                    return ListenableProvider
                                                        .value(
                                                      value: context
                                                          .read<MeetingStore>(),
                                                      child: Scaffold(
                                                        body: SafeArea(
                                                          child: Container(
                                                            color: HMSThemeColors
                                                                .backgroundDim,
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,

                                                            ///We render the preview for role component
                                                            child: Stack(
                                                              children: [
                                                                ///This renders the video component
                                                                ///[HMSVideoView] is only rendered if video is ON
                                                                ///
                                                                ///else we render the [HMSCircularAvatar]
                                                                Selector<
                                                                        MeetingStore,
                                                                        bool>(
                                                                    selector: (_,
                                                                            meetingStore) =>
                                                                        meetingStore
                                                                            .isVideoOn,
                                                                    builder: (_,
                                                                        isVideoOn,
                                                                        __) {
                                                                      return Container(
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .height,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        color: HMSThemeColors
                                                                            .backgroundDim,
                                                                        child: (isVideoOn &&
                                                                                previewForRoleTracks.item1 != null)
                                                                            ? Center(
                                                                                child: HMSVideoView(
                                                                                  scaleType: ScaleType.SCALE_ASPECT_FILL,
                                                                                  track: previewForRoleTracks.item1!,
                                                                                  setMirror: true,
                                                                                ),
                                                                              )
                                                                            : Center(
                                                                                child: HMSCircularAvatar(name: context.read<MeetingStore>().localPeer?.name ?? ""),
                                                                              ),
                                                                      );
                                                                    }),

                                                                ///This renders the preview for role header
                                                                const PreviewForRoleHeader(),

                                                                ///This renders the preview for role bottom sheet
                                                                PreviewForRoleBottomSheet(
                                                                  meetingStore:
                                                                      context.read<
                                                                          MeetingStore>(),
                                                                  roleChangeRequest: context
                                                                      .read<
                                                                          MeetingStore>()
                                                                      .currentRoleChangeRequest,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                          }
                                          return Container();
                                        }),

                                    Selector<MeetingStore,
                                            HMSTrackChangeRequest?>(
                                        selector: (_, meetingStore) =>
                                            meetingStore.hmsTrackChangeRequest,
                                        builder:
                                            (_, hmsTrackChangeRequest, __) {
                                          if (hmsTrackChangeRequest != null) {
                                            HMSTrackChangeRequest
                                                currentRequest =
                                                hmsTrackChangeRequest;
                                            context
                                                .read<MeetingStore>()
                                                .hmsTrackChangeRequest = null;
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              UtilityComponents
                                                  .showTrackChangeDialog(
                                                      context, currentRequest);
                                            });
                                          }
                                          return const SizedBox();
                                        }),
                                    Selector<MeetingStore, bool>(
                                        selector: (_, meetingStore) =>
                                            meetingStore
                                                .showAudioDeviceChangePopup,
                                        builder: (_, showAudioDeviceChangePopup,
                                            __) {
                                          if (showAudioDeviceChangePopup) {
                                            context
                                                    .read<MeetingStore>()
                                                    .showAudioDeviceChangePopup =
                                                false;
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      AudioDeviceChangeDialog(
                                                        currentAudioDevice: context
                                                            .read<
                                                                MeetingStore>()
                                                            .currentAudioOutputDevice!,
                                                        audioDevicesList: context
                                                            .read<
                                                                MeetingStore>()
                                                            .availableAudioOutputDevices,
                                                        changeAudioDevice:
                                                            (audioDevice) {
                                                          context
                                                              .read<
                                                                  MeetingStore>()
                                                              .switchAudioOutput(
                                                                  audioDevice:
                                                                      audioDevice);
                                                        },
                                                      ));
                                            });
                                          }
                                          return const SizedBox();
                                        }),
                                    Selector<MeetingStore,
                                            Tuple2<List<HMSToastModel>, int>>(
                                        selector: (_, meetingStore) => Tuple2(
                                            meetingStore.toasts,
                                            meetingStore.toasts.length),
                                        builder: (_, toastsItem, __) {
                                          if (toastsItem.item1.isEmpty) {
                                            return Container();
                                          }
                                          return Stack(
                                              children: toastsItem.item1
                                                  .sublist(0,
                                                      min(3, toastsItem.item2))
                                                  .asMap()
                                                  .entries
                                                  .map((toasts) {
                                            var meetingStore =
                                                context.read<MeetingStore>();
                                            return Selector<HLSPlayerStore,
                                                    bool>(
                                                selector: (_, hlsPlayerStore) =>
                                                    hlsPlayerStore
                                                        .areStreamControlsVisible,
                                                builder: (_,
                                                    areStreamControlsVisible,
                                                    __) {
                                                  return AnimatedPositioned(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    bottom:
                                                        (areStreamControlsVisible
                                                                ? 28.0
                                                                : 10.0) +
                                                            8 * toasts.key,
                                                    left: 5,
                                                    child: ToastWidget(
                                                        toast: toasts.value,
                                                        index: toasts.key,
                                                        toastsCount:
                                                            toastsItem.item2,
                                                        meetingStore:
                                                            meetingStore),
                                                  );
                                                });
                                          }).toList());
                                        }),

                                    Selector<MeetingStore, bool>(
                                        selector: (_, meetingStore) =>
                                            meetingStore.reconnecting,
                                        builder: (_, reconnecting, __) {
                                          if (reconnecting) {
                                            return UtilityComponents
                                                .showReconnectingDialog(
                                                    context);
                                          }
                                          return const SizedBox();
                                        }),
                                    if (failureData.item2 != null &&
                                        (failureData.item2?.code?.errorCode ==
                                                1003 ||
                                            failureData
                                                    .item2?.code?.errorCode ==
                                                2000 ||
                                            failureData
                                                    .item2?.code?.errorCode ==
                                                4005))
                                      UtilityComponents.showFailureError(
                                          failureData.item2!,
                                          context,
                                          () => context
                                              .read<MeetingStore>()
                                              .leave())
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                });
          }),
    );
  }
}
