//Dart imports

//Package imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class JoinService {
  static Future<bool> join(HMSSDK hmssdk) async {
    String? roomCode =
        getCode("https://fluttersampleapp.app.100ms.live/meeting/zhr-seow-tuj");

    if (roomCode == null) return false;
    dynamic authToken = await hmssdk.getAuthTokenByRoomCode(roomCode: roomCode);

    if (authToken is String) {
      HMSConfig roomConfig = HMSConfig(
        authToken: authToken,
        userName: "user",
      );

      hmssdk.join(config: roomConfig);
    } else if (authToken is HMSException) {
      // Handle the error
      return false;
    }
    HMSConfig config = HMSConfig(authToken: authToken, userName: "user");
    await hmssdk.join(config: config);
    return true;
  }

  static String? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return null;
    url = url.trim();

    List<String> codeAndDomain = [];
    String code = "";
    codeAndDomain = url.split(".app.100ms.live");
    code = codeAndDomain[1];
    if (code.contains("meeting")) {
      code = code.split("/meeting/")[1];
    } else {
      code = code.split("/preview/")[1];
    }
    return code;
  }
}
