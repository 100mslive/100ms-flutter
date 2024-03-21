///Dart imports
library;

import 'dart:ui';

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
import 'package:hms_room_kit/src/widgets/common_widgets/hms_loader.dart';
import 'package:hms_room_kit/src/preview/preview_store.dart';

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
    previewStore.timer?.cancel();
    HMSRole? role = previewStore.peer?.role;
    int? localPeerNetworkQuality = previewStore.networkQuality;
    bool isRoomMute = previewStore.isRoomMute;
    HMSAudioDevice currentAudioDeviceMode = previewStore.currentAudioDeviceMode;

    previewStore.removePreviewListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MeetingScreenController(
                role: role,
                localPeerNetworkQuality: localPeerNetworkQuality,
                user: nameController.text.trim(),
                isRoomMute: isRoomMute,
                currentAudioDeviceMode: currentAudioDeviceMode,
                tokenData: widget.tokenData,
                hmsSDKInteractor: previewStore.hmsSDKInteractor,
              )));
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
            if (previewStore.peerCount > 0) {
              _navigateToMeeting(previewStore);
            }
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
                                      .contains("video")) ||
                                  widget.options?.isVideoCall == false)
                              ? SizedBox(
                                  height: height,
                                  width: width,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (widget.options?.userImgUrl != null)
                                        Image.network(
                                          widget.options!.userImgUrl!,
                                          fit: BoxFit.fill,
                                        ),
                                      SizedBox(
                                        height: height,
                                        width: width,
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 80, sigmaY: 80),
                                          child: Container(
                                            color: Colors.black.withOpacity(0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                if (widget
                                                        .options?.userImgUrl !=
                                                    null)
                                                  Image.network(
                                                    widget.options!.userImgUrl!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                SizedBox(
                                                  height: height,
                                                  width: width,
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 40, sigmaY: 40),
                                                    child: Container(
                                                      color: Colors.black
                                                          .withOpacity(0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),

                          PreviewHeader(
                            previewStore: previewStore,
                            imgUrl: widget.options?.userImgUrl,
                            userName: widget.name,
                            isVideoCall:
                                Constant.prebuiltOptions?.isVideoCall ?? false,
                          ),

                          ///This renders the bottom sheet with microphone, camera and audio device settings
                          ///This also contains text field for entering the name
                          ///
                          ///This is only rendered when the peer is not null
                          ///and the HLS is not starting
                          Positioned(
                            bottom: 32,
                            child: (previewStore.peer != null)
                                ? Container(
                                    decoration: BoxDecoration(),
                                    width: width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 16),
                                      child: Column(
                                        children: [
                                          ///This renders the preview page bottom buttons
                                          PreviewBottomButtonSection(
                                              previewStore: previewStore),
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
