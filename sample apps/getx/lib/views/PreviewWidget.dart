import 'package:demo_with_getx_and_100ms/controllers/PreviewController.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:get/get.dart';

import 'RoomWidget.dart';

class PreviewWidget extends StatelessWidget {
  final String meetingUrl;
  final String userName;

  late PreviewController previewController;

  PreviewWidget(this.meetingUrl, this.userName, {Key? key}) : super(key: key) {
    previewController = Get.put(PreviewController(meetingUrl, userName));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GetX<PreviewController>(builder: (controller) {
              return Container(
                child: controller.localTracks.isNotEmpty
                    ? SizedBox(
                        height: itemHeight,
                        width: itemWidth,
                        child: Stack(
                          children: [
                            (!controller.isLocalVideoOn.value ||
                                    controller.localTracks.isEmpty)
                                ? const Center(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        radius: 36,
                                        child: Text(
                                          "T",
                                          style: TextStyle(
                                              fontSize: 36,
                                              color: Colors.white),
                                        )),
                                  )
                                : HMSVideoView(
                                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                                    track: controller.localTracks[0],
                                    matchParent: false),
                            Positioned(
                              bottom: 20.0,
                              left: itemWidth / 2 - 50.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.all(14)),
                                onPressed: () {
                                  controller.removePreviewListener();
                                  Get.off(
                                      () => RoomWidget(meetingUrl, userName));
                                },
                                child: const Text(
                                  "Join Now",
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              right: 50.0,
                              child: GetX<PreviewController>(
                                  builder: (controller) {
                                return IconButton(
                                    onPressed: () {
                                      controller.toggleMicMuteState();
                                    },
                                    icon: Icon(
                                      controller.isLocalAudioOn.value
                                          ? Icons.mic
                                          : Icons.mic_off,
                                      size: 30.0,
                                      color: Colors.blue,
                                    ));
                              }),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 50.0,
                              child: GetX<PreviewController>(
                                  builder: (controller) {
                                return IconButton(
                                    onPressed: () {
                                      controller.toggleCameraMuteState();
                                    },
                                    icon: Icon(
                                      controller.isLocalVideoOn.value
                                          ? Icons.videocam
                                          : Icons.videocam_off,
                                      size: 30.0,
                                      color: Colors.blueAccent,
                                    ));
                              }),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: itemHeight / 1.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                          ),
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
