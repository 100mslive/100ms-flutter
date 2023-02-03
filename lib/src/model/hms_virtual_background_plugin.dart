import 'dart:typed_data';

/// For iOS Only
/// Virtual Background plugin helps in customising one’s background that replacing the background with a static image or blurring the background.
/// For More info visit [here]("").
class HMSVirtualBackgroundPlugin {
  Uint8List? backgroundImage;
  int blurRadius;

  HMSVirtualBackgroundPlugin(
      {required this.backgroundImage, this.blurRadius = 0});

  Map<String, dynamic> toMap() {
    return {'background_image': backgroundImage, 'blur_radius': blurRadius};
  }
}
