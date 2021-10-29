import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/meeting/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';

class PreviewController {
  final String roomId;
  final String user;
  HMSSDKInteractor? _hmsSdkInteractor;

  PreviewController({required this.roomId, required this.user})
      : _hmsSdkInteractor = HMSSDKInteractor();

  Future<bool> startPreview() async {
    List<String?>? token =
        await RoomService().getToken(user: user, room: roomId);

    if (token == null) return false;
    FirebaseCrashlytics.instance.setUserIdentifier(token[0]!);

    HMSConfig config = HMSConfig(
        userId: Uuid().v1(),
        authToken: token[0]!,
        userName: user,
        endPoint: token[1] == "true" ? null : "https://qa-init.100ms.live/init");

    _hmsSdkInteractor?.previewVideo(
        config: config,
        isProdLink: token[1] == "true" ? true : false,
        setWebRtcLogs: true);
    return true;
  }

  void startListen(HMSPreviewListener listener) {
    _hmsSdkInteractor?.addPreviewListener(listener);
  }

  void removeListener(HMSPreviewListener listener) {
    _hmsSdkInteractor?.removePreviewListener(listener);
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

  void addLogsListener(HMSLogListener hmsLogListener) {
    _hmsSdkInteractor?.addLogsListener(hmsLogListener);
  }

  void removeLogsListener(HMSLogListener hmsLogListener) {
    _hmsSdkInteractor?.removeLogsListener(hmsLogListener);
  }
}
