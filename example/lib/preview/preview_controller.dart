import 'package:hmssdk_flutter/model/hms_config.dart';
import 'package:hmssdk_flutter/model/hms_preview_listener.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class PreviewController {
  final String roomId;
  final String user;
  HMSSDKInteractor? _hmsSdkInteractor;

  PreviewController({required this.roomId, required this.user})
      : _hmsSdkInteractor = HMSSDKInteractor();

  Future<void> startPreview() async {
    String token = await RoomService().getToken(user: user, room: roomId);
    HMSConfig config = HMSConfig(
        userId: Uuid().v1(), roomId: roomId, authToken: token, userName: user);

    _hmsSdkInteractor?.previewVideo(config: config);
  }

  void startListen(HMSPreviewListener listener) {
    _hmsSdkInteractor?.addPreviewListener(listener);
  }

  void stopCapturing() {
    _hmsSdkInteractor?.stopCapturing();
  }

  void startCapturing() {
    _hmsSdkInteractor?.startCapturing();
  }

  void switchAudio({bool isOn = false}) {
    _hmsSdkInteractor?.switchAudio(isOn: isOn);
  }
}
