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
      userName: map['userName'] as String,
      userId: map['userId'] as String,
      roomId: map['roomId'] as String,
      authToken: map['authToken'] as String,
      metaData: map['metaData'] as String?,
      endPoint: map['endPoint'] as String?,
      shouldSkipPIIEvents: map['shouldSkipPIIEvents'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': this.userName,
      'userId': this.userId,
      'roomId': this.roomId,
      'authToken': this.authToken,
      'metaData': this.metaData,
      'endPoint': this.endPoint,
      'shouldSkipPIIEvents': this.shouldSkipPIIEvents,
    };
  }


}
