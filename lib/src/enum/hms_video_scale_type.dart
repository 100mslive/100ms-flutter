enum ScalingType { SCALE_ASPECT_FIT, SCALE_ASPECT_FILL, SCALE_ASPECT_BALANCED }

extension ScalingTypeExtension on ScalingType {
  int get value {
    switch (this) {
      case ScalingType.SCALE_ASPECT_FIT:
        return 0;
      case ScalingType.SCALE_ASPECT_FILL:
        return 1;
      case ScalingType.SCALE_ASPECT_BALANCED:
        return 2;
    }
  }
}
