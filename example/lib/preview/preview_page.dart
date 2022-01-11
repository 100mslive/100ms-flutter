import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/offline_screen.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_store.dart';
import 'package:hmssdk_flutter_example/meeting/peerTrackNode.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

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
  late PreviewStore _previewStore;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _previewStore = PreviewStore();
    _previewStore.previewController =
        PreviewController(roomId: widget.roomId, user: widget.user);
    super.initState();
    initPreview();
    reaction(
        (_) => _previewStore.error,
        (event) => {
              UtilityComponents.showonExceptionDialog(
                  (event as HMSException), context)
            });
  }

  void initPreview() async {
    _previewStore.startListen();
    String? error = await _previewStore.startPreview();
    if(error!=null){
      HMSException hmsException = HMSException(message: error,id:'INIT',description: "[INIT]: Server Errors",
      action: "INIT",params:{});
      UtilityComponents.showonExceptionDialog(
                  hmsException, context);
            }
    }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24);
    final double itemWidth = size.width;

    return ConnectivityAppWrapper(
      app: SafeArea(
        child: ConnectivityWidgetWrapper(
          offlineWidget: OfflineWidget(),
          disableInteraction: true,
          child: Scaffold(
            body: Container(
              height: itemHeight,
              width: itemWidth,
              child: Column(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Observer(
                      builder: (_) {
                        if (_previewStore.localTracks.isEmpty) {
                          return Column(children: [
                            CupertinoActivityIndicator(radius: 124),
                            SizedBox(
                              height: 64.0,
                            ),
                            Text("No preview available") //
                          ]);
                        }
                        return Provider<MeetingStore>(
                          create: (ctx) => MeetingStore(),
                          child: PeerItemOrganism(
                            observableMap: {"highestAudio": ""},
                            key: UniqueKey(),
                            height: itemHeight,
                            width: itemWidth,
                            peerTracKNode: new PeerTracKNode(
                                peerId: _previewStore.peer?.peerId ?? "",
                                name: _previewStore.peer?.name ?? "",
                                track: _previewStore.localTracks[0]),
                            isVideoMuted: false,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (_previewStore.videoOn) {
                              _previewStore.stopCapturing();
                            } else {
                              _previewStore.startCapturing();
                            }
                            setState(() {});
                          },
                          child: Icon(
                              _previewStore.videoOn
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              size: 48),
                        ),
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          _previewStore.removeListener();
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => Provider<MeetingStore>(
                                        create: (_) => MeetingStore(),
                                        child: MeetingPage(
                                            roomId: widget.roomId,
                                            flow: widget.flow,
                                            user: widget.user),
                                      )));
                        },
                        child: Text(
                          'Join Now',
                          style: TextStyle(height: 1, fontSize: 18),
                        ),
                      )),
                      Observer(builder: (context) {
                        return Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            _previewStore.switchAudio();
                          },
                          child: Icon(
                              _previewStore.audioOn ? Icons.mic : Icons.mic_off,
                              size: 48),
                        ));
                      })
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_previewStore.videoOn) {
        _previewStore.previewController.startCapturing();
      }
    } else if (state == AppLifecycleState.paused) {
      if (_previewStore.videoOn) {
        _previewStore.previewController.stopCapturing();
      }
    } else if (state == AppLifecycleState.inactive) {
      if (_previewStore.videoOn) {
        _previewStore.previewController.stopCapturing();
      }
    }
  }
}
