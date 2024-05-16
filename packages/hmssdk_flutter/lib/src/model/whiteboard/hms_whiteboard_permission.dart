///[HMSWhiteboardPermission] is a class that implements the permissions of a user in a whiteboard session.
class HMSWhiteboardPermission {
  ///[admin] is a boolean which tells if the user has admin permissions
  final bool admin;

  ///[write] is a boolean which tells if the user has permission to write/edit the whiteboard
  final bool write;

  ///[read] is a boolean which tells if the user has permission to read the whiteboard
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
