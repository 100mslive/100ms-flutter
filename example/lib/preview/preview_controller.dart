import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/manager/HmsSdkManager.dart';
import 'package:hmssdk_flutter_example/service/room_service.dart';
import 'package:uuid/uuid.dart';
import 'package:hmssdk_flutter_example/common/constant.dart';

class PreviewController {
  final String roomId;
  final String user;

  PreviewController({required this.roomId, required this.user});

  Future<String?> startPreview() async {
    List<String?> codeAndDomain = getCode(roomId) ?? [];
    Constant.meetingUrl = roomId;
    var body =
        await RoomService().getToken(user: user, codeAndDomain: codeAndDomain);
    if (!body.contains('token')) {
      return body;
    } else if (body['token'] == null) {
      return body;
    }
    // String? endPoints = codeAndDomain[0];
    String token = body['token'];
    FirebaseCrashlytics.instance.setUserIdentifier(token);
    HMSConfig config = HMSConfig(
      userId: Uuid().v1(),
      authToken: token,
      userName: user,
    );
    // endPoint: codeAndDomain[2]!.trim() == "true" ? "" : "https://qa-init.100ms.live/init");

    HmsSdkManager.hmsSdkInteractor?.previewVideo(
      config: config,
    );
    return null;
  }

  List<String?>? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return [];
    url = url.trim();
    bool isProdM = url.contains(".app.100ms.live/meeting/");
    bool isProdP = url.contains(".app.100ms.live/preview/");
    bool isQaM = url.contains(".qa-app.100ms.live/meeting/");
    bool isQaP = url.contains(".qa-app.100ms.live/preview/");

    if (!isProdM && !isQaM && isQaP && isProdP) return [];

    List<String> codeAndDomain = [];
    String code = "";
    String subDomain = "";
    if (isProdM || isProdP) {
      codeAndDomain = isProdM
          ? url.split(".app.100ms.live/meeting/")
          : url.split(".app.100ms.live/preview/");
      code = codeAndDomain[1];
      subDomain = codeAndDomain[0].split("https://")[1] + ".app.100ms.live";
      print("$subDomain $code");
    } else if (isQaM || isQaP) {
      codeAndDomain = isQaM
          ? url.split(".qa-app.100ms.live/meeting/")
          : url.split(".qa-app.100ms.live/preview/");
      code = codeAndDomain[1];
      subDomain = codeAndDomain[0].split("https://")[1] + ".qa-app.100ms.live";
      print("$subDomain $code");
    }
    return [subDomain, code, isProdM || isProdP ? "true" : "false"];
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
