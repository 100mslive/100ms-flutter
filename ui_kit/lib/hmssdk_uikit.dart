library hmssdk_uikit;

import 'package:flutter/widgets.dart';
import 'package:hmssdk_uikit/hms_prebuilt_options.dart';
import 'package:hmssdk_uikit/widgets/screen_controller.dart';

export 'package:hmssdk_uikit/hmssdk_uikit.dart';

class HMSRoomKit extends StatelessWidget {
  final String roomCode;
  final HMSPrebuiltOptions? hmsConfig;

  const HMSRoomKit({super.key, required this.roomCode, this.hmsConfig});

  @override
  Widget build(BuildContext context) {
    return ScreenController(roomCode: roomCode,hmsConfig: hmsConfig,);
  }
}
