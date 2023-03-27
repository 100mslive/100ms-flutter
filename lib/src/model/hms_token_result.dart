///[HMSTokenResult] object contains the auth token to join a room and the token expiry time as a String
class HMSTokenResult {
  String? authToken;
  String? expiresAt;

  HMSTokenResult({this.authToken, this.expiresAt});

  factory HMSTokenResult.fromMap(Map map) {
    return HMSTokenResult(
        authToken: map.containsKey("auth_token") ? map["auth_token"] : null,
        expiresAt: map.containsKey("expires_at") ? map["expires_at"] : null);
  }
}
