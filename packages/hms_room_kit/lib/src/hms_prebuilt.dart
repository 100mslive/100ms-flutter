import 'package:flutter/widgets.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/screen_controller.dart';

class HMSPrebuilt extends StatelessWidget {
  ///The room code of the room to join
  final String roomCode;

  ///The options for the prebuilt
  ///For more details checkout the [HMSPrebuiltOptions] class
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
