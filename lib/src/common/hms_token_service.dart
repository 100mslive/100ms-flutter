import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter/src/service/platform_service.dart';

class HMSTokenService {
  ///[getAuthTokenByRoomCode] is used to get the authentication token to join the room
  ///
  ///This returns an object of Future<dynamic> which can be either
  ///of HMSException type or HMSTokenResult type
  static Future<dynamic> getAuthTokenByRoomCode(
      {required String roomCode, String? userId, String? endPoint}) async {
    var arguments = {
      "room_code": roomCode,
      "user_id": userId,
      "endPoint": endPoint
    };
    var result = await PlatformService.invokeMethod(
        PlatformMethod.getAuthTokenByRoomCode,
        arguments: arguments);

    if (result["success"]) {
      return HMSTokenResult.fromMap(result["data"]);
    } else {
      return HMSException.fromMap(result["data"]["error"]);
    }
  }
}
