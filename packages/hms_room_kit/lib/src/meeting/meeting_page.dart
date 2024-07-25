//Dart imports
import 'dart:io';
import 'dart:math';

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/common_widgets/hms_hls_starting_overlay.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart' as HMSTheme;
import 'package:hms_room_kit/src/widgets/toasts/toast_widget.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/meeting/meeting_grid_component.dart';
import 'package:hms_room_kit/src/meeting/meeting_navigation_visibility_controller.dart';
import 'package:hms_room_kit/src/meeting/meeting_bottom_navigation_bar.dart';
import 'package:hms_room_kit/src/meeting/meeting_header.dart';
import 'package:hms_room_kit/src/widgets/toasts/hms_toast_model.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/widgets/app_dialogs/audio_device_change_dialog.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:hms_room_kit/src/meeting/pip_view.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_bottom_sheet.dart';
import 'package:hms_room_kit/src/preview_for_role/preview_for_role_header.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_left_room_screen.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/transcription_view.dart';

///[MeetingPage] is the main page of the meeting
///It takes the following parameters:
///[isRoomMute] is the flag to mute the room
class MeetingPage extends StatefulWidget {
  final bool isRoomMute;
  final HMSAudioDevice currentAudioDeviceMode;
  final bool isNoiseCancellationEnabled;

  const MeetingPage(
      {Key? key,
      this.isRoomMute = true,
      required this.currentAudioDeviceMode,
      this.isNoiseCancellationEnabled = false})
      : super(key: key);

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  MeetingNavigationVisibilityController? _visibilityController;

  @override
  void initState() {
    super.initState();
    checkAudioState();
    _visibilityController = MeetingNavigationVisibilityController();
    _visibilityController!.startTimerToHideButtons();
  }

  void checkAudioState() async {
    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStore>().toggleSpeaker();
      });
    }
    context.read<MeetingStore>().currentAudioDeviceMode =
        widget.currentAudioDeviceMode;
    context.read<MeetingStore>().isNoiseCancellationEnabled =
        widget.isNoiseCancellationEnabled;
  }

  bool showError(int? errorCode) {
    if (errorCode != null) {
      List<int> errorCodes = [1003, 2000, 4005, 424, 404];
      return errorCodes.contains(errorCode);
    }
    return false;
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
              meetingStore.isEndRoomCalled,
              meetingStore.localPeer?.role.permissions.hlsStreaming ?? false),
          builder: (_, failureErrors, __) {
            if (failureErrors.item1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<MeetingStore>().removeAllBottomSheets();
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
                                  primaryColor: HMSThemeColors.primaryDefault,
                                  scaffoldBackgroundColor:
                                      HMSThemeColors.backgroundDim),
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.top -
                                      MediaQuery.of(context).padding.bottom,
                                  child: Stack(
                                    children: [
                                      ChangeNotifierProvider.value(
                                          value: _visibilityController,
                                          child: MeetingGridComponent(
                                              visibilityController:
                                                  _visibilityController)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  top: 5,
                                                  bottom: 2),
                                              child: ChangeNotifierProvider.value(
                                                  value: _visibilityController,
                                                  child:
                                                      const MeetingHeader())),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: ChangeNotifierProvider.value(
                                                  value: _visibilityController,
                                                  child:
                                                      const MeetingBottomNavigationBar())),
                                        ],
                                      ),

                                      ChangeNotifierProvider.value(
                                          value: _visibilityController,
                                          child: const TranscriptionView()),

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
                                          builder:
                                              (_, previewForRoleTracks, __) {
                                            ///If the preview for role tracks are not null
                                            ///or role change request is not null
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
                                                        value: context.read<
                                                            MeetingStore>(),
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
                                                                  ///[HMSTextureView] is only rendered if video is ON
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
                                                                          color:
                                                                              HMSThemeColors.backgroundDim,
                                                                          child: (isVideoOn && previewForRoleTracks.item1 != null)
                                                                              ? Center(
                                                                                  child: HMSTextureView(
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
                                              meetingStore
                                                  .hmsTrackChangeRequest,
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
                                              showAudioDeviceChangePopup, __) {
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
                                                    .sublist(
                                                        0,
                                                        min(3,
                                                            toastsItem.item2))
                                                    .asMap()
                                                    .entries
                                                    .map((toasts) {
                                              var meetingStore =
                                                  context.read<MeetingStore>();
                                              return ChangeNotifierProvider
                                                  .value(
                                                value: _visibilityController,
                                                child: ToastWidget(
                                                    toast: toasts.value,
                                                    index: toasts.key,
                                                    toastsCount:
                                                        toastsItem.item2,
                                                    meetingStore: meetingStore),
                                              );
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
                                      if (HMSTheme
                                              .HMSRoomLayout
                                              .roleLayoutData
                                              ?.screens
                                              ?.preview
                                              ?.joinForm
                                              ?.joinBtnType ==
                                          HMSTheme.JoinButtonType
                                              .JOIN_BTN_TYPE_JOIN_AND_GO_LIVE)
                                        Selector<MeetingStore,
                                                Tuple2<bool, int>>(
                                            selector: (_, meetingStore) =>
                                                Tuple2(
                                                    meetingStore.isHLSStarting,
                                                    meetingStore
                                                        .peerTracks.length),
                                            builder: (_, hlsData, __) {
                                              return (!hlsData.item1 ||
                                                      hlsData.item2 == 0)
                                                  ? const SizedBox()
                                                  : HMSHLSStartingOverlay();
                                            }),
                                      if (failureErrors.item2 != null)
                                        if (showError(failureErrors
                                            .item2?.code?.errorCode))
                                          UtilityComponents.showFailureError(
                                              failureErrors.item2!,
                                              context,
                                              () => context
                                                  .read<MeetingStore>()
                                                  .leave()),
                                    ],
                                  ),
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
