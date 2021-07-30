import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/common/platform_methods.dart';
import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_peer.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
import 'package:hmssdk_flutter/service/platform_service.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/peer_item_organism.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/meeting/meeting_page.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class HMSPreview extends StatefulWidget {
  final String roomId;
  final MeetingFlow flow;
  final String user;

  const HMSPreview(
      {Key? key, required this.roomId, required this.flow, required this.user})
      : super(key: key);

  @override
  _HMSPreviewState createState() => _HMSPreviewState();
}

class _HMSPreviewState extends State<HMSPreview> {
  HMSTrack? hmsTrack;

  @override
  void initState() {
    super.initState();
    initHMSTrack();
  }

  void initHMSTrack() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      String token =
          await RoomService().getToken(user: widget.user, room: widget.roomId);
      HMSConfig hmsConfig = HMSConfig(
          userId: Uuid().v1(),
          roomId: widget.roomId,
          authToken: token,
          // endPoint: Constant.getTokenURL,
          userName: widget.user);
      var response = await PlatformService.invokeMethod(
          PlatformMethod.previewVideo,
          arguments: hmsConfig.getJson());
      //debugPrint(response+"AAAAAAAAAAAAAAAAAAA");
      this.hmsTrack = HMSTrack.fromMap(
          response['data']['track'], HMSPeer.fromMap(response['data']['peer']));
      setState(() {});
    });
    listen();
  }

  listen() {
    PlatformService.listenToPlatformCalls().listen((event) {
      if (event.method == PlatformMethod.previewVideo) {
        print('a');
      }
    });
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
              hmsTrack != null
                  ? Container(
                      child: PeerItemOrganism(track: hmsTrack!),
                      height: 400.0,
                      width: 500.0,
                    )
                  : CircularProgressIndicator(),
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
                      child: RaisedButton(
                    onPressed: () {
                      debugPrint("asdad");
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
