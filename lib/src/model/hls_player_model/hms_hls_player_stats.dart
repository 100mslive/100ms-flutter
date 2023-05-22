class HMSHLSPlayerStats {
  final Bandwidth bandwidth;
  final int bufferedDuration;
  final int distanceFromLive;
  final FrameInfo frameInfo;
  final VideoInfo videoInfo;

  HMSHLSPlayerStats(
      {required this.bandwidth,
      required this.bufferedDuration,
      required this.distanceFromLive,
      required this.frameInfo,
      required this.videoInfo});

  factory HMSHLSPlayerStats.fromMap(Map map) {
    return HMSHLSPlayerStats(
        bandwidth: Bandwidth.fromMap(map["bandwidth"]),
        bufferedDuration: map["buffered_duration"],
        distanceFromLive: map["distance_from_live"],
        frameInfo: FrameInfo.fromMap(map["frame_info"]),
        videoInfo: VideoInfo.fromMap(map["video_info"]));
  }
}

class Bandwidth {
  final int bandWidthEstimate;
  final int totalBytesLoaded;

  Bandwidth({required this.bandWidthEstimate, required this.totalBytesLoaded});

  factory Bandwidth.fromMap(Map map) {
    return Bandwidth(
        bandWidthEstimate: map["bandwidth_estimate"],
        totalBytesLoaded: map["total_bytes_loaded"]);
  }
}

class FrameInfo {
  final int droppedFrameCount;
  final int totalFrameCount;

  FrameInfo({required this.droppedFrameCount, required this.totalFrameCount});

  factory FrameInfo.fromMap(Map map) {
    return FrameInfo(
        droppedFrameCount: map["dropped_frame_count"],
        totalFrameCount: map["total_frame_count"]);
  }
}

class VideoInfo {
  final int averageBitrate;
  final double frameRate;
  final int videoHeight;
  final int videoWidth;

  VideoInfo(
      {required this.averageBitrate,
      required this.frameRate,
      required this.videoHeight,
      required this.videoWidth});

  factory VideoInfo.fromMap(Map map) {
    return VideoInfo(
        averageBitrate: map["average_bitrate"],
        frameRate: map["frame_rate"],
        videoHeight: map["video_height"],
        videoWidth: map["video_width"]);
  }
}
