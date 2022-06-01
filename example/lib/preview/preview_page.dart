//Package imports

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';

class PreviewPage extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;
  final bool mirror;
  final bool showStats;

  const PreviewPage(
      {Key? key,
      required this.roomId,
      required this.flow,
      required this.user,
      this.showStats = false,
      this.mirror = true})
      : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PreviewStore())],
    );
    super.initState();
    initPreview();
  }

  void initPreview() async {
    bool ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.user, roomId: widget.roomId);
    if (ans == false) {
      UtilityComponents.showToastWithString("Unable to preview");
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final _previewStore = context.watch<PreviewStore>();
    return ConnectivityAppWrapper(
      app: ConnectivityWidgetWrapper(
        offlineWidget: OfflineWidget(),
        disableInteraction: true,
        child: WillPopScope(
          onWillPop: () async {
            _previewStore.removePreviewListener();
            return true;
          },
          child: Scaffold(
            body: Stack(
              children: [
                (_previewStore.localTracks.isEmpty)
                    ? _previewStore.isHLSLink
                        ? Container(
                            height: itemHeight,
                            width: itemWidth,
                          )
                        : Align(
                            alignment: Alignment.center,
                            child: CupertinoActivityIndicator(radius: 50))
                    : Container(
                        height: itemHeight,
                        width: itemWidth,
                        child: (_previewStore.isVideoOn)
                            ? HMSVideoView(
                                scaleType: ScaleType.SCALE_ASPECT_FILL,
                                track: _previewStore.localTracks[0],
                                setMirror: widget.mirror,
                                matchParent: false,
                              )
                            : Container(
                                height: itemHeight,
                                width: itemWidth,
                                child: Center(
                                    child: CircleAvatar(
                                        backgroundColor:
                                            Utilities.getBackgroundColour(
                                                _previewStore.peer!.name),
                                        radius: 36,
                                        child: Text(
                                          Utilities.getAvatarTitle(
                                              _previewStore.peer!.name),
                                          style: GoogleFonts.inter(
                                              fontSize: 36,
                                              color:Colors.white,),
                                        ))),
                              ),
                      ),
                if (_previewStore.networkQuality != null &&
                    _previewStore.networkQuality != -1)
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SvgPicture.asset(
                        'assets/icons/network_${_previewStore.networkQuality}.svg',
                      ),
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (_previewStore.isRecordingStarted)
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(0.2),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: SvgPicture.asset(
                                  "assets/icons/record.svg",
                                  color: Colors.red,
                                ),
                              ),
                            if (_previewStore.peerCount != 0)
                              GestureDetector(
                                  onTap: () {
                                    if (_previewStore.peers.isNotEmpty)
                                      showModalBottomSheet<void>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2,
                                              padding: EdgeInsets.only(top: 15),
                                              child: ListView.separated(
                                                  itemBuilder:
                                                      (context, index) {
                                                    HMSPeer peer = _previewStore
                                                        .peers[index];
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(15),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          color: Color.fromARGB(
                                                              174, 0, 0, 0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            peer.name,
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:Colors.white,),
                                                          ),
                                                          Text(peer.role.name,
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:Colors.white,))
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return Divider();
                                                  },
                                                  itemCount: _previewStore
                                                      .peers.length));
                                        },
                                      );
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.transparent
                                              .withOpacity(0.2),
                                          borderRadius: _previewStore
                                                  .isRecordingStarted
                                              ? BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5))
                                              : BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/participants.svg",
                                            color:iconColor,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            _previewStore.peerCount.toString(),
                                            style: GoogleFonts.inter(
                                              color:iconColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          )
                                        ],
                                      ))),
                          ],
                        ))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // if (context.read<PreviewStore>().peer != null &&
                        //     context.read<PreviewStore>().peer!.role.publishSettings!.allowed
                        //         .contains("video"))
                        (_previewStore.peer != null &&
                                _previewStore
                                    .peer!.role.publishSettings!.allowed
                                    .contains("video"))
                            ? GestureDetector(
                                onTap: _previewStore.localTracks.isEmpty
                                    ? null
                                    : () async {
                                        _previewStore.switchVideo(
                                            isOn: _previewStore.isVideoOn);
                                      },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Colors.transparent.withOpacity(0.2),
                                  child: (_previewStore.isVideoOn)
                                      ? SvgPicture.asset(
                                          "assets/icons/cam_state_on.svg",
                                          color: Colors.blue,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/cam_state_off.svg",
                                          color: Colors.blue,
                                        ),
                                ),
                              )
                            : Container(),
                        _previewStore.peer != null
                            ? _previewStore.isHLSLink
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        padding: EdgeInsets.all(14)),
                                    onPressed: () {
                                      context
                                          .read<PreviewStore>()
                                          .removePreviewListener();
                                      _previewStore.hmsSDKInteractor
                                          .mirrorCamera = widget.mirror;
                                      _previewStore.hmsSDKInteractor.showStats =
                                          widget.showStats;
                                      _previewStore
                                          .hmsSDKInteractor.skipPreview = false;
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ListenableProvider.value(
                                                    value: MeetingStore(
                                                      hmsSDKInteractor:
                                                          _previewStore
                                                              .hmsSDKInteractor,
                                                    ),
                                                    child: MeetingPage(
                                                      roomId: widget.roomId,
                                                      flow: widget.flow,
                                                      user: widget.user,
                                                      isAudioOn: _previewStore
                                                          .isAudioOn,
                                                    ),
                                                  )));
                                    },
                                    child: Text(
                                      'Join HLS ',
                                      style: GoogleFonts.inter(
                                          height: 1, fontSize: 18),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue),
                                    onPressed: () {
                                      context
                                          .read<PreviewStore>()
                                          .removePreviewListener();
                                      _previewStore.hmsSDKInteractor
                                          .mirrorCamera = widget.mirror;
                                      _previewStore.hmsSDKInteractor.showStats =
                                          widget.showStats;
                                      _previewStore
                                          .hmsSDKInteractor.skipPreview = false;
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ListenableProvider.value(
                                                    value: MeetingStore(
                                                      hmsSDKInteractor:
                                                          _previewStore
                                                              .hmsSDKInteractor,
                                                    ),
                                                    child: MeetingPage(
                                                      roomId: widget.roomId,
                                                      flow: widget.flow,
                                                      user: widget.user,
                                                      isAudioOn: _previewStore
                                                          .isAudioOn,
                                                      localPeerNetworkQuality:
                                                          _previewStore
                                                              .networkQuality,
                                                    ),
                                                  )));
                                    },
                                    child: Text(
                                      'Join Now',
                                      style: GoogleFonts.inter(
                                          height: 1, fontSize: 18),
                                    ),
                                  )
                            : Container(),
                        (_previewStore.peer != null &&
                                context
                                    .read<PreviewStore>()
                                    .peer!
                                    .role
                                    .publishSettings!
                                    .allowed
                                    .contains("audio"))
                            ? GestureDetector(
                                onTap: () async {
                                  _previewStore.switchAudio();
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Colors.transparent.withOpacity(0.2),
                                  child: (_previewStore.isAudioOn)
                                      ? SvgPicture.asset(
                                          "assets/icons/mic_state_on.svg",
                                          color: Colors.blue,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/mic_state_off.svg",
                                          color: Colors.blue,
                                        ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
