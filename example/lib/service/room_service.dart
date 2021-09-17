import 'dart:convert';

import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:http/http.dart' as http;

class RoomService {
  Future<String?> getToken({required String user, required String room}) async {
    List<String> codeAndDomain = getCode(room);
    if(codeAndDomain.length==0){
      return null;
    }
    http.Response response = await http.post(codeAndDomain[2]=="true"?Uri.parse(Constant.prodTokenEndpoint):Uri.parse(Constant.qaTokenEndPoint),
        body: {
          'code': codeAndDomain[1],
          'user_id': user,
          'role': Constant.defaultRole
        },
        headers: {
          'subdomain': codeAndDomain[0]
        });

    var body = json.decode(response.body);
    return body['token'];
  }

  List<String> getCode(String roomUrl) {
    String url = roomUrl;
    url=url.trim();
    bool isProd = url.contains(".app.100ms.live/meeting/");
    bool isQa = url.contains(".qa-app.100ms.live/meeting/");
    print("${isProd}  ${isQa}");
    if (!isProd && !isQa) return [];

    List<String> codeAndDomain = [];
    String code = "";
    String subDomain = "";
    if (isProd) {
      codeAndDomain = url.split(".app.100ms.live/meeting/");
      code = codeAndDomain[1];
      subDomain =
          codeAndDomain[0].split("https://")[1] + ".app.100ms.live";
      print("$subDomain $code");
    } else if (isQa) {
      codeAndDomain = url.split(".qa-app.100ms.live/meeting/");
      code = codeAndDomain[1];
      subDomain =
          codeAndDomain[0].split("https://")[1] + ".qa-app.100ms.live";
    }
    return [subDomain, code,isProd?"true":"false"];
  }
}
