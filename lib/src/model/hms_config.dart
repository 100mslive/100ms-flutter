class HMSConfig {
  final String userName;
  final String userId;
  final String roomId;
  final String authToken;
  final String? metaData;
  final String? endPoint;
  final bool shouldSkipPIIEvents;

  HMSConfig(
      {this.userName = 'Flutter User',
      required this.userId,
      required this.roomId,
      required this.authToken,
      this.metaData,
      this.endPoint,
      this.shouldSkipPIIEvents = false});

  Map<String, dynamic> getJson() {
    return {
      'user_name': userName,
      'user_id': userId,
      'room_id': roomId,
      'auth_token': authToken,
      'meta_data': metaData,
      'should_skip_pii_events': shouldSkipPIIEvents,
      'end_point': endPoint
    };
  }
}
