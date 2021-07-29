import 'dart:convert';

import 'package:hmssdk_flutter_example/common/constant.dart';
import 'package:http/http.dart' as http;

class RoomService {
  Future<String> getToken({required String user, required String room}) async {
    http.Response response = await http.post(Uri.parse(Constant.getTokenURL),
        body: {'room_id': room, 'user_id': user, 'role': Constant.defaultRole});

    var body = json.decode(response.body);
    return body['token'];
  }
}
