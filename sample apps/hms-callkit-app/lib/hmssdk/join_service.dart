//Dart imports
import 'dart:convert';
import 'dart:developer';

//Package imports
import 'package:http/http.dart' as http;

Future<String?> getAuthToken(
    {required String roomId,
    required String tokenEndpoint,
    required String userId,
    required String role}) async {
  Uri endPoint = Uri.parse(tokenEndpoint);
  try {
    http.Response response = await http.post(endPoint,
        body: {'user_id': userId, 'room_id': roomId, 'role': role});
    var body = json.decode(response.body);
    return body['token'];
  } catch (e) {
    log(e.toString());
    return null;
  }
}
