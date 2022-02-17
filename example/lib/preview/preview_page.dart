//Package imports
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/video_tile.dart';
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
  // late PreviewStore context.read<PreviewStore>();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PreviewStore())],
    );
    // context.read<PreviewStore>() = PreviewStore();
    super.initState();
    initPreview();
    // reaction(
    //     (_) => context.read<PreviewStore>().error,
    //     (event) => {
    //           UtilityComponents.showSnackBarWithString(
    //               (event as HMSException).message, context)
    //         });
  }

  void initPreview() async {
    context.read<PreviewStore>().addPreviewListener();
    bool ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.user, roomId: widget.roomId);
    // context.read<PreviewStore>().addPreviewListener();
    // bool ans = await context.read<PreviewStore>().startPreview(
    //     roomId: widget.roomId, user: widget.user);
    if (ans == false) {
      UtilityComponents.showSnackBarWithString("Unable to preview", context);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // context.read<PreviewStore>().removePreviewListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24);
    final double itemWidth = size.width;
    return ConnectivityAppWrapper(
      app: ConnectivityWidgetWrapper(
        offlineWidget: OfflineWidget(),
        disableInteraction: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Preview"),
          ),
          body: Container(
            height: itemHeight,
            width: itemWidth,
            child: Column(
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: (context.read<PreviewStore>().localTracks.isEmpty)
                        ? Column(children: [
                            CupertinoActivityIndicator(radius: 124),
                            SizedBox(
                              height: 64.0,
                            ),
                            Text("No preview available") //
                          ])
                        : Provider<MeetingStore>(
                            create: (ctx) => MeetingStore(),
                            child: VideoTile(
                              itemHeight: itemHeight,
                              itemWidth: itemWidth,
                              peerTrackNode: PeerTrackNode(
                                  peer: context.watch<PreviewStore>().peer!,
                                  uid: context
                                      .watch<PreviewStore>()
                                      .peer!
                                      .peerId,
                                  track: context
                                      .watch<PreviewStore>()
                                      .localTracks[0],
                                  isVideoOn: context
                                      .watch<PreviewStore>()
                                      .localTracks[0]
                                      .isMute),
                              audioView: false,
                            ),
                          )),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // if (context.read<PreviewStore>().peer != null &&
                    //     context.read<PreviewStore>().peer!.role.publishSettings!.allowed
                    //         .contains("video"))
                    (context.watch<PreviewStore>().peer != null &&
                            context
                                .watch<PreviewStore>()
                                .peer!
                                .role
                                .publishSettings!
                                .allowed
                                .contains("video"))
                        ? GestureDetector(
                            onTap: context
                                    .read<PreviewStore>()
                                    .localTracks
                                    .isEmpty
                                ? null
                                : () async {
                                    context.read<PreviewStore>().switchVideo();
                                  },
                            child: Icon(
                                context.watch<PreviewStore>().videoOn
                                    ? Icons.videocam
                                    : Icons.videocam_off,
                                size: 48),
                          )
                        : Container(),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PreviewStore>().removePreviewListener();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                    ),
                    (context.watch<PreviewStore>().peer != null &&
                            context
                                .read<PreviewStore>()
                                .peer!
                                .role
                                .publishSettings!
                                .allowed
                                .contains("audio"))
                        ? GestureDetector(
                            onTap: () async {
                              context.read<PreviewStore>().switchAudio();
                            },
                            child: Icon(
                                (context.watch<PreviewStore>().audioOn)
                                    ? Icons.mic
                                    : Icons.mic_off,
                                size: 48),
                          )
                        : Container(),
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
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (mounted) {
      if (state == AppLifecycleState.resumed) {
        if (context.watch<PreviewStore>().videoOn) {
          context.read<PreviewStore>().startCapturing();
        }
      } else if (state == AppLifecycleState.paused) {
        if (context.watch<PreviewStore>().videoOn) {
          context.read<PreviewStore>().stopCapturing();
        }
      } else if (state == AppLifecycleState.inactive) {
        if (context.watch<PreviewStore>().videoOn) {
          context.read<PreviewStore>().stopCapturing();
        }
      }
    }
  }
}
