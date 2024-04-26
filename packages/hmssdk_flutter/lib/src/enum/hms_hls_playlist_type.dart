///[HMSHLSPlaylistType] is an enum which defines the type of playlist to be used in the HLS stream.
enum HMSHLSPlaylistType { dvr, noDvr }

extension HMSHLSPlaylistTypeValues on HMSHLSPlaylistType {
  static HMSHLSPlaylistType getHMSHLSPlaylistTypeFromString(String? name) {
    switch (name) {
      case "dvr":
        return HMSHLSPlaylistType.dvr;
      case "noDvr":
        return HMSHLSPlaylistType.noDvr;
      default:
        return HMSHLSPlaylistType.noDvr;
    }
  }
}
