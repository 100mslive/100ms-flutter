enum ScaleType { SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED }

///Video ScaleType [SCALE_ASPECT_FIT],[SCALE_ASPECT_FILL] and [SCALE_ASPECT_BALANCED].
extension ScalingTypeExtension on ScaleType {
  int get value {
    switch (this) {
      case ScaleType.SCALE_ASPECT_FIT:
        return 0;
      case ScaleType.SCALE_ASPECT_FILL:
        return 1;
      case ScaleType.SCALE_ASPECT_BALANCED:
        return 2;
    }
  }
}
