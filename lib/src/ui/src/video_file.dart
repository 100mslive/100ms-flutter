import 'package:hmssdk_flutter/hmssdk_flutter.dart';

/// Class that represents a video loaded by the controller.
/// Contains the path of the video source [source], the [sourceType]
/// and the video info [info] from the video.
class VideoFile {
  /// Path of the source loaded.
  final String? source;

  /// Type of source loaded.
  final VideoSourceType? sourceType;

  /// Info related to the loaded file.
  final VideoInfo? info;

  /// Hidden constructor. Only the controller can
  /// create instances for this class.
  VideoFile({
    this.source,
    this.sourceType,
    this.info,
  });

  /// Hidden method.
  ///
  /// Creates a copy of the instance with the [changes]
  /// if the parameter is given.
  VideoFile copyWith({VideoFile? changes}) {
    if (changes == null) return this;
    return VideoFile(
      source: changes.source ?? source,
      sourceType: changes.sourceType ?? sourceType,
      info: changes.info ?? info,
    );
  }

  /// Equation operator. Compare this instance
  /// to the [other] instance.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoFile &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          sourceType == other.sourceType &&
          info == other.info;

  /// Computes the hashCode given the value of the attributes of this instance.
  @override
  int get hashCode => source.hashCode ^ sourceType.hashCode ^ info.hashCode;

  /// String representation of the instance.
  @override
  String toString() {
    return 'VideoFile{source: $source, sourceType: $sourceType, info: $info}';
  }
}

/// Class that contains info attributes of a video file.
/// Contains [height], the [width] and the [duration] of the file.
/// This class is loaded once the video is loaded in the player.
class VideoInfo {
  /// Height of the video file.
  final num? height;

  /// Width of the video file.
  final num? width;

  /// Duration in milliseconds of the file.
  final int? duration;

  /// Computes the aspect ratio if the [height] and [width] are not null.
  double get aspectRatio =>
      height != null && width != null && height! > 0 && width! > 0 //
          ? width! / height!
          : 4 / 3;

  /// Hidden constructor of the class. Only the controller
  /// can create an instance of this class.
  VideoInfo._({
    this.height,
    this.width,
    this.duration,
  });

  /// Factory to create an instance of this class given a JSON map.
  factory VideoInfo.fromJson(Map? map) {
    return map != null
        ? VideoInfo._(
            duration: map['duration'],
            height: map['height'],
            width: map['width'],
          )
        : VideoInfo._(
            duration: null,
            height: null,
            width: null,
          );
  }

  /// Equation operator. Compare this instance
  /// to the [other] instance.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoInfo &&
          runtimeType == other.runtimeType &&
          height == other.height &&
          width == other.width &&
          duration == other.duration;

  /// Computes the hashCode given the value of the attributes of this instance.
  @override
  int get hashCode => height.hashCode ^ width.hashCode ^ duration.hashCode;

  /// String representation of the instance.
  @override
  String toString() {
    return 'VideoInfo{height: $height, width: $width, duration: $duration}';
  }
}
