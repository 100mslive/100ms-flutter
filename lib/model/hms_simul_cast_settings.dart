class HMSSimulCastSettings {
  final Map? low;
  final Map? med;
  final Map? high;

  HMSSimulCastSettings({this.low, this.med, this.high});

  factory HMSSimulCastSettings.fromMap(Map map) {
    return HMSSimulCastSettings(
        low: map['low'], med: map['med'], high: map['high']);
  }
}
