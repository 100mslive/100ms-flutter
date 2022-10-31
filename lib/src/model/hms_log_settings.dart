import '../enum/hms_log_level.dart';

class HMSLogSettings {
  final double maxDirSizeInBytes;
  final bool isLogStorageEnabled;
  final HMSLogLevel level;

  HMSLogSettings(
      {required this.maxDirSizeInBytes,
      required this.isLogStorageEnabled,
      required this.level});

  Map<String, dynamic> toMap() {
    return {
      'max_dir_size_in_bytes': maxDirSizeInBytes,
      'log_storage_enabled': isLogStorageEnabled,
      'log_level': HMSLogLevelValue.getValueFromHMSLogLevel(level)
    };
  }
}
