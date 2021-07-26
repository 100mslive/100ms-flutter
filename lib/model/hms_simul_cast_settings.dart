class HMSSimulCastSettings {
  final Map<String, String> low;
  final Map<String, String> med;
  final Map<String, String> high;

  HMSSimulCastSettings(
      {required this.low, required this.med, required this.high});

  factory HMSSimulCastSettings.fromMap(Map map) {
    return HMSSimulCastSettings(
        low: map['low'], med: map['med'], high: map['high']);
  }
}
