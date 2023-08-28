///Package imports
import 'package:flutter/widgets.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hms_room_kit/src/screen_controller.dart';

///[HMSPrebuilt] is the main widget that is used to render the prebuilt
///It takes following parameters:
///[roomCode] - The room code of the room to join
///[options] - The options for the prebuilt for more details check the [HMSPrebuiltOptions] class
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
