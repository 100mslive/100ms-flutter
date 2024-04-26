///[HLSStreamProperties] class defines the properties of the HLS stream.
class HLSStreamProperties {
  ///[rollingWindowTime] is the time interval for which user can seek the stream
  double? rollingWindowTime;

  ///[streamDuration] is the total duration of the stream generally null in case of live stream
  double? streamDuration;

  HLSStreamProperties({this.rollingWindowTime, this.streamDuration});

  factory HLSStreamProperties.fromMap(Map<dynamic, dynamic> map) {
    return HLSStreamProperties(
        rollingWindowTime: map['rolling_window_time'] != null
            ? map["rolling_window_time"].toDouble()
            : null,
        streamDuration: map['stream_duration'] != null
            ? map["stream_duration"].toDouble()
            : null);
  }
}
