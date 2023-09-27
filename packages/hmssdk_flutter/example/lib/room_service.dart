import 'dart:io';
import 'package:hms_room_kit/hms_room_kit.dart';

///This class is only for 100ms internal usage
/// and should not be edited
class RoomService {
  ///
  /// Let's understand the subdomain and code from the sample URL
  /// In this url: http://100ms-rocks.app.100ms.live/meeting/abc-defg-hij
  ///
  /// subdomain is 100ms-rocks
  /// code is abc-defg-ghi
  ///
  static List<String?>? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return [];
    url = url.trim();

    //This check is just for 100ms internal testing to be able to access QA rooms
    //For public rooms from dashboard it will always be a prod room
    bool isQa = url.contains("qa-app");
    bool isProd = url.contains(".app");

    if (!isProd && !isQa) return [];

    List<String> codeAndDomain = [];
    String code = "";
    codeAndDomain =
        isProd ? url.split(".app.100ms.live") : url.split(".qa-app.100ms.live");
    code = codeAndDomain[1];
    if (code.contains("meeting")) {
      code = code.split("/meeting/")[1];
    } else {
      code = code.split("/preview/")[1];
    }
    return [code, isProd ? "true" : "false"];
  }

  static Map<String, String> setEndPoints() {
    Map<String, String> endPoints = {};
    endPoints[Constant.tokenEndPointKey] =
        "https://auth-nonprod.100ms.live${Platform.isIOS ? "/" : ""}";
    endPoints[Constant.initEndPointKey] = "https://qa-init.100ms.live/init";
    endPoints[Constant.layoutAPIEndPointKey] = "https://api-nonprod.100ms.live";

    return endPoints;
  }
}
