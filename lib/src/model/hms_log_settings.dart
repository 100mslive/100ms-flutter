import '../enum/hms_log_level.dart';

class HMSLogSettings {
  final double maxDirSizeInBytes;
  final bool isLogStorageEnabled;
  final HMSLogLevel level;

  HMSLogSettings(
      {this.maxDirSizeInBytes = 1000000,
      this.isLogStorageEnabled = false,
      this.level = HMSLogLevel.OFF});

  Map<String, dynamic> toMap() {
    return {
      'max_dir_size_in_bytes': maxDirSizeInBytes,
      'log_storage_enabled': isLogStorageEnabled,
      'log_level': HMSLogLevelValue.getValueFromHMSLogLevel(level)
    };
  }
}
