import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/preview/preview_controller.dart';
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

class _PreviewPageState extends State<PreviewPage> {
  late PreviewStore _previewStore;

  @override
  void initState() {
    _previewStore = PreviewStore();
    _previewStore.previewController =
        PreviewController(roomId: widget.roomId, user: widget.user);
    super.initState();
    initPreview();
  }

  void initPreview() {
    _previewStore.startListen();
    _previewStore.startPreview();
  }

  bool videoOn = true, audioOn = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 500.0,
          width: 500.0,
          child: Column(
            children: [
              Flexible(
                child: Observer(
                  builder: (_) {
                    if (_previewStore.localTracks.isEmpty)
                      return CupertinoActivityIndicator();

                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      children: List.generate(
                          _previewStore.localTracks.length,
                              (index) => PeerItemOrganism(
                              key: UniqueKey(),
                              track: _previewStore.localTracks[index])),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (videoOn) {
                          await PlatformService.invokeMethod(
                              PlatformMethod.stopCapturing);
                          videoOn = false;
                        } else {
                          await PlatformService.invokeMethod(
                              PlatformMethod.startCapturing);
                          videoOn = true;
                        }
                        setState(() {});
                      },
                      child:
                      Icon(videoOn ? Icons.videocam : Icons.videocam_off),
                    ),
                  ),
                  Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (_) => MeetingPage(
                                  roomId: widget.roomId,
                                  flow: widget.flow,
                                  user: widget.user)));
                        },
                        child: Text("Join now"),
                      )),
                  Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await PlatformService.invokeMethod(
                              PlatformMethod.switchAudio,
                              arguments: {"is_on": audioOn});
                          audioOn = !audioOn;

                          setState(() {});
                        },
                        child: Icon(audioOn ? Icons.mic : Icons.mic_off),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}