class HMSHLSPlayerStats {

  final double bandWidthEstimate;
  final int totalBytesLoaded;
  final double bufferedDuration;
  final double distanceFromLive;
  final double averageBitrate;
  final double videoHeight;
  final double videoWidth;
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
        bandWidthEstimate: (map["bandwidth_estimate"] is int)?map["bandwidth_estimate"].toDouble():map["bandwidth_estimate"],
        totalBytesLoaded: map["total_bytes_loaded"],
        bufferedDuration: (map["buffered_duration"] is int)?map["buffered_duration"].toDouble():map["buffered_duration"],
        distanceFromLive: (map["distance_from_live"] is int)?map["distance_from_live"].toDouble():map["distance_from_live"],
        droppedFrameCount: map["dropped_frame_count"],
        averageBitrate: (map["average_bitrate"] is int)?map["average_bitrate"].toDouble():map["average_bitrate"],
        videoHeight: (map["video_height"] is int)?map["video_height"].toDouble():map["video_height"] ,
        videoWidth: (map["video_width"] is int)?map["video_width"].toDouble():map["video_width"]
        );
  }
}

