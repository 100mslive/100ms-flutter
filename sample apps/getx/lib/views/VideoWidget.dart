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
        if (roomController.peerTrackList.length > index) {
          roomController.peerTrackList[index].update((val) {
            val?.isOffScreen = true;
          });
        }
      },
      child: Obx(() {
        var user = roomController.peerTrackList[index];
        return (user.value.hmsVideoTrack != null &&
                !user.value.hmsVideoTrack!.isMute)
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    VideoView(user.value.hmsVideoTrack!, user.value.peer.name),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        user.value.peer.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 36,
                          child: Text(
                            user.value.peer.name[0],
                            style: const TextStyle(
                                fontSize: 36, color: Colors.white),
                          )),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          user.value.peer.name,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ));
      }),
    );
  }
}
