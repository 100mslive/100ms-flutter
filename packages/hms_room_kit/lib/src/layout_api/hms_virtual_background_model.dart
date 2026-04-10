///Project imports
library;

///[VirtualBackgroundMediaType] enum representing the type of virtual background media
enum VirtualBackgroundMediaType {
  UNSPECIFIED,
  IMAGE,
  VIDEO,
}

///Extension to convert string to [VirtualBackgroundMediaType]
extension VirtualBackgroundMediaTypeValues on VirtualBackgroundMediaType {
  static VirtualBackgroundMediaType getMediaTypeFromString(String? type) {
    switch (type?.toUpperCase()) {
      case 'IMAGE':
        return VirtualBackgroundMediaType.IMAGE;
      case 'VIDEO':
        return VirtualBackgroundMediaType.VIDEO;
      default:
        return VirtualBackgroundMediaType.UNSPECIFIED;
    }
  }
}

///[VirtualBackgroundMedia] class representing a single virtual background media item
class VirtualBackgroundMedia {
  final String? url;
  final bool? isDefault;
  final VirtualBackgroundMediaType mediaType;

  VirtualBackgroundMedia({
    this.url,
    this.isDefault = false,
    this.mediaType = VirtualBackgroundMediaType.UNSPECIFIED,
  });

  factory VirtualBackgroundMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VirtualBackgroundMedia();
    }
    return VirtualBackgroundMedia(
      url: json['url'],
      isDefault: json['default'] ?? false,
      mediaType: VirtualBackgroundMediaTypeValues.getMediaTypeFromString(
        json['media_type'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'default': isDefault,
      'media_type': mediaType.toString().split('.').last,
    };
  }
}

///[VirtualBackground] class representing the virtual background configuration
class VirtualBackground {
  final List<VirtualBackgroundMedia>? backgroundMedia;

  VirtualBackground({this.backgroundMedia});

  factory VirtualBackground.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VirtualBackground();
    }

    List<VirtualBackgroundMedia>? media;
    if (json['background_media'] != null) {
      media = List<VirtualBackgroundMedia>.from(
        (json['background_media'] as List)
            .map((item) => VirtualBackgroundMedia.fromJson(item)),
      );
    }

    return VirtualBackground(backgroundMedia: media);
  }

  Map<String, dynamic> toJson() {
    return {
      'background_media':
          backgroundMedia?.map((media) => media.toJson()).toList(),
    };
  }

  ///Helper method to get only image backgrounds
  List<VirtualBackgroundMedia> getImageBackgrounds() {
    return backgroundMedia
            ?.where((media) =>
                media.mediaType == VirtualBackgroundMediaType.IMAGE &&
                media.url != null)
            .toList() ??
        [];
  }

  ///Helper method to get only video backgrounds
  List<VirtualBackgroundMedia> getVideoBackgrounds() {
    return backgroundMedia
            ?.where((media) =>
                media.mediaType == VirtualBackgroundMediaType.VIDEO &&
                media.url != null)
            .toList() ??
        [];
  }

  ///Helper method to get default background
  VirtualBackgroundMedia? getDefaultBackground() {
    return backgroundMedia?.firstWhere(
      (media) => media.isDefault == true,
      orElse: () => VirtualBackgroundMedia(),
    );
  }
}
