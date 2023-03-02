//dart imports
import 'dart:convert';

//Package imports
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/service/constant.dart';
import 'package:http/http.dart' as http;

class RoomService {
  Future<List<String?>?> getToken(
      {required String user, required String room}) async {
    Constant.meetingUrl = room;
    List<String?> codeAndDomain = getCode(room) ?? [];
    if (codeAndDomain.length == 0) {
      return null;
    }
    Constant.meetingCode = codeAndDomain[1] ?? '';
    Uri endPoint = codeAndDomain[2] == "true"
        ? Uri.parse(Constant.prodTokenEndpoint)
        : Uri.parse(Constant.qaTokenEndPoint);
    try {
      http.Response response = await http.post(endPoint, body: {
        'code': (codeAndDomain[1] ?? "").trim(),
        'user_id': user,
      }, headers: {
        'subdomain': (codeAndDomain[0] ?? "").trim()
      });

      var body = json.decode(response.body);
      return [body['token'], codeAndDomain[2]!.trim()];
    } catch (e) {
      var eToString = e.toString();
      var errorMsg = 'user: $user, room: $room, error: $eToString';
      return [errorMsg];
    }
  }

  List<String?>? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return [];
    if (!roomUrl.contains("app.100ms.live")) {
      return [];
    }
    url = url.trim();
    bool isQa = url.contains("qa-app");
    bool isProd = url.contains(".app");

    if (!isProd && !isQa) return [];

    List<String> codeAndDomain = [];
    String code = "";
    String subDomain = "";
    codeAndDomain =
        isProd ? url.split(".app.100ms.live") : url.split(".qa-app.100ms.live");
    code = codeAndDomain[1];
    subDomain = codeAndDomain[0]
            .split(roomUrl.contains("https") ? "https://" : "http://")[1] +
        (isProd ? ".app.100ms.live" : ".qa-app.100ms.live");
    if (code.contains("meeting"))
      code = code.split("/meeting/")[1];
    else
      code = code.split("/preview/")[1];
    return [subDomain, code, isProd ? "true" : "false"];
  }
}
