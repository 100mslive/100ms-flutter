import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hms_room_kit/preview/preview_join_button.dart';
import 'package:hms_room_kit/preview/preview_participant_chip.dart';
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
    bool isJoiningRoom = false;

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
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        height: height,
                                        width: width,
                                        decoration:
                                            BoxDecoration(color: backgroundDim),
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
                                                    name: nameController.text),
                                              ),
                                      ),
                                    ),

                                    ///This shows the network quality strength of the peer
                                    ///It will be shown only if the network quality is not null
                                    ///and not -1
                                    if ((previewStore.networkQuality != null &&
                                        previewStore.networkQuality != -1))
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

                          ///This renders the gradient background for the preview screen
                          ///It will be shown only if the peer role is not hls
                          ///and the video is ON
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
                                  top: (!(previewStore.peer?.role
                                              .publishSettings!.allowed
                                              .contains("video") ??
                                          false)
                                      ? MediaQuery.of(context).size.height * 0.3
                                      : Platform.isIOS
                                          ? 50
                                          : 35)),
                              child: Column(
                                children: [
                                  ///We render a generic logo which can be replaced
                                  ///with the company logo from dashboard
                                  // SvgPicture.asset(
                                  //   'packages/hms_room_kit/lib/assets/icons/generic.svg',
                                  //   fit: BoxFit.contain,
                                  //   semanticsLabel: "fl_user_icon_label",
                                  // ),
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
                                  SubtitleText(
                                      text:
                                          "Setup your audio and video before joining",
                                      textColor: onSurfaceLowEmphasis),

                                  ///Here we use SizedBox to keep the UI consistent
                                  ///until we have received peer list or the room-state is
                                  ///not enabled
                                  SizedBox(
                                    height: ((previewStore.peers == null &&
                                            !previewStore.isHLSStreamingStarted)
                                        ? 60
                                        : 20),
                                  ),
                                  PreviewParticipantChip(
                                      previewStore: previewStore, width: width)
                                ],
                              ),
                            ),
                          ),

                          ///This renders the back button at top left
                          if (!isJoiningRoom)
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
                            child: (previewStore.peer != null || !isJoiningRoom)
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
                                                              ? "packages/hms_room_kit/lib/assets/icons/mic_state_on.svg"
                                                              : "packages/hms_room_kit/lib/assets/icons/mic_state_off.svg",
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
                                                              ? "packages/hms_room_kit/lib/assets/icons/cam_state_on.svg"
                                                              : "packages/hms_room_kit/lib/assets/icons/cam_state_off.svg",
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
                                                          "packages/hms_room_kit/lib/assets/icons/camera.svg",
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
                                                    HMSEmbeddedButton(
                                                        height: 40,
                                                        width: 40,
                                                        onTap: () {
                                                          if (Platform.isIOS) {
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
                                                                      BorderRadius
                                                                          .circular(
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
                                                        child: SvgPicture.asset(
                                                          'packages/hms_room_kit/lib/assets/icons/speaker_state_on.svg',
                                                          fit: BoxFit.scaleDown,
                                                          semanticsLabel:
                                                              "settings_button",
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          const SizedBox(
                                            height: 20,
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
                                                                  Radius.circular(
                                                                      8)))),
                                                ),
                                              ),
                                              HMSListenableButton(
                                                textController: nameController,
                                                errorMessage:
                                                    "Please enter you name",
                                                width: width * 0.38,
                                                onPressed: () async => {
                                                  if (nameController
                                                      .text.isNotEmpty)
                                                    {
                                                      setState(() {
                                                        isJoiningRoom = true;
                                                      }),
                                                      context
                                                          .read<PreviewStore>()
                                                          .removePreviewListener(),
                                                      setMeetingStore(
                                                          previewStore),
                                                      isJoiningRoom = false,
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
                                                                          user:
                                                                              nameController.text,
                                                                        ),
                                                                      )))
                                                    }
                                                },
                                                childWidget: PreviewJoinButton(
                                                  previewStore: previewStore,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          if (isJoiningRoom)
                            Container(
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                backgroundDefault,
                                Colors.transparent
                              ], stops: const [
                                0.2,
                                1
                              ])),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 2,
                              )),
                            )
                        ],
                      ),
              ),
            );
          }),
    );
  }
}
