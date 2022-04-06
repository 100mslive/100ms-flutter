class HMSNetworkQuality {
  int quality;

  HMSNetworkQuality({required this.quality});

  Map<String, dynamic> toMap() {
    return {
      'quality': this.quality,
    };
  }

  factory HMSNetworkQuality.fromMap(Map map) {
    return HMSNetworkQuality(
      quality: map['quality'] as int,
    );
  }

  @override
  String toString() {
    return 'HMSNetworkQuality{quality: $quality}';
  }
}
