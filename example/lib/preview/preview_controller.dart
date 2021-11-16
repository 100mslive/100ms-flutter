import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/manager/HmsSdkManager.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class PreviewController {
  final String roomId;
  final String user;

  PreviewController({required this.roomId, required this.user});

  Future<bool> startPreview() async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomId);

    if (token == null) return false;
    FirebaseCrashlytics.instance.setUserIdentifier(token[0]!);

    HMSConfig config = HMSConfig(
        userId: Uuid().v1(),
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? "" : "https://qa-init.100ms.live/init");

    HmsSdkManager.hmsSdkInteractor?.previewVideo(
      config: config,
    );
    return true;
  }

  void startListen(HMSPreviewListener listener) {
    HmsSdkManager.hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removeListener(HMSPreviewListener listener) {
    HmsSdkManager.hmsSdkInteractor?.removePreviewListener(listener);
  }

  void stopCapturing() {
    HmsSdkManager.hmsSdkInteractor?.stopCapturing();
  }

  void startCapturing() {
    HmsSdkManager.hmsSdkInteractor?.startCapturing();
  }

  void switchAudio({bool isOn = false}) {
    HmsSdkManager.hmsSdkInteractor?.switchAudio(isOn: isOn);
  }

  void addLogsListener(HMSLogListener hmsLogListener) {
    HmsSdkManager.hmsSdkInteractor?.addLogsListener(hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    HmsSdkManager.hmsSdkInteractor?.removeLogsListener(hmsLogListener);
  }
}
