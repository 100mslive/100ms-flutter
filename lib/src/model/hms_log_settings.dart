import '../enum/hms_log_level.dart';

class HMSLogSettings {
  final double? maxDirSizeInBytes;
  final bool? isLogStorageEnabled;
  final HMSLogLevel? level;

  HMSLogSettings(
      {this.maxDirSizeInBytes = 2000,
      this.isLogStorageEnabled = true,
      this.level = HMSLogLevel.VERBOSE});

  Map<String, dynamic> toMap() {
    return {
      'max_dir_size_in_bytes': maxDirSizeInBytes,
      'log_storage_enabled': isLogStorageEnabled,
      'log_level':
          HMSLogLevelValue.getValueFromHMSLogLevel(level ?? HMSLogLevel.VERBOSE)
    };
  }
}
