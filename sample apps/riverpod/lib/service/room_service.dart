//dart imports
import 'dart:convert';

//Package imports
import 'package:http/http.dart' as http;

class RoomService {
  Future<List<String?>?> getToken(
      {required String user, required String room}) async {
    List<String?> codeAndDomain = getCode(room) ?? [];
    if (codeAndDomain.isEmpty) {
      return null;
    }
    Uri endPoint = codeAndDomain[2] == "true"
        ? Uri.parse("https://prod-in.100ms.live/hmsapi/get-token")
        : Uri.parse("https://qa-in.100ms.live/hmsapi/get-token");
    http.Response response = await http.post(endPoint, body: {
      'code': (codeAndDomain[1] ?? "").trim(),
      'user_id': user,
    }, headers: {
      'subdomain': (codeAndDomain[0] ?? "").trim()
    });

    var body = json.decode(response.body);
    return [body['token'], codeAndDomain[2]!.trim()];
  }

  List<String?>? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return [];
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
    if (code.contains("meeting")) {
      code = code.split("/meeting/")[1];
    } else {
      code = code.split("/preview/")[1];
    }
    return [subDomain, code, isProd ? "true" : "false"];
  }
}
