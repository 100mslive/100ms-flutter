//Package imports
import 'dart:math';

import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peer_track_node.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';

class PreviewPage extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;

  const PreviewPage(
      {Key? key, required this.roomId, required this.flow, required this.user})
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
    context.read<PreviewStore>().addPreviewListener();
    bool ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.user, roomId: widget.roomId);
    if (ans == false) {
      UtilityComponents.showSnackBarWithString("Unable to preview", context);
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
        child: Scaffold(
          body: Stack(
            children: [
              (_previewStore.localTracks.isEmpty)
                  ? Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(radius: 50))
                  : Container(
                      height: itemHeight,
                      width: itemWidth,
                      child: 
                    (_previewStore.isVideoOn)?
                      HMSVideoView(
                        track: _previewStore.localTracks[0],
                        setMirror: false,
                        matchParent: false,
                      ):Container(
                    height: itemHeight,
                    width: itemWidth,
                    child: Center(child: CircleAvatar(
                      backgroundColor: Utilities.colors[_previewStore.peer!.name.toLowerCase().codeUnitAt(0)%Utilities.colors.length],
                      radius: 36,
                      child: Text(Utilities.getAvatarTitle(_previewStore.peer!.name),style: TextStyle(fontSize: 36,color: Colors.white),))),
                  ),
                    ),
              
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
                                  .peer!
                                  .role
                                  .publishSettings!
                                  .allowed
                                  .contains("video"))
                          ? GestureDetector(
                              onTap: _previewStore
                                      .localTracks
                                      .isEmpty
                                  ? null
                                  : () async {
                                      _previewStore.switchVideo(isOn:_previewStore.isVideoOn);
                                    },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.2),
                                child: Icon(
                                    _previewStore.isVideoOn
                                        ? Icons.videocam
                                        : Icons.videocam_off,
                                        color: Colors.blue
                                    ),
                              ),
                            )
                          : Container(),
                      _previewStore.peer != null?ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () {
                          context.read<PreviewStore>().removePreviewListener();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (_) =>  ListenableProvider.value(
                                    value:  MeetingStore(),
                                    child: MeetingPage(
                                        roomId: widget.roomId,
                                        flow: widget.flow,
                                        user: widget.user,
                                        isAudioOn:_previewStore.isAudioOn),
                                  )));
                        },
                        child: Text(
                          'Join Now',
                          style: TextStyle(height: 1, fontSize: 18),
                        ),
                      ):Container(),
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
                                radius : 25,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.2),
                                child: Icon(
                                    (_previewStore.isAudioOn)
                                        ? Icons.mic
                                        : Icons.mic_off,
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
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        if (context.watch<PreviewStore>().isVideoOn) {
          context.read<PreviewStore>().startCapturing();
        }
      } else if (state == AppLifecycleState.paused) {
        if (context.watch<PreviewStore>().isVideoOn) {
          context.read<PreviewStore>().stopCapturing();
        }
      } else if (state == AppLifecycleState.inactive) {
        if (context.watch<PreviewStore>().isVideoOn) {
          context.read<PreviewStore>().stopCapturing();
        }
      }
    }
  }
}
