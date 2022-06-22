///100ms HMSVideoResolution
///
///[HMSResolution] contains height and width of peer's video.
class HMSResolution {
  final double height;
  final double width;

  HMSResolution({required this.height, required this.width});

  factory HMSResolution.fromMap(Map map) {
    return HMSResolution(height: map['height'], width: map['width']);
  }

  Map<String, dynamic> toMap() {
    return {'height': height, 'width': width};
  }
}
