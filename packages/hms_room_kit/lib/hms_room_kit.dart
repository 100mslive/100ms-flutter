library hmssdk_uikit;

import 'package:flutter/widgets.dart';
import 'package:hms_room_kit/hms_prebuilt_options.dart';
import 'package:hms_room_kit/screen_controller.dart';

export 'package:hms_room_kit/hms_room_kit.dart';

class HMSPrebuilt extends StatelessWidget {
  final String roomCode;
  final HMSPrebuiltOptions? options;

  const HMSPrebuilt({super.key, required this.roomCode, this.options});

  @override
  Widget build(BuildContext context) {
    return ScreenController(
      roomCode: roomCode,
      options: options,
    );
  }
}
