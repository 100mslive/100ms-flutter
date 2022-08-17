import 'dart:io';

import 'package:demo_with_getx_and_100ms/controllers/RoomController.dart';
import 'package:demo_with_getx_and_100ms/views/VideoWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomWidget extends StatelessWidget {
  final String meetingUrl;
  final String userName;

  late final RoomController roomController;

  RoomWidget(this.meetingUrl, this.userName, {Key? key}) : super(key: key) {
    roomController = Get.put(RoomController(meetingUrl, userName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<RoomController>(builder: (controller) {
        return ListView.builder(
          itemCount: controller.peerTrackList.length,
          itemBuilder: (ctx, index) {
            return Card(
                key: Key(controller.peerTrackList[index].value.peer.peerId
                    .toString()),
                child: SizedBox(
                    height: 250.0, child: VideoWidget(index, roomController)));
          },
        );
      }),
      bottomNavigationBar: GetX<RoomController>(builder: (controller) {
        return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(controller.isLocalAudioOn.value
                    ? Icons.mic
                    : Icons.mic_off),
                label: 'Mic',
              ),
              BottomNavigationBarItem(
                icon: Icon(controller.isLocalVideoOn.value
                    ? Icons.videocam
                    : Icons.videocam_off),
                label: 'Camera',
              ),
              //For screenshare in iOS follow the steps here : https://www.100ms.live/docs/flutter/v2/features/Screen-Share
              if (Platform.isAndroid)
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.screen_share,
                      color: (controller.isScreenShareActive.value)
                          ? Colors.green
                          : Colors.grey,
                    ),
                    label: "ScreenShare"),
              const BottomNavigationBarItem(
                icon: Icon(Icons.cancel),
                label: 'Leave Meeting',
              ),
            ],

            //New
            onTap: (index) => _onItemTapped(index));
      }),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        roomController.toggleAudio();
        break;
      case 1:
        roomController.toggleVideo();
        break;
      case 2:
        roomController.toggleScreenShare();
        break;
      case 3:
        roomController.leaveMeeting();
    }
  }
}
