import 'dart:convert';
import 'constants.dart';
import 'package:http/http.dart' as http;

class RoomService {
  //This function gets the token from the meeting URL
  Future<String?> getToken({required String user, required String room}) async {
    Constant.meetingUrl = room;

    //codeAndDomain stores the subDomain & code
    List<String?> codeAndDomain = getCode(room) ?? [];
    if (codeAndDomain.isEmpty) {
      return null;
    }

    /** 
     * Let's understand the subdomain and code from the sample URL 
     * In this url: http://100ms-rocks.app.100ms.live/meeting/abc-def-ghi 
     * 
     * subdomain is 100ms-rocks
     * code is abc-def-ghi
    */
    Constant.meetingCode = codeAndDomain[1] ?? '';
    Uri endPoint = Uri.parse(Constant.tokenEndpoint);
    http.Response response = await http.post(endPoint, body: {
      'code': (codeAndDomain[1] ?? "").trim(),
      'user_id': user,
    }, headers: {
      'subdomain': (codeAndDomain[0] ?? "").trim()
    });

    //This is the response returned from above HTTP call
    var body = json.decode(response.body);
    return body['token'];
  }

//This function returns the subDomain and code from the URL we provided to join the room
  List<String?>? getCode(String roomUrl) {
    String url = roomUrl;
    if (url == "") return [];
    url = url.trim();

    List<String> codeAndDomain = [];
    String code = "";
    String subDomain = "";
    codeAndDomain = url.split(".app.100ms.live");
    code = codeAndDomain[1];
    subDomain = codeAndDomain[0]
            .split(roomUrl.contains("https") ? "https://" : "http://")[1] +
        (".app.100ms.live");
    if (code.contains("meeting")) {
      code = code.split("/meeting/")[1];
    } else {
      code = code.split("/preview/")[1];
    }
    return [subDomain, code];
  }
}
