class HMSWhiteboardPermission {
  final bool admin;
  final bool write;
  final bool read;

  const HMSWhiteboardPermission(
      {required this.admin, required this.write, required this.read});

  factory HMSWhiteboardPermission.fromMap(Map map) {
    return HMSWhiteboardPermission(
        admin: map['admin'] ?? false,
        write: map['write'] ?? false,
        read: map['read'] ?? false);
  }
}
