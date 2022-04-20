class HMSVideoResolution {
  final int height;
  final int width;

  HMSVideoResolution({required this.height, required this.width});

  factory HMSVideoResolution.fromMap(Map map) {
    return HMSVideoResolution(height: map['height'], width: map['width']);
  }

  Map<String, dynamic> toMap() {
    return {'height': height, 'width': width};
  }
}
