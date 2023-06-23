import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_uikit/common/app_color.dart';
import 'package:hmssdk_uikit/common/utility_components.dart';
import 'package:hmssdk_uikit/common/utility_functions.dart';
import 'package:hmssdk_uikit/preview/preview_device_settings.dart';
import 'package:hmssdk_uikit/preview/preview_participant_sheet.dart';
import 'package:hmssdk_uikit/preview/preview_store.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/hms_listenable_button.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/subtitle_text.dart';
import 'package:hmssdk_uikit/widgets/common_widgets/title_text.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_page.dart';
import 'package:hmssdk_uikit/widgets/meeting/meeting_store.dart';
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
    initPreview();
  }

  void setMeetingStore(PreviewStore previewStore) {
    _meetingStore = MeetingStore(
      hmsSDKInteractor: previewStore.hmsSDKInteractor,
    );
  }

  void initPreview() async {
    HMSException? ans = await context
        .read<PreviewStore>()
        .startPreview(userName: "Test User", meetingLink: widget.meetingLink);
    if (ans != null) {
      UtilityComponents.showErrorDialog(
          context: context,
          errorMessage: "ACTION: ${ans.action} DESCRIPTION: ${ans.description}",
          errorTitle: ans.message ?? "Join Error",
          actionMessage: "OK",
          action: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          });
    }
  }

  Widget _getParticipantsText(List<HMSPeer> peers, double width) {
    String message = "";

    switch (peers.length) {
      case 1:
        message = "${peers[0].name}";
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.2),
              child:
                  SubtitleText(text: message, textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: " has joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 2:
        message = "${peers[0].name}, ${peers[1].name}";
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.35),
              child:
                  SubtitleText(text: message, textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: " joined", textColor: onSurfaceHighEmphasis)
          ],
        );
      case 3:
        message = "${peers[0].name}, ${peers[1].name}";
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.35),
              child:
                  SubtitleText(text: message, textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(text: ", +1 other", textColor: onSurfaceHighEmphasis)
          ],
        );
      default:
        message = "${peers[0].name}, ${peers[1].name}";
        return Row(
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.33),
              child:
                  SubtitleText(text: message, textColor: onSurfaceHighEmphasis),
            ),
            SubtitleText(
                text: ", +${peers.length - 2} others",
                textColor: onSurfaceHighEmphasis)
          ],
        );
    }
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Container(
                        constraints: BoxConstraints(
                            minWidth: width * 0.5, maxWidth: width * 0.6),
                        height: 40,
                        decoration: BoxDecoration(
                            color: surfaceDefault,
                            border: Border.all(color: borderDefault),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: previewStore.peerCount < 1
                              ? SubtitleText(
                                  text: "You are the first to join",
                                  textColor: onSurfaceHighEmphasis)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/participants.svg",
                                      color: onSurfaceMediumEmphasis,
                                      fit: BoxFit.scaleDown,
                                      semanticsLabel: "audio_mute_button",
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    _getParticipantsText(
                                        previewStore.peers, width),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (previewStore.peer == null)
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : (previewStore.peer!.role.name.contains("hls-"))
                              ? Center(
                                  child: CircleAvatar(
                                      backgroundColor: defaultAvatarColor,
                                      radius: 40,
                                      child: Text(
                                        Utilities.getAvatarTitle(
                                            previewStore.peer!.name),
                                        style: GoogleFonts.inter(
                                          fontSize: 40,
                                          color: Colors.white,
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
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
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
                                                    backgroundColor:
                                                        defaultAvatarColor,
                                                    radius: 40,
                                                    child: Text(
                                                      Utilities.getAvatarTitle(
                                                          previewStore
                                                              .peer!.name),
                                                      style: GoogleFonts.inter(
                                                        fontSize: 40,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ),
                                      ),
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
                                              if (previewStore.peer != null &&
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
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isAudioOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isAudioOn
                                                        ? "assets/icons/mic_state_on.svg"
                                                        : "assets/icons/mic_state_off.svg",
                                                    color:
                                                        previewStore.isAudioOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "audio_mute_button",
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (previewStore.peer != null &&
                                                  previewStore.peer!.role
                                                      .publishSettings!.allowed
                                                      .contains("video"))
                                                HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async => (previewStore
                                                          .localTracks.isEmpty)
                                                      ? null
                                                      : previewStore
                                                          .toggleCameraMuteState(),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isVideoOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isVideoOn
                                                        ? "assets/icons/cam_state_on.svg"
                                                        : "assets/icons/cam_state_off.svg",
                                                    color:
                                                        previewStore.isVideoOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "video_mute_button",
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (previewStore.networkQuality !=
                                                      null &&
                                                  previewStore.networkQuality !=
                                                      -1)
                                                HMSEmbeddedButton(
                                                    height: 40,
                                                    width: 40,
                                                    onTap: () {},
                                                    offColor: dividerColor,
                                                    onColor: dividerColor,
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/settings.svg',
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "network_button",
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
                                            autofocus: false,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            style: GoogleFonts.inter(),
                                            controller: nameController,
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                            decoration: InputDecoration(
                                                suffixIcon: nameController
                                                        .text.isEmpty
                                                    ? null
                                                    : IconButton(
                                                        onPressed: () {
                                                          nameController.text =
                                                              "";
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
                                                    color: onSurfaceLowEmphasis,
                                                    height: 1.5,
                                                    fontSize: 16,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: borderColor,
                                                        width: 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                border: const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8)))),
                                          ),
                                        ),
                                        HMSListenableButton(
                                          textController: nameController,
                                          errorMessage: "Please enter you name",
                                          width: width * 0.3,
                                          onPressed: () async => {
                                            context
                                                .read<PreviewStore>()
                                                .removePreviewListener(),
                                            setMeetingStore(previewStore),
                                            _meetingStore.join(
                                              nameController.text,
                                              widget.meetingLink,
                                            ),
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            ListenableProvider
                                                                .value(
                                                              value:
                                                                  _meetingStore,
                                                              child: MeetingPage(
                                                                  meetingLink:
                                                                      widget
                                                                          .meetingLink),
                                                            )))
                                          },
                                          childWidget: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 16, 8, 16),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Join',
                                                    style: GoogleFonts.inter(
                                                        color: enabledTextColor,
                                                        height: 1,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: enabledTextColor,
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
              ),
            );
          }),
    );
  }
}
