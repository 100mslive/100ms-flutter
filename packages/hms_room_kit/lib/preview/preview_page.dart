import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/common/utility_components.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/meeting_screen_controller.dart';
import 'package:hms_room_kit/preview/preview_device_settings.dart';
import 'package:hms_room_kit/preview/preview_store.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hms_room_kit/widgets/common_widgets/subheading_text.dart';
import 'package:hms_room_kit/widgets/common_widgets/subtitle_text.dart';
import 'package:hms_room_kit/widgets/common_widgets/title_text.dart';
import 'package:hms_room_kit/widgets/meeting/meeting_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String meetingLink;

  const PreviewPage({super.key, required this.name, required this.meetingLink});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late MeetingStore _meetingStore;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void setMeetingStore(PreviewStore previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: previewStore.hmsSDKInteractor,
    );
  }

  Widget _getParticipantsText(List<HMSPeer> peers, double width) {
    String message = "";
    switch (peers.length) {
      case 1:
        message = peers[0].name;
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.28),
              child: SubtitleText(
                text: message,
                textColor: onSurfaceHighEmphasis,
                textAlign: TextAlign.center,
              ),
            ),
            SubtitleText(text: " has joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 2:
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: " joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 3:
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.15),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.20),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: ", +1 other", textColor: onSurfaceHighEmphasis)
          ],
        );
      default:
        double totalWidth = _getRemainingWidth(peers.length, width);
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: totalWidth * 0.3),
              child: SubtitleText(
                  text: peers[0].name, textColor: onSurfaceHighEmphasis),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: totalWidth * 0.7),
              child: SubtitleText(
                  text: ", ${peers[1].name}", textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(
                text: ", +${peers.length - 2} others",
                textColor: onSurfaceHighEmphasis)
          ],
        );
    }
  }

  double _getRemainingWidth(int peerCount, double width) {
    double remainingWidth = width * 0.33;
    if (peerCount < 10) {
      remainingWidth = width * 0.33;
    } else if (peerCount < 100) {
      remainingWidth = width * 0.30;
    } else if (peerCount < 1000) {
      remainingWidth = width * 0.28;
    } else if (peerCount <= 10000) {
      remainingWidth = width * 0.25;
    } else {
      remainingWidth = width * 0.2;
    }
    return remainingWidth;
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
              if ((error.code?.errorCode == 1003) ||
                  (error.code?.errorCode == 2000) ||
                  (error.code?.errorCode == 4005)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UtilityComponents.showErrorDialog(
                      context: context,
                      errorMessage:
                          "Error Code: ${error.code?.errorCode ?? ""} ${error.description}",
                      errorTitle: error.message ?? "",
                      actionMessage: "Leave Room",
                      action: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                });
              } else {
                Utilities.showToast(
                    "Error : ${error.code?.errorCode ?? ""} ${error.description} ${error.message}",
                    time: 5);
              }
            }
            return Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                      top: Platform.isIOS ? 50 : 35,
                      left: 10,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: borderColor,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: hmsWhiteColor,
                          ),
                          onPressed: () {
                            previewStore.leave();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 90.0),
                      child: Column(
                        children: [
                          TitleText(
                              text: "Get Started",
                              fontSize: 24,
                              lineHeight: 32 / 24,
                              textColor: onSurfaceHighEmphasis),
                          const SizedBox(
                            height: 8,
                          ),
                          SubtitleText(
                              text: "Setup your audio and video before joining",
                              textColor: onSurfaceLowEmphasis),
                          const SizedBox(
                            height: 20,
                          ),
                          previewStore.peers == null
                              ? Container()
                              : Container(
                                  constraints: BoxConstraints(
                                      minWidth: width * 0.5,
                                      maxWidth: width * 0.6),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: surfaceDefault,
                                      border: Border.all(color: borderDefault),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: previewStore.peers!.isEmpty
                                        ? SubtitleText(
                                            text: "You are the first to join",
                                            textColor: onSurfaceHighEmphasis)
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/participants.svg",
                                                color: onSurfaceMediumEmphasis,
                                                fit: BoxFit.scaleDown,
                                                semanticsLabel:
                                                    "audio_mute_button",
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              _getParticipantsText(
                                                  previewStore.peers!, width),
                                            ],
                                          ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          (previewStore.peer == null)
                              ? SizedBox(
                                  height: height - 200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : (previewStore.peer!.role.name.contains("hls-"))
                                  ? Center(
                                      child: CircleAvatar(
                                          backgroundColor:
                                              Utilities.getBackgroundColour(
                                                  nameController.text),
                                          radius: 40,
                                          child: Text(
                                            Utilities.getAvatarTitle(
                                                nameController.text),
                                            style: GoogleFonts.inter(
                                              fontSize: 40,
                                              color: onSurfaceHighEmphasis,
                                            ),
                                          )),
                                    )
                                  : (previewStore.localTracks.isEmpty &&
                                          previewStore.isVideoOn)
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      :
                                      /**
                                       * This componet is used to render the video if it's ON
                                       * Otherwise it will render the circular avatar
                                       */
                                      Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Container(
                                                height: height * 0.5,
                                                width: width - 20,
                                                decoration: BoxDecoration(
                                                    color: surfaceDefault),
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
                                                    : Center(
                                                        child: CircleAvatar(
                                                            backgroundColor: Utilities
                                                                .getBackgroundColour(
                                                                    nameController
                                                                        .text),
                                                            radius: 40,
                                                            child: Text(
                                                              Utilities.getAvatarTitle(
                                                                  nameController
                                                                      .text),
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 34,
                                                                  color:
                                                                      onSurfaceHighEmphasis,
                                                                  height:
                                                                      40 / 34,
                                                                  letterSpacing:
                                                                      0.25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )),
                                                      ),
                                              ),
                                            ),
                                            if ((previewStore.networkQuality !=
                                                        null &&
                                                    previewStore
                                                            .networkQuality !=
                                                        -1) ||
                                                nameController.text.isNotEmpty)
                                              Positioned(
                                                bottom: 8,
                                                left: 8,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color:
                                                          transparentBackgroundColor),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.3),
                                                            child: SubheadingText(
                                                                text:
                                                                    nameController
                                                                        .text,
                                                                textColor:
                                                                    onSecondaryHighEmphasis),
                                                          ),
                                                          if (previewStore
                                                                      .networkQuality !=
                                                                  null &&
                                                              previewStore
                                                                      .networkQuality !=
                                                                  -1)
                                                            SvgPicture.asset(
                                                              'packages/hms_room_kit/lib/assets/icons/network_${previewStore.networkQuality}.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                              semanticsLabel:
                                                                  "fl_network_icon_label",
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15.0, left: 8, right: 8),
                              child: (previewStore.peer != null)
                                  ? Column(
                                      children: [
                                        if (previewStore.peer != null &&
                                            !previewStore.peer!.role.name
                                                .contains("hls-"))
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  if (previewStore.peer !=
                                                          null &&
                                                      context
                                                          .read<PreviewStore>()
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
                                                            ? "assets/icons/mic_state_on.svg"
                                                            : "assets/icons/mic_state_off.svg",
                                                        color:
                                                            onSurfaceHighEmphasis,
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
                                                            ? "assets/icons/cam_state_on.svg"
                                                            : "assets/icons/cam_state_off.svg",
                                                        color:
                                                            onSurfaceHighEmphasis,
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "video_mute_button",
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  HMSEmbeddedButton(
                                                    height: 40,
                                                    width: 40,
                                                    onTap: () async =>
                                                        previewStore
                                                            .switchCamera(),
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      "assets/icons/camera.svg",
                                                      color: previewStore
                                                              .isVideoOn
                                                          ? onSurfaceHighEmphasis
                                                          : onSurfaceLowEmphasis,
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "switch_camera_button",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  HMSEmbeddedButton(
                                                      height: 40,
                                                      width: 40,
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                surfaceDim,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            context: context,
                                                            builder: (ctx) =>
                                                                ChangeNotifierProvider.value(
                                                                    value:
                                                                        previewStore,
                                                                    child:
                                                                        const PreviewDeviceSettings()));
                                                      },
                                                      isActive: true,
                                                      child: SvgPicture.asset(
                                                        'assets/icons/settings.svg',
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "settings_button",
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 48,
                                              width: width * 0.60,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                onSubmitted: (value) {},
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                style: GoogleFonts.inter(),
                                                controller: nameController,
                                                keyboardType:
                                                    TextInputType.name,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                decoration: InputDecoration(
                                                    suffixIcon: nameController
                                                            .text.isEmpty
                                                        ? null
                                                        : IconButton(
                                                            onPressed: () {
                                                              nameController
                                                                  .text = "";
                                                              setState(() {});
                                                            },
                                                            icon: const Icon(
                                                                Icons.clear),
                                                          ),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 14,
                                                            horizontal: 16),
                                                    fillColor: surfaceDefault,
                                                    filled: true,
                                                    hintText: 'Name',
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
                                              width: width * 0.3,
                                              onPressed: () async => {
                                                if (nameController
                                                    .text.isNotEmpty)
                                                  {
                                                    context
                                                        .read<PreviewStore>()
                                                        .removePreviewListener(),
                                                    setMeetingStore(
                                                        previewStore),
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    ListenableProvider
                                                                        .value(
                                                                      value:
                                                                          _meetingStore,
                                                                      child:
                                                                          MeetingScreenController(
                                                                        role: previewStore
                                                                            .peer
                                                                            ?.role,
                                                                        meetingLink:
                                                                            widget.meetingLink,
                                                                        localPeerNetworkQuality:
                                                                            null,
                                                                        user: nameController
                                                                            .text,
                                                                      ),
                                                                    )))
                                                  }
                                              },
                                              childWidget: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 16, 8, 16),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Join',
                                                        style: GoogleFonts.inter(
                                                            color:
                                                                onPrimaryHighEmphasis,
                                                            height: 1,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Icon(
                                                      Icons.arrow_forward,
                                                      color:
                                                          onPrimaryHighEmphasis,
                                                      size: 16,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox())
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
