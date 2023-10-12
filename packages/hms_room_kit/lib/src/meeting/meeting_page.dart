//Dart imports
import 'dart:io';
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/common/utility_functions.dart';
import 'package:hms_room_kit/src/layout_api/hms_theme_colors.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_title_text.dart';
import 'package:hms_room_kit/src/meeting/meeting_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/meeting/meeting_header.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_bring_on_stage_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_local_screen_share_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_role_change_decline_toast.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/enums/meeting_mode.dart';
import 'package:hms_room_kit/src/model/peer_track_node.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/one_to_one_mode.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/meeting/pip_view.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_bottom_sheet.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_header.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_left_room_screen.dart';
import 'package:hms_room_kit/src/widgets/meeting_modes/custom_one_to_one_grid.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_recording_error_toast.dart';

///[MeetingPage] is the main page of the meeting
///It takes the following parameters:
///[meetingLink] is the link of the meeting
///[isRoomMute] is the flag to mute the room
class MeetingPage extends StatefulWidget {
  final String meetingLink;
  final bool isRoomMute;
  const MeetingPage(
      {Key? key, required this.meetingLink, this.isRoomMute = true})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  void initState() {
    super.initState();
    checkAudioState();
    _enableForegroundService();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
  }

  void _enableForegroundService() {
    context.read<MeetingStore>().initForegroundTask();
  }

  ///This method returns the toast according to the type of toast
  Widget getToast(HMSToastModel toast, int index, int toastsCount) {
    switch (toast.hmsToastType) {
      case HMSToastsType.roleChangeToast:
        return HMSBringOnStageToast(
          toastColor: Utilities.getToastColor(index, toastsCount),
          peer: toast.toastData,
          meetingStore: context.read<MeetingStore>(),
        );
      case HMSToastsType.errorToast:
        return HMSRecordingErrorToast(
            recordingError: toast.toastData,
            meetingStore: context.read<MeetingStore>());
      case HMSToastsType.localScreenshareToast:
        return HMSLocalScreenShareToast(
          toastColor: Utilities.getToastColor(index, toastsCount),
          meetingStore: context.read<MeetingStore>(),
        );

      case HMSToastsType.roleChangeDeclineToast:
        return HMSRoleChangeDeclineToast(
          peer: toast.toastData,
          toastColor: Utilities.getToastColor(index, toastsCount),
          meetingStore: context.read<MeetingStore>(),
        );
    }
  }

  ///This method returns the scale of the toast according to the index and the total number of toasts
  double _getToastScale(int index, int toastsCount) {
    if (toastsCount == 1) {
      return 1;
    } else if (toastsCount == 2) {
      if (index == 0) {
        return 0.95;
      }
      return 1;
    } else {
      if (index == 0) {
        return 0.90;
      } else if (index == 1) {
        return 0.95;
      }
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool ans = await UtilityComponents.onBackPressed(context) ?? false;
          return ans;
        },
        child: WithForegroundTask(
          child: Selector<MeetingStore,
                  Tuple4<bool, HMSException?, bool, bool>>(
              selector: (_, meetingStore) => Tuple4(
                  meetingStore.isRoomEnded,
                  meetingStore.hmsException,
                  meetingStore.isEndRoomCalled,
                  meetingStore.localPeer?.role.permissions.hlsStreaming ??
                      false),
              builder: (_, failureErrors, __) {
                if (failureErrors.item1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HMSLeftRoomScreen(
                              isEndRoomCalled: failureErrors.item3,
                              doesRoleHasStreamPermission: failureErrors.item4,
                            )));
                  });
                }
                return Selector<MeetingStore, bool>(
                    selector: (_, meetingStore) => meetingStore.isPipActive,
                    builder: (_, isPipActive, __) {
                      return isPipActive && Platform.isAndroid
                          ? const PipView()
                          : Scaffold(
                              backgroundColor: HMSThemeColors.backgroundDim,
                              resizeToAvoidBottomInset: false,
                              body: SafeArea(
                                child: Theme(
                                  data: ThemeData(
                                      brightness: Brightness.dark,
                                      primaryColor:
                                          HMSThemeColors.primaryDefault,
                                      scaffoldBackgroundColor:
                                          HMSThemeColors.backgroundDim),
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context)
                                              .size
                                              .height -
                                          MediaQuery.of(context).padding.top -
                                          MediaQuery.of(context).padding.bottom,
                                      child: Stack(
                                        children: [
                                          Selector<
                                                  MeetingStore,
                                                  Tuple6<
                                                      List<PeerTrackNode>,
                                                      bool,
                                                      int,
                                                      int,
                                                      MeetingMode,
                                                      PeerTrackNode?>>(
                                              selector: (_, meetingStore) => Tuple6(
                                                  meetingStore.peerTracks,
                                                  meetingStore.isHLSLink,
                                                  meetingStore
                                                      .peerTracks.length,
                                                  meetingStore.screenShareCount,
                                                  meetingStore.meetingMode,
                                                  meetingStore
                                                          .peerTracks.isNotEmpty
                                                      ? meetingStore.peerTracks[
                                                          meetingStore
                                                              .screenShareCount]
                                                      : null),
                                              builder: (_, data, __) {
                                                if (data.item3 == 0) {
                                                  return Center(
                                                      child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: HMSThemeColors
                                                            .primaryDefault,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      if (context
                                                          .read<MeetingStore>()
                                                          .peers
                                                          .isNotEmpty)
                                                        HMSTitleText(
                                                            text:
                                                                "Please wait for broadcaster to join",
                                                            textColor:
                                                                HMSThemeColors
                                                                    .onSurfaceHighEmphasis)
                                                    ],
                                                  ));
                                                }
                                                return Selector<
                                                        MeetingStore,
                                                        Tuple2<MeetingMode,
                                                            HMSPeer?>>(
                                                    selector: (_,
                                                            meetingStore) =>
                                                        Tuple2(
                                                            meetingStore
                                                                .meetingMode,
                                                            meetingStore
                                                                .localPeer),
                                                    builder: (_, modeData, __) {
                                                      Size size = Size(
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height -
                                                              122 -
                                                              MediaQuery.of(
                                                                      context)
                                                                  .padding
                                                                  .bottom -
                                                              MediaQuery.of(
                                                                      context)
                                                                  .padding
                                                                  .top);
                                                      return Positioned(
                                                          top: 55,
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 68,
                                                          /***
                                                           * The logic for gridview is as follows:
                                                           * - Default mode is Active Speaker mode which displays only 4 tiles on screen without scroll and updates the tile according to who is currently speaking
                                                           * - If there are only 2 peers in the room in which one is local peer then automatically the mode is switched to oneToOne mode
                                                           * - As the peer count increases the mode is switched back to active speaker view in case of default mode
                                                           * - Remaining as the mode from bottom sheet is selected corresponding grid layout is rendered
                                                          */
                                                          child: (modeData.item1 ==
                                                                      MeetingMode
                                                                          .activeSpeakerWithInset &&
                                                                  (context.read<MeetingStore>().localPeer?.audioTrack !=
                                                                          null ||
                                                                      context
                                                                              .read<
                                                                                  MeetingStore>()
                                                                              .localPeer
                                                                              ?.videoTrack !=
                                                                          null))
                                                              ? OneToOneMode(
                                                                  bottomMargin:
                                                                      225,
                                                                  peerTracks:
                                                                      data
                                                                          .item1,
                                                                  screenShareCount:
                                                                      data
                                                                          .item4,
                                                                  context:
                                                                      context,
                                                                  size: size)
                                                              : (modeData.item1 ==
                                                                      MeetingMode
                                                                          .activeSpeakerWithoutInset)
                                                                  ? const CustomOneToOneGrid(
                                                                      isLocalInsetPresent:
                                                                          false,
                                                                    )
                                                                  : const CustomOneToOneGrid(
                                                                      isLocalInsetPresent:
                                                                          false,
                                                                    ));
                                                    });
                                              }),
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15,
                                                      right: 15,
                                                      top: 5,
                                                      bottom: 2),
                                                  child: MeetingHeader()),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 8.0),
                                                  child:
                                                      MeetingBottomNavigationBar())
                                            ],
                                          ),

                                          ///This gets rendered when the previewForRole method is called
                                          ///This is used to show the preview for role component
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
                                              builder: (_, previewForRoleTracks,
                                                  __) {
                                                ///If the preview for role tracks are not null
                                                ///or role change request is not null
                                                ///we show the preview for role component
                                                ///else we show and empty Container
                                                if (previewForRoleTracks.item1 != null ||
                                                    previewForRoleTracks
                                                            .item2 !=
                                                        null ||
                                                    previewForRoleTracks
                                                            .item3 !=
                                                        null) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (timeStamp) {
                                                    ///For preview for role component we use the [showGeneralDialog]
                                                    showGeneralDialog(
                                                        context: context,
                                                        pageBuilder:
                                                            (ctx, _, __) {
                                                          return ListenableProvider
                                                              .value(
                                                            value: context.read<
                                                                MeetingStore>(),
                                                            child: Scaffold(
                                                              body: SafeArea(
                                                                child:
                                                                    Container(
                                                                  color: HMSThemeColors
                                                                      .backgroundDim,
                                                                  height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                                  width: MediaQuery.of(
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
                                                                          selector: (_, meetingStore) => meetingStore
                                                                              .isVideoOn,
                                                                          builder: (_,
                                                                              isVideoOn,
                                                                              __) {
                                                                            return Container(
                                                                              height: MediaQuery.of(context).size.height,
                                                                              width: MediaQuery.of(context).size.width,
                                                                              color: HMSThemeColors.backgroundDim,
                                                                              child: (isVideoOn && previewForRoleTracks.item1 != null)
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
                                                                            context.read<MeetingStore>(),
                                                                        roleChangeRequest: context
                                                                            .read<MeetingStore>()
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
                                                  meetingStore
                                                      .hmsTrackChangeRequest,
                                              builder: (_,
                                                  hmsTrackChangeRequest, __) {
                                                if (hmsTrackChangeRequest !=
                                                    null) {
                                                  HMSTrackChangeRequest
                                                      currentRequest =
                                                      hmsTrackChangeRequest;
                                                  context
                                                          .read<MeetingStore>()
                                                          .hmsTrackChangeRequest =
                                                      null;
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    UtilityComponents
                                                        .showTrackChangeDialog(
                                                            context,
                                                            currentRequest);
                                                  });
                                                }
                                                return const SizedBox();
                                              }),
                                          Selector<MeetingStore, bool>(
                                              selector: (_, meetingStore) =>
                                                  meetingStore
                                                      .showAudioDeviceChangePopup,
                                              builder: (_,
                                                  showAudioDeviceChangePopup,
                                                  __) {
                                                if (showAudioDeviceChangePopup) {
                                                  context
                                                          .read<MeetingStore>()
                                                          .showAudioDeviceChangePopup =
                                                      false;
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
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
                                          Selector<
                                                  MeetingStore,
                                                  Tuple2<List<HMSToastModel>,
                                                      int>>(
                                              selector: (_, meetingStore) =>
                                                  Tuple2(
                                                      meetingStore.toasts,
                                                      meetingStore
                                                          .toasts.length),
                                              builder: (_, toastsItem, __) {
                                                if (toastsItem.item1.isEmpty) {
                                                  return Container();
                                                }
                                                return Stack(
                                                    children: toastsItem.item1
                                                        .sublist(
                                                            0,
                                                            min(
                                                                3,
                                                                toastsItem
                                                                    .item2))
                                                        .asMap()
                                                        .entries
                                                        .map((toasts) {
                                                  return Positioned(
                                                      bottom:
                                                          48.0 + 8 * toasts.key,
                                                      left: 5,
                                                      child: Transform.scale(
                                                        scale: _getToastScale(
                                                            toasts.key,
                                                            toastsItem.item2),
                                                        child: getToast(
                                                            toasts.value,
                                                            toasts.key,
                                                            toastsItem.item2),
                                                      ));
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
                                          if (failureErrors.item2 != null)
                                            if (failureErrors.item2?.code?.errorCode == 1003 ||
                                                failureErrors.item2?.code
                                                        ?.errorCode ==
                                                    2000 ||
                                                failureErrors.item2?.code
                                                        ?.errorCode ==
                                                    4005 ||
                                                failureErrors.item2?.code
                                                        ?.errorCode ==
                                                    424)
                                              UtilityComponents
                                                  .showFailureError(
                                                      failureErrors.item2!,
                                                      context,
                                                      () => context
                                                          .read<MeetingStore>()
                                                          .leave())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                    });
              }),
        ));
  }
}
