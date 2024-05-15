///Dart imports
library;

import 'dart:io';

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/meeting_screen_controller.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/common/utility_components.dart';
import 'package:hms_room_kit/src/preview/preview_bottom_button_section.dart';
import 'package:hms_room_kit/src/preview/preview_header.dart';
import 'package:hms_room_kit/src/preview/preview_join_button.dart';
import 'package:hms_room_kit/src/preview/preview_network_indicator.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_loader.dart';
import 'package:hms_room_kit/src/widgets/hms_buttons/hms_back_button.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';
import 'package:hms_room_kit/src/widgets/common_widgets/hms_listenable_button.dart';

///This renders the Preview Screen
class PreviewPage extends StatefulWidget {
  final String name;
  final HMSPrebuiltOptions? options;
  final String tokenData;

  const PreviewPage(
      {super.key,
      required this.name,
      required this.options,
      required this.tokenData});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    context
        .read<PreviewStore>()
        .startPreview(userName: widget.name, tokenData: widget.tokenData);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  ///[_navigateToMeeting] navigates to meeting from preview
  void _navigateToMeeting(PreviewStore previewStore) {
    HMSRole? role = previewStore.peer?.role;
    int? localPeerNetworkQuality = previewStore.networkQuality;
    bool isRoomMute = previewStore.isRoomMute;
    HMSAudioDevice currentAudioDeviceMode = previewStore.currentAudioDeviceMode;

    if (nameController.text.trim().isEmpty) {
      return;
    }
    previewStore.removePreviewListener();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MeetingScreenController(
              role: role,
              localPeerNetworkQuality: localPeerNetworkQuality,
              user: nameController.text.trim(),
              isRoomMute: isRoomMute,
              currentAudioDeviceMode: currentAudioDeviceMode,
              tokenData: widget.tokenData,
              hmsSDKInteractor: previewStore.hmsSDKInteractor,
              isNoiseCancellationEnabled:
                  previewStore.isNoiseCancellationEnabled,
            )));
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
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: HMSThemeColors.backgroundDim,
              body: SingleChildScrollView(
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
                                      color: HMSThemeColors.backgroundDim,

                                      ///This renders the video view
                                      ///It will be shown only if the video is ON
                                      ///and the role has permission to publish video
                                      ///Otherwise it will render the circular avatar
                                      child: (previewStore.isVideoOn)
                                          ? Center(
                                              child: HMSTextureView(
                                                scaleType:
                                                    ScaleType.SCALE_ASPECT_FILL,
                                                track:
                                                    previewStore.localTracks[0],
                                                setMirror: true,
                                              ),
                                            )
                                          : Center(
                                              child: HMSCircularAvatar(
                                                  avatarTitleTextColor:
                                                      Colors.white,
                                                  name: nameController.text),
                                            ),
                                    ),

                                    ///This shows the network quality strength of the peer
                                    ///It will be shown only if the network quality is not null
                                    ///and not -1 and HLS is not starting
                                    PreviewNetworkIndicator(
                                      previewStore: previewStore,
                                    )
                                  ],
                                ),

                          PreviewHeader(
                              previewStore: previewStore, width: width),

                          ///This renders the back button at top left
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
                            child: (previewStore.peer != null)
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16)),
                                      color: HMSThemeColors.backgroundDefault,
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
                                            padding: const EdgeInsets.only(
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
                                                    enabled: widget.name
                                                        .trim()
                                                        .isEmpty,
                                                    cursorColor: HMSThemeColors
                                                        .onSurfaceHighEmphasis,
                                                    onTapOutside: (event) =>
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus(),
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    style: HMSTextStyle.setTextStyle(
                                                        color: HMSThemeColors
                                                            .onSurfaceHighEmphasis),
                                                    controller: nameController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets.symmetric(
                                                                vertical: 12,
                                                                horizontal: 16),
                                                        fillColor: HMSThemeColors
                                                            .surfaceDefault,
                                                        filled: true,

                                                        ///This renders the hint text
                                                        hintText:
                                                            'Enter Name...',
                                                        hintStyle: HMSTextStyle.setTextStyle(
                                                            color: HMSThemeColors
                                                                .onSurfaceLowEmphasis,
                                                            height: 1.5,
                                                            fontSize: 16,
                                                            letterSpacing: 0.5,
                                                            fontWeight: FontWeight
                                                                .w400),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                width: 2,
                                                                color: HMSThemeColors
                                                                    .primaryDefault),
                                                            borderRadius:
                                                                const BorderRadius.all(
                                                                    Radius.circular(
                                                                        8))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius.all(Radius.circular(8))),
                                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                                                  ),
                                                ),
                                                HMSListenableButton(
                                                  textController:
                                                      nameController,
                                                  width: width * 0.38,
                                                  onPressed: () {
                                                    if (nameController.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      _navigateToMeeting(
                                                          previewStore);
                                                    }
                                                  },
                                                  childWidget:
                                                      PreviewJoinButton(
                                                    isEmpty: nameController.text
                                                        .trim()
                                                        .isEmpty,
                                                    previewStore: previewStore,
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
