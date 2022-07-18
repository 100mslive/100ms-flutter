import 'package:demo_with_getx_and_100ms/controllers/RoomController.dart';
import 'package:demo_with_getx_and_100ms/views/VideoView.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';

class VideoWidget extends StatelessWidget {
  final int index;
  final RoomController roomController;

  const VideoWidget(this.index, this.roomController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        roomController.peerTrackList[index].update((val) {
          val?.isOffScreen = false;
        });
      },
      onFocusLost: () {
        roomController.peerTrackList[index].update((val) {
          val?.isOffScreen = true;
        });
      },
      child: Obx(() {
        var user = roomController.peerTrackList[index];
        return (user.value.peer.isLocal
                ? roomController.isLocalVideoOn.value
                : !user.value.isMute)
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      width: 400.0,
                      child: VideoView(
                          user.value.hmsVideoTrack, user.value.peer.name),
                    ),
                    Text(
                      user.value.peer.name,
                    )
                  ],
                ),
              )
            : Container(
                height: 200.0,
                width: 400.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 36,
                        child: Text(
                          user.value.peer.name[0],
                          style: const TextStyle(
                              fontSize: 36, color: Colors.white),
                        )),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      user.value.peer.name,
                    )
                  ],
                ));
      }),
    );
  }
}
