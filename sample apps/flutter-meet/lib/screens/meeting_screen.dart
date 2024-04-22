//Package imports
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:provider/provider.dart';

//File imports
import 'package:google_meet/models/data_store.dart';
import 'package:google_meet/services/sdk_initializer.dart';

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  bool isLocalAudioOn = true;
  bool isLocalVideoOn = true;
  final bool _isLoading = false;
  String? orientation;
  double width = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      width = MediaQuery.of(context).size.width;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isVideoOff = context.select<UserDataStore, bool>(
        (user) => user.remoteVideoTrack?.isMute ?? true);
    final _peer =
        context.select<UserDataStore, HMSPeer?>((user) => user.remotePeer);
    final remoteTrack = context
        .select<UserDataStore, HMSTrack?>((user) => user.remoteVideoTrack);
    final localTrack = context
        .select<UserDataStore, HMSVideoTrack?>((user) => user.localTrack);

    return WillPopScope(
      onWillPop: () async {
        context.read<UserDataStore>().leaveRoom();
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: (_isLoading)
              ? const CircularProgressIndicator()
              : (_peer == null)
                  ? Container(
                      color: Colors.black.withOpacity(0.9),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: [
                          Positioned(
                              child: IconButton(
                                  onPressed: () {
                                    context.read<UserDataStore>().leaveRoom();
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ))),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, bottom: 20),
                                child: Text(
                                  "You're the only one here",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Share meeting link with others",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "that you want in the meeting",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ],
                          ),
                          DraggableWidget(
                            topMargin: 10,
                            bottomMargin: 130,
                            horizontalSpace: 10,
                            child: localPeerTile(localTrack),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Container(
                              color: Colors.black.withOpacity(0.9),
                              child: _isVideoOff
                                  ? Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.blue.withAlpha(60),
                                                blurRadius: 10.0,
                                                spreadRadius: 2.0,
                                              ),
                                            ]),
                                        child: const Icon(
                                          Icons.videocam_off,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : (remoteTrack != null)
                                      ? Container(
                                          child: HMSVideoView(
                                            scaleType:
                                                ScaleType.SCALE_ASPECT_FILL,
                                            track: remoteTrack as HMSVideoTrack,
                                          ),
                                        )
                                      : const Center(child: Text("No Video"))),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      context.read<UserDataStore>().leaveRoom();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.red.withAlpha(60),
                                              blurRadius: 3.0,
                                              spreadRadius: 5.0,
                                            ),
                                          ]),
                                      child: const CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.red,
                                        child: Icon(Icons.call_end,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      SdkInitializer.hmssdk
                                          .toggleCameraMuteState(),
                                      setState(() {
                                        isLocalVideoOn = !isLocalVideoOn;
                                      })
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Colors.transparent.withOpacity(0.2),
                                      child: Icon(
                                        isLocalVideoOn
                                            ? Icons.videocam
                                            : Icons.videocam_off_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      SdkInitializer.hmssdk
                                          .toggleMicMuteState(),
                                      setState(() {
                                        isLocalAudioOn = !isLocalAudioOn;
                                      })
                                    },
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor:
                                          Colors.transparent.withOpacity(0.2),
                                      child: Icon(
                                        isLocalAudioOn
                                            ? Icons.mic
                                            : Icons.mic_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: () {
                                context.read<UserDataStore>().leaveRoom();
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                if (isLocalVideoOn) {
                                  SdkInitializer.hmssdk.switchCamera();
                                }
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.2),
                                child: const Icon(
                                  Icons.switch_camera_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          DraggableWidget(
                            topMargin: 10,
                            bottomMargin: 130,
                            horizontalSpace: 10,
                            child: localPeerTile(localTrack),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget localPeerTile(HMSVideoTrack? localTrack) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 150,
        width: 100,
        color: Colors.black,
        child: (isLocalVideoOn && localTrack != null)
            ? HMSVideoView(
                track: localTrack,
              )
            : const Icon(
                Icons.videocam_off_rounded,
                color: Colors.white,
              ),
      ),
    );
  }
}
