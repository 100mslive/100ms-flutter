import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hms_room_kit/preview/preview_get_participants_text.dart';
import 'package:hms_room_kit/widgets/common_widgets/error_dialog.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_circular_avatar.dart';
import 'package:hms_room_kit/widgets/hms_buttons/hms_back_button.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hms_room_kit/common/app_color.dart';
import 'package:hms_room_kit/meeting_screen_controller.dart';
import 'package:hms_room_kit/preview/preview_device_settings.dart';
import 'package:hms_room_kit/preview/preview_store.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_embedded_button.dart';
import 'package:hms_room_kit/widgets/common_widgets/hms_listenable_button.dart';
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
                child: Stack(
                  children: [
                    (previewStore.peer == null)
                        ? SizedBox(
                            height: height,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : (previewStore.peer!.role.name.contains("hls-"))
                            ? SizedBox(
                                height: height,
                                width: width,
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
                                       * This component is used to render the video if it's ON
                                       * Otherwise it will render the circular avatar
                                       */
                                Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          height: height,
                                          width: width,
                                          decoration: BoxDecoration(
                                              color: backgroundDim),
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
                                                  child: HMSCircularAvatar(
                                                      name:
                                                          nameController.text),
                                                ),
                                        ),
                                      ),
                                      if ((previewStore.networkQuality !=
                                                  null &&
                                              previewStore.networkQuality !=
                                                  -1) ||
                                          nameController.text.isNotEmpty)
                                        Positioned(
                                          bottom: 160,
                                          left: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color:
                                                    transparentBackgroundColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
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
                                                      'packages/hms_room_kit/lib/assets/icons/network_${previewStore.networkQuality}.svg',
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
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                          //border corner radius
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          gradient: previewStore.isVideoOn
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.3, 0.6, 1],
                                  colors: [
                                    Colors.black,
                                    transparentBackgroundColor,
                                    Colors.transparent
                                  ],
                                )
                              : null),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: ((previewStore.peer?.role.name
                                        .contains("hls-") ??
                                    true)
                                ? MediaQuery.of(context).size.height * 0.3
                                : Platform.isIOS
                                    ? 50
                                    : 35)),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'packages/hms_room_kit/lib/assets/icons/generic.svg',
                              fit: BoxFit.contain,
                              semanticsLabel: "fl_user_icon_label",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TitleText(
                                text: "Get Started",
                                fontSize: 24,
                                lineHeight: 32 / 24,
                                textColor: onSurfaceHighEmphasis),
                            const SizedBox(
                              height: 8,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SubtitleText(
                                text:
                                    "Setup your audio and video before joining",
                                textColor: onSurfaceLowEmphasis),
                            SizedBox(
                              height: (previewStore.peers == null ? 60 : 20),
                            ),
                            previewStore.peers == null
                                ? Container()
                                : Container(
                                    constraints: BoxConstraints(
                                        minWidth: width * 0.4,
                                        maxWidth: width * 0.5),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: surfaceDefault,
                                        border:
                                            Border.all(color: borderDefault),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: previewStore.peers!.isEmpty
                                          ? SubtitleText(
                                              text: "You are the first to join",
                                              textColor: onSurfaceHighEmphasis)
                                          : PreviewParticipantsText(
                                              peers: previewStore.peers!,
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: Platform.isIOS ? 50 : 35,
                        left: 10,
                        child: HMSBackButton(
                            onPressed: () => {
                                  previewStore.leave(),
                                  Navigator.pop(context)
                                })),
                    Positioned(
                      bottom: 0,
                      child: (previewStore.peer != null)
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: backgroundDefault,
                              ),
                              width: width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16),
                                child: Column(
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
                                                  isActive:
                                                      previewStore.isAudioOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isAudioOn
                                                        ? "packages/hms_room_kit/lib/assets/icons/mic_state_on.svg"
                                                        : "packages/hms_room_kit/lib/assets/icons/mic_state_off.svg",
                                                    colorFilter: ColorFilter.mode(
                                                        onSurfaceHighEmphasis,
                                                        BlendMode.srcIn),
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "audio_mute_button",
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 16,
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
                                                  isActive:
                                                      previewStore.isVideoOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isVideoOn
                                                        ? "packages/hms_room_kit/lib/assets/icons/cam_state_on.svg"
                                                        : "packages/hms_room_kit/lib/assets/icons/cam_state_off.svg",
                                                    colorFilter: ColorFilter.mode(
                                                        onSurfaceHighEmphasis,
                                                        BlendMode.srcIn),
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "video_mute_button",
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              if (previewStore.peer != null &&
                                                  previewStore.peer!.role
                                                      .publishSettings!.allowed
                                                      .contains("video"))
                                                HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async =>
                                                      previewStore
                                                          .switchCamera(),
                                                  isActive: true,
                                                  child: SvgPicture.asset(
                                                    "packages/hms_room_kit/lib/assets/icons/camera.svg",
                                                    colorFilter: ColorFilter.mode(
                                                        previewStore.isVideoOn
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
                                              HMSEmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () {
                                                    if (Platform.isIOS) {
                                                      context
                                                          .read<PreviewStore>()
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
                                                    }
                                                  },
                                                  isActive: true,
                                                  child: SvgPicture.asset(
                                                    'packages/hms_room_kit/lib/assets/icons/${Utilities.getAudioDeviceIconName(context.watch<PreviewStore>().currentAudioDeviceMode)}.svg',
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
                                          width: width * 0.50,
                                          child: TextField(
                                            textInputAction:
                                                TextInputAction.done,
                                            onSubmitted: (value) {},
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
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
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
                                          width: width * 0.38,
                                          onPressed: () async => {
                                            if (nameController.text.isNotEmpty)
                                              {
                                                context
                                                    .read<PreviewStore>()
                                                    .removePreviewListener(),
                                                setMeetingStore(previewStore),
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
                                                                        widget
                                                                            .meetingLink,
                                                                    localPeerNetworkQuality:
                                                                        null,
                                                                    user: nameController
                                                                        .text,
                                                                  ),
                                                                )))
                                              }
                                          },
                                          childWidget: Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                2, 16, 2, 16),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            child: Text('Join Now',
                                                style: GoogleFonts.inter(
                                                    color:
                                                        onPrimaryHighEmphasis,
                                                    height: 1,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
