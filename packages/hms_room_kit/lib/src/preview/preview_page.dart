///Dart imports
import 'dart:io';

///Package imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/layout_api/hms_room_layout.dart';
import 'package:hms_room_kit/src/preview/preview_bottom_button_section.dart';
import 'package:hms_room_kit/src/preview/preview_header.dart';
import 'package:hms_room_kit/src/preview/preview_join_button.dart';
import 'package:hms_room_kit/src/preview/preview_network_indicator.dart';
import 'package:hms_room_kit/src/screen_controller.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_loader.dart';
import 'package:hms_room_kit/src/widgets/hms_buttons/hms_back_button.dart';
import 'package:hms_room_kit/src/meeting_screen_controller.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///This renders the Preview Screen
class PreviewPage extends StatefulWidget {
  final String name;
  final String roomCode;
  final HMSPrebuiltOptions? options;

  const PreviewPage(
      {super.key,
      required this.name,
      required this.roomCode,
      required this.options});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late MeetingStore _meetingStore;
  late TextEditingController nameController;
  bool isJoiningRoom = false;
  bool isHLSStarting = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  ///This function initializes the [MeetingStore] object
  void _setMeetingStore(PreviewStore previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: previewStore.hmsSDKInteractor,
    );
    _meetingStore.roles = previewStore.roles;
  }

  ///This function joins the room only if the name is not empty
  void _joinMeeting(PreviewStore previewStore) async {
    if (nameController.text.trim().isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        isJoiningRoom = true;
      });

      ///Here we set the [MeetingStore] object
      _setMeetingStore(previewStore);

      /// We join the room here
      HMSException? ans = await _meetingStore.join(
          nameController.text.trim(), Constant.roomCode);

      ///If the room join fails we show the error dialog
      if (ans != null && mounted) {
        showGeneralDialog(
            context: context,
            pageBuilder: (_, data, __) {
              return UtilityComponents.showFailureError(
                  ans,
                  context,
                  () =>
                      Navigator.of(context).popUntil((route) => route.isFirst));
            });
        return;
      }

      /// If the room join is successful
      ///  - If the join button type is `join only` or the HLS streaming is already started
      ///  - We navigate to the meeting screen
      ///
      ///  - If the join button type is `join and go live` and the HLS streaming is not started
      ///  - We start the HLS streaming
      previewStore.isRoomJoined = true;
      previewStore.removePreviewListener();
      previewStore.hmsSDKInteractor.addUpdateListener(previewStore);

      ///When the user does not have permission to stream, or the stream is already started, or the flow is webRTC flow, then we directly navigate to the meeting screen.
      ///Without starting the HLS stream.
      if (HMSRoomLayout
                  .roleLayoutData?.screens?.preview?.joinForm?.joinBtnType ==
              JoinButtonType.JOIN_BTN_TYPE_JOIN_ONLY ||
          previewStore.isHLSStreamingStarted) {
        previewStore.toggleIsRoomJoinedAndHLSStarted();
        previewStore.isMeetingJoined = true;
        return;
      }

      setState(() {
        isJoiningRoom = false;
        if (HMSRoomLayout
                .roleLayoutData?.screens?.preview?.joinForm?.joinBtnType ==
            JoinButtonType.JOIN_BTN_TYPE_JOIN_AND_GO_LIVE) {
          isHLSStarting = true;
        }
      });

      _startStreaming(previewStore, _meetingStore);
    }
  }

  ///This function starts the HLS streaming
  void _startStreaming(
      PreviewStore previewStore, MeetingStore meetingStore) async {
    HMSException? isStreamSuccessful;
    Future.delayed(const Duration(milliseconds: 100)).then((value) async => {
          isStreamSuccessful =
              await _meetingStore.startHLSStreaming(false, false),
          if (isStreamSuccessful != null)
            {
              previewStore.hmsSDKInteractor.toggleAlwaysScreenOn(),
              setState(() {
                isHLSStarting = false;
              }),
              previewStore.hmsSDKInteractor.removeUpdateListener(previewStore),
              meetingStore.removeListeners(),
              meetingStore.peerTracks.clear(),
              meetingStore.resetForegroundTaskAndOrientation(),
              // meetingStore.clearPIPState(),
              meetingStore.isRoomEnded = true,
              previewStore.isMeetingJoined = false,
              previewStore.hmsSDKInteractor.leave(),
              HMSThemeColors.resetLayoutColors(),
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => ScreenController(
                            roomCode: Constant.roomCode,
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
        if (!previewStore.isRoomJoinedAndHLSStarted) {
          previewStore.leave();
        }
        return true;
      },
      child: Selector<PreviewStore, HMSException?>(
          selector: (_, previewStore) => previewStore.error,
          builder: (_, error, __) {
            if (previewStore.isRoomJoinedAndHLSStarted) {
              previewStore.hmsSDKInteractor.removeUpdateListener(previewStore);
            }
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: HMSThemeColors.backgroundDim,
              body: previewStore.isRoomJoinedAndHLSStarted
                  ? ListenableProvider.value(
                      value: _meetingStore,
                      child: MeetingScreenController(
                        role: previewStore.peer?.role,
                        roomCode: Constant.roomCode,
                        localPeerNetworkQuality: null,
                        user: nameController.text,
                      ),
                    )
                  : SingleChildScrollView(
                      ///We show circular progress indicator until the local peer is null
                      ///otherwise we render the preview
                      child: (previewStore.peer == null)
                          ? const HMSLoader()
                          /**
                       * This component is used to render the video if the role has permission to publish video.
                       * For hls-viewer role or role without video publishing permission we just render an empty container with screen height and width
                       * The video is only rendered is camera is turned ON
                       * Otherwise it will render the circular avatar
                      */
                          : Stack(
                              children: [
                                ((!previewStore
                                        .peer!.role.publishSettings!.allowed
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
                                            color: HMSThemeColors.backgroundDim,

                                            ///This renders the video view
                                            ///It will be shown only if the video is ON
                                            ///and the role has permission to publish video
                                            ///Otherwise it will render the circular avatar
                                            child: (previewStore.isVideoOn)
                                                ? Center(
                                                    child: HMSVideoView(
                                                      scaleType: ScaleType
                                                          .SCALE_ASPECT_FILL,
                                                      track: previewStore
                                                          .localTracks[0],
                                                      setMirror: true,
                                                    ),
                                                  )
                                                : isHLSStarting
                                                    ? Container()
                                                    : Center(
                                                        child: HMSCircularAvatar(
                                                            avatarTitleTextColor:
                                                                Colors.white,
                                                            name: nameController
                                                                .text),
                                                      ),
                                          ),

                                          ///This shows the network quality strength of the peer
                                          ///It will be shown only if the network quality is not null
                                          ///and not -1 and HLS is not starting
                                          PreviewNetworkIndicator(
                                              previewStore: previewStore,
                                              isHidden: isHLSStarting)
                                        ],
                                      ),

                                ///This renders the gradient background for the preview screen
                                ///It will be shown only if the peer role is not hls
                                ///and the video is ON
                                PreviewHeader(
                                    previewStore: previewStore,
                                    isHidden: isHLSStarting,
                                    width: width),

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
                                ///
                                ///This is only rendered when the peer is not null
                                ///and the HLS is not starting
                                Positioned(
                                  bottom: 0,
                                  child: (previewStore.peer != null &&
                                          !isHLSStarting)
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16)),
                                            color: HMSThemeColors
                                                .backgroundDefault,
                                          ),
                                          width: width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 16),
                                            child: Column(
                                              children: [
                                                ///This renders the preview page bottom buttons
                                                PreviewBottomButtonSection(
                                                    previewStore: previewStore),
                                                const SizedBox(
                                                  height: 16,
                                                ),

                                                ///This renders the name text field and join button
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 24.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        height: 48,
                                                        width: width * 0.50,
                                                        child: TextField(
                                                          cursorColor:
                                                              HMSThemeColors
                                                                  .onSurfaceHighEmphasis,
                                                          onTapOutside: (event) =>
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus(),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                          textCapitalization:
                                                              TextCapitalization
                                                                  .words,
                                                          style: HMSTextStyle
                                                              .setTextStyle(
                                                                  color: HMSThemeColors
                                                                      .onSurfaceHighEmphasis),
                                                          controller:
                                                              nameController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          onChanged: (value) {
                                                            setState(() {});
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      const EdgeInsets.symmetric(
                                                                          vertical:
                                                                              12,
                                                                          horizontal:
                                                                              16),
                                                                  fillColor: HMSThemeColors
                                                                      .surfaceDefault,
                                                                  filled: true,

                                                                  ///This renders the hint text
                                                                  hintText:
                                                                      'Enter Name...',
                                                                  hintStyle: HMSTextStyle.setTextStyle(
                                                                      color: HMSThemeColors
                                                                          .onSurfaceLowEmphasis,
                                                                      height:
                                                                          1.5,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.5,
                                                                      fontWeight: FontWeight
                                                                          .w400),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              2,
                                                                          color: HMSThemeColors
                                                                              .primaryDefault),
                                                                      borderRadius:
                                                                          const BorderRadius.all(Radius.circular(
                                                                              8))),
                                                                  enabledBorder: const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(8))),
                                                                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                                                        ),
                                                      ),
                                                      HMSListenableButton(
                                                        isDisabled:
                                                            isHLSStarting,
                                                        textController:
                                                            nameController,
                                                        width: width * 0.38,
                                                        onPressed: () =>
                                                            _joinMeeting(
                                                                previewStore),
                                                        childWidget:
                                                            PreviewJoinButton(
                                                          isEmpty:
                                                              nameController
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty,
                                                          previewStore:
                                                              previewStore,
                                                          isJoining:
                                                              isJoiningRoom,
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
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        HMSThemeColors.backgroundDim
                                            .withOpacity(1),
                                        HMSThemeColors.backgroundDim
                                            .withOpacity(0)
                                      ],
                                    )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: HMSThemeColors.primaryDefault,
                                        ),
                                        const SizedBox(
                                          height: 29,
                                        ),
                                        HMSSubtitleText(
                                          text: "Starting live stream...",
                                          textColor: HMSThemeColors
                                              .onSurfaceHighEmphasis,
                                          fontSize: 16,
                                          lineHeight: 24,
                                          letterSpacing: 0.50,
                                        )
                                      ],
                                    ),
                                  ),
                                if (error != null)
                                  UtilityComponents.showFailureError(
                                      error,
                                      context,
                                      () => Navigator.of(context)
                                          .popUntil((route) => route.isFirst)),
                              ],
                            ),
                    ),
            );
          }),
    );
  }
}
