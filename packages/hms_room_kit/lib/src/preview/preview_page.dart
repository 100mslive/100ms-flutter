import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/preview/preview_join_button.dart';
import 'package:hms_room_kit/src/preview/preview_participant_chip.dart';
import 'package:hms_room_kit/src/screen_controller.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/error_dialog.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_subheading_text.dart';
import 'package:hms_room_kit/src/widgets/hms_buttons/hms_back_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/src/meeting_screen_controller.dart';
import 'package:hms_room_kit/src/preview/preview_device_settings.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String meetingLink;
  final HMSPrebuiltOptions? options;

  const PreviewPage(
      {super.key,
      required this.name,
      required this.meetingLink,
      required this.options});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late MeetingStore _meetingStore;
  TextEditingController nameController = TextEditingController();
  bool isJoiningRoom = false;
  bool isHLSStarting = false;
  @override
  void initState() {
    super.initState();
  }

  void _setMeetingStore(PreviewStore previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: previewStore.hmsSDKInteractor,
    );
  }

  void _joinMeeting(PreviewStore previewStore) async {
    if (nameController.text.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        isJoiningRoom = true;
      });
      _setMeetingStore(previewStore);

      HMSException? ans =
          await _meetingStore.join(nameController.text, widget.meetingLink);
      if (ans != null && mounted) {
        UtilityComponents.showErrorDialog(
            context: context,
            errorMessage:
                "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
            errorTitle: ans.message ?? "Join Error",
            actionMessage: "OK",
            action: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
      }

      previewStore.removePreviewListener();

      ///When the user does not have permission to stream, or the stream is already started, or the flow is webRTC flow, then we directly navigate to the meeting screen.
      ///Without starting the HLS stream.
      if (!AppDebugConfig.isStreamingFlow ||
          previewStore.isHLSStreamingStarted ||
          !(previewStore.peer?.role.permissions.hlsStreaming ?? false)) {
        _navigateToMeeting(previewStore);
        return;
      }

      setState(() {
        isJoiningRoom = false;
        if (AppDebugConfig.isStreamingFlow) {
          isHLSStarting = true;
        }
      });

      _startStreaming(previewStore, _meetingStore);
    }
  }

  void _navigateToMeeting(PreviewStore previewStore){
      Navigator.of(context).pushReplacement(CupertinoPageRoute(
      builder: (_) => ListenableProvider.value(
            value: _meetingStore,
            child: MeetingScreenController(
              role: previewStore.peer?.role,
              roomCode: widget.meetingLink,
              localPeerNetworkQuality: null,
              user: nameController.text,
            ),
          )));
  }

  void _startStreaming(
      PreviewStore previewStore, MeetingStore meetingStore) async {
    HMSException? isStreamSuccessful;
    Future.delayed(const Duration(milliseconds: 200)).then((value) async => {
          isStreamSuccessful =
              await _meetingStore.startHLSStreaming(false, false),
          if (isStreamSuccessful == null)
            {
              isHLSStarting = false,
              _navigateToMeeting(previewStore),
            }
          else
            {
              setState(() {
                isHLSStarting = false;
              }),
              meetingStore.leave(),
              meetingStore.clearRoomState(),
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                  builder: (_) => ScreenController(
                        roomCode: widget.meetingLink,
                        options: widget.options,
                      ))),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final previewStore = context.watch<PreviewStore>();

    return WillPopScope(
      onWillPop: () async {
        previewStore.leave();
        return true;
      },
      child: Selector<PreviewStore, HMSException?>(
          selector: (_, previewStore) => previewStore.error,
          builder: (_, error, __) {
            if (error != null) {
              ErrorDialog.showTerminalErrorDialog(
                  context: context, error: error);
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                ///We show circular progress indicator until the local peer is null
                ///otherwise we render the preview
                child: (previewStore.peer == null)
                    ? SizedBox(
                        height: height,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    /**
                     * This component is used to render the video if the role has permission to publish video.
                     * For hls-viewer role or role without video publishing permission we just render an empty container with screen height and width
                     * The video is only rendered is camera is turned ON
                     * Otherwise it will render the circular avatar
                     */
                    : Stack(
                        children: [
                          ((!previewStore.peer!.role.publishSettings!.allowed
                                  .contains("video")))
                              ? SizedBox(
                                  height: height,
                                  width: width,
                                )
                              : Stack(
                                  children: [
                                    Container(
                                      height: height,
                                      width: width,
                                      color: backgroundDim,
                                      child: (previewStore.isVideoOn)
                                          ? Center(
                                              child: HMSVideoView(
                                                scaleType:
                                                    ScaleType.SCALE_ASPECT_FILL,
                                                track:
                                                    previewStore.localTracks[0],
                                                setMirror: true,
                                              ),
                                            )
                                          : isHLSStarting
                                              ? Container()
                                              : Center(
                                                  child: HMSCircularAvatar(
                                                      name:
                                                          nameController.text),
                                                ),
                                    ),

                                    ///This shows the network quality strength of the peer
                                    ///It will be shown only if the network quality is not null
                                    ///and not -1
                                    if ((previewStore.networkQuality != null &&
                                            previewStore.networkQuality !=
                                                -1) &&
                                        !isHLSStarting)
                                      Positioned(
                                        bottom: 168,
                                        left: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color:
                                                  transparentBackgroundColor),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (previewStore
                                                            .networkQuality !=
                                                        null &&
                                                    previewStore
                                                            .networkQuality !=
                                                        -1)
                                                  SvgPicture.asset(
                                                    'packages/hms_room_kit/lib/src/assets/icons/network_${previewStore.networkQuality}.svg',
                                                    fit: BoxFit.contain,
                                                    semanticsLabel:
                                                        "fl_network_icon_label",
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),

                          ///This renders the gradient background for the preview screen
                          ///It will be shown only if the peer role is not hls
                          ///and the video is ON
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                                gradient: previewStore.isVideoOn
                                    ? const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.45, 1],
                                        colors: [
                                          Color.fromRGBO(0, 0, 0, 1),
                                          Color.fromRGBO(0, 0, 0, 0)
                                        ],
                                      )
                                    : null),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: (!(previewStore
                                            .peer?.role.publishSettings!.allowed
                                            .contains("video") ??
                                        false)
                                    ? MediaQuery.of(context).size.height * 0.4
                                    : Platform.isIOS
                                        ? 50
                                        : 35),
                              ),
                              child: isHLSStarting
                                  ? Container()
                                  : Column(
                                      children: [
                                        ///We render a generic logo which can be replaced
                                        ///with the company logo from dashboard
                                        SvgPicture.asset(
                                          'packages/hms_room_kit/lib/src/assets/icons/generic.svg',
                                          fit: BoxFit.contain,
                                          semanticsLabel: "fl_user_icon_label",
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        HMSTitleText(
                                            text: "Get Started",
                                            fontSize: 24,
                                            lineHeight: 32,
                                            textColor: onSurfaceHighEmphasis),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        HMSSubheadingText(
                                            text: !(previewStore
                                                        .peer
                                                        ?.role
                                                        .publishSettings!
                                                        .allowed
                                                        .contains("video") ??
                                                    false)
                                                ? "Enter your name before joining"
                                                : "Setup your audio and video before joining",
                                            textColor: onSurfaceMediumEmphasis),

                                        ///Here we use SizedBox to keep the UI consistent
                                        ///until we have received peer list or the room-state is
                                        ///not enabled
                                        SizedBox(
                                          height: ((previewStore.peers ==
                                                      null &&
                                                  !previewStore
                                                      .isHLSStreamingStarted)
                                              ? 60
                                              : 16),
                                        ),
                                        PreviewParticipantChip(
                                            previewStore: previewStore,
                                            width: width)
                                      ],
                                    ),
                            ),
                          ),

                          ///This renders the back button at top left
                          if (!isHLSStarting)
                            Positioned(
                                top: Platform.isIOS ? 50 : 35,
                                left: 10,
                                child: HMSBackButton(
                                    onPressed: () => {
                                          previewStore.leave(),
                                          Navigator.pop(context)
                                        })),

                          ///This renders the bottom sheet with microphone, camera and audio device settings
                          ///This also contains text field for entering the name
                          Positioned(
                            bottom: 0,
                            child: (previewStore.peer != null && !isHLSStarting)
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                      color: backgroundDefault,
                                    ),
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16),
                                      child: Column(
                                        children: [
                                          if (previewStore.peer != null)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (previewStore.peer !=
                                                            null &&
                                                        context
                                                            .read<
                                                                PreviewStore>()
                                                            .peer!
                                                            .role
                                                            .publishSettings!
                                                            .allowed
                                                            .contains("audio"))
                                                      HMSEmbeddedButton(
                                                        height: 40,
                                                        width: 40,
                                                        onTap: () async =>
                                                            previewStore
                                                                .toggleMicMuteState(),
                                                        isActive: previewStore
                                                            .isAudioOn,
                                                        child: SvgPicture.asset(
                                                          previewStore.isAudioOn
                                                              ? "packages/hms_room_kit/lib/src/assets/icons/mic_state_on.svg"
                                                              : "packages/hms_room_kit/lib/src/assets/icons/mic_state_off.svg",
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  onSurfaceHighEmphasis,
                                                                  BlendMode
                                                                      .srcIn),
                                                          fit: BoxFit.scaleDown,
                                                          semanticsLabel:
                                                              "audio_mute_button",
                                                        ),
                                                      ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    if (previewStore.peer !=
                                                            null &&
                                                        previewStore
                                                            .peer!
                                                            .role
                                                            .publishSettings!
                                                            .allowed
                                                            .contains("video"))
                                                      HMSEmbeddedButton(
                                                        height: 40,
                                                        width: 40,
                                                        onTap: () async =>
                                                            (previewStore
                                                                    .localTracks
                                                                    .isEmpty)
                                                                ? null
                                                                : previewStore
                                                                    .toggleCameraMuteState(),
                                                        isActive: previewStore
                                                            .isVideoOn,
                                                        child: SvgPicture.asset(
                                                          previewStore.isVideoOn
                                                              ? "packages/hms_room_kit/lib/src/assets/icons/cam_state_on.svg"
                                                              : "packages/hms_room_kit/lib/src/assets/icons/cam_state_off.svg",
                                                          colorFilter:
                                                              ColorFilter.mode(
                                                                  onSurfaceHighEmphasis,
                                                                  BlendMode
                                                                      .srcIn),
                                                          fit: BoxFit.scaleDown,
                                                          semanticsLabel:
                                                              "video_mute_button",
                                                        ),
                                                      ),
                                                    const SizedBox(
                                                      width: 16,
                                                    ),
                                                    if (previewStore.peer !=
                                                            null &&
                                                        previewStore
                                                            .peer!
                                                            .role
                                                            .publishSettings!
                                                            .allowed
                                                            .contains("video"))
                                                      HMSEmbeddedButton(
                                                        height: 40,
                                                        width: 40,
                                                        onTap: () async =>
                                                            previewStore
                                                                .switchCamera(),
                                                        isActive: true,
                                                        child: SvgPicture.asset(
                                                          "packages/hms_room_kit/lib/src/assets/icons/camera.svg",
                                                          colorFilter: ColorFilter.mode(
                                                              previewStore
                                                                      .isVideoOn
                                                                  ? onSurfaceHighEmphasis
                                                                  : onSurfaceLowEmphasis,
                                                              BlendMode.srcIn),
                                                          fit: BoxFit.scaleDown,
                                                          semanticsLabel:
                                                              "switch_camera_button",
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    if (previewStore.peer !=
                                                            null &&
                                                        context
                                                            .read<
                                                                PreviewStore>()
                                                            .peer!
                                                            .role
                                                            .publishSettings!
                                                            .allowed
                                                            .contains("audio"))
                                                      HMSEmbeddedButton(
                                                          height: 40,
                                                          width: 40,
                                                          onTap: () {
                                                            if (Platform
                                                                .isIOS) {
                                                              context
                                                                  .read<
                                                                      PreviewStore>()
                                                                  .switchAudioOutputUsingiOSUI();
                                                            } else {
                                                              showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      backgroundDefault,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      ChangeNotifierProvider.value(
                                                                          value:
                                                                              previewStore,
                                                                          child:
                                                                              const PreviewDeviceSettings()));
                                                            }
                                                          },
                                                          isActive: true,
                                                          child:
                                                              SvgPicture.asset(
                                                            'packages/hms_room_kit/lib/src/assets/icons/${Utilities.getAudioDeviceIconName(previewStore.currentAudioOutputDevice)}.svg',
                                                            fit: BoxFit
                                                                .scaleDown,
                                                            semanticsLabel:
                                                                "settings_button",
                                                          )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:24.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 48,
                                                  width: width * 0.50,
                                                  child: TextField(
                                                    onTapOutside: (event) =>
                                                        FocusManager
                                                            .instance.primaryFocus
                                                            ?.unfocus(),
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    textCapitalization:
                                                        TextCapitalization.words,
                                                    style: GoogleFonts.inter(
                                                        color:
                                                            onSurfaceHighEmphasis),
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                                horizontal: 16),
                                                        fillColor: surfaceDefault,
                                                        filled: true,
                                                        hintText: 'Enter Name...',
                                                        hintStyle: GoogleFonts.inter(
                                                            color:
                                                                onSurfaceLowEmphasis,
                                                            height: 1.5,
                                                            fontSize: 16,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight.w400),
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            8))),
                                                        border: const OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(8)))),
                                                  ),
                                                ),
                                                HMSListenableButton(
                                                  textController: nameController,
                                                  errorMessage:
                                                      "Please enter you name",
                                                  width: width * 0.38,
                                                  onPressed: () =>
                                                      _joinMeeting(previewStore),
                                                  childWidget: PreviewJoinButton(
                                                    isEmpty: nameController
                                                        .text.isEmpty,
                                                    previewStore: previewStore,
                                                    isJoining: isJoiningRoom,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          if (isHLSStarting)
                            Container(
                              height: height,
                              width: width,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromRGBO(0, 0, 0, 1),
                                  Color.fromRGBO(0, 0, 0, 0)
                                ],
                              )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                  const SizedBox(
                                    height: 29,
                                  ),
                                  HMSSubtitleText(
                                    text: "Starting live stream...",
                                    textColor: onSurfaceHighEmphasis,
                                    fontSize: 16,
                                    lineHeight: 24,
                                    letterSpacing: 0.50,
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
              ),
            );
          }),
    );
  }
}
