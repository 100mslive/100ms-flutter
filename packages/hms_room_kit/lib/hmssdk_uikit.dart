library hmssdk_uikit;

import 'package:flutter/widgets.dart';
import 'package:hms_room_kit/hms_prebuilt_options.dart';
import 'package:hms_room_kit/screen_controller.dart';

export 'package:hms_room_kit/hmssdk_uikit.dart';

class HMSPrebuilt extends StatelessWidget {
  final String roomCode;
  final HMSPrebuiltOptions? hmsConfig;

  const HMSPrebuilt({super.key, required this.roomCode, this.hmsConfig});

  @override
  Widget build(BuildContext context) {
    return ScreenController(
      roomCode: roomCode,
      hmsConfig: hmsConfig,
    );
  }
}
