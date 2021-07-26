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

  factory HMSConfig.fromMap(Map<String, dynamic> map) {
    return new HMSConfig(
      userName: map['user_name'] as String,
      userId: map['user_id'] as String,
      roomId: map['room_id'] as String,
      authToken: map['auth_token'] as String,
      metaData: map['meta_data'] as String?,
      endPoint: map['end_point'] as String?,
      shouldSkipPIIEvents: map['should_skip_pii_events'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
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
