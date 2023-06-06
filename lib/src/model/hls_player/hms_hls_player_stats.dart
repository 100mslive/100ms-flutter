/// 100ms HMSHLSPlayerStats
///
///[HMSHLSPlayerStats] is a data class, confirming to the HLSPlayerStats
///
///Whenever the player stats are attached, we get an object of [HMSHLSPlayerStats] in [onHLSEventUpdate] callback.
class HMSHLSPlayerStats {
  /// The current bandwidth, as estimated by the player
  final double bandWidthEstimate;

  /// The total bytes downloaded within the given poll duration
  final int totalBytesLoaded;

  /// An estimate of the total buffered duration from the current position
  final double bufferedDuration;

  /// Distance of current playing position from live edge
  final double distanceFromLive;

  /// bitrate of the current layer being played
  final double averageBitrate;

  /// The height of the video
  final double videoHeight;

  /// The width of the video
  final double videoWidth;

  /// The number of dropped frames since the last call to this method
  final int droppedFrameCount;

  HMSHLSPlayerStats(
      {required this.bandWidthEstimate,
      required this.totalBytesLoaded,
      required this.bufferedDuration,
      required this.distanceFromLive,
      required this.averageBitrate,
      required this.droppedFrameCount,
      required this.videoHeight,
      required this.videoWidth});

  factory HMSHLSPlayerStats.fromMap(Map map) {
    return HMSHLSPlayerStats(
        bandWidthEstimate: (map["bandwidth_estimate"] is int)
            ? map["bandwidth_estimate"].toDouble()
            : map["bandwidth_estimate"],
        totalBytesLoaded: map["total_bytes_loaded"],
        bufferedDuration: (map["buffered_duration"] is int)
            ? map["buffered_duration"].toDouble()
            : map["buffered_duration"],
        distanceFromLive: (map["distance_from_live"] is int)
            ? map["distance_from_live"].toDouble()
            : map["distance_from_live"],
        droppedFrameCount: map["dropped_frame_count"],
        averageBitrate: (map["average_bitrate"] is int)
            ? map["average_bitrate"].toDouble()
            : map["average_bitrate"],
        videoHeight: (map["video_height"] is int)
            ? map["video_height"].toDouble()
            : map["video_height"],
        videoWidth: (map["video_width"] is int)
            ? map["video_width"].toDouble()
            : map["video_width"]);
  }
}
