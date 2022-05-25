import 'package:demo_with_getx_and_100ms/controllers/RoomController.dart';
import 'package:demo_with_getx_and_100ms/views/HomePage.dart';
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
    return WillPopScope(
      onWillPop: () async {
        Get.dialog(
          AlertDialog(
            title: const Text('Leave Meeting?'),
            actions: [
              TextButton(
                child: const Text("No"),
                onPressed: () => Get.back(),
              ),
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  roomController.leaveMeeting();
                },
              ),
            ],
          ),
        );
        return true;
      },
      child: Scaffold(
        body: GetX<RoomController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (ctx, index) {
                return Card(
                    child: SizedBox(height: 250.0, child: VideoWidget(index)));
              });
        }),
        bottomNavigationBar: GetX<RoomController>(builder: (controller) {
          return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black,
              selectedItemColor: Colors.greenAccent,
              unselectedItemColor: Colors.grey,
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.cancel),
                  label: 'Leave Meeting',
                ),
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
              ],

              //New
              onTap: _onItemTapped);
        }),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      roomController.leaveMeeting();
    } else if (index == 1) {
      roomController.toggleAudio();
    } else {
      roomController.toggleVideo();
    }
  }
}
