enum HMSStatsListenerMethod {
  onLocalAudioStats,
  onLocalVideoStats,
  onRemoteAudioStats,
  onRemoteVideoStats,
  onRtcStats,
  unknown
}

extension HMSStatsListenerMethodValues on HMSStatsListenerMethod {
  static HMSStatsListenerMethod getMethodFromName(String name) {
    switch (name) {
      case 'on_local_audio_stats':
        return HMSStatsListenerMethod.onLocalAudioStats;
      case 'on_local_video_stats':
        return HMSStatsListenerMethod.onLocalVideoStats;
      case 'on_remote_audio_stats':
        return HMSStatsListenerMethod.onRemoteAudioStats;
      case 'on_remote_video_stats':
        return HMSStatsListenerMethod.onRemoteVideoStats;
      case 'on_rtc_stats_report':
        return HMSStatsListenerMethod.onRtcStats;
      default:
        return HMSStatsListenerMethod.unknown;
    }
  }
}
