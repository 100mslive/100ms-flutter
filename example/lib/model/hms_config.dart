class HMSConfig {
  final String userName;
  final String userId;
  final String roomId;
  final String authToken;
  final String? metaData;
  final String? endpoint;
  final bool shouldSkipPIIEvents;

  HMSConfig(
      {this.userName = 'Flutter User',
      required this.userId,
      required this.roomId,
      required this.authToken,
      this.metaData,
      this.endpoint,
      this.shouldSkipPIIEvents = false});
}
