class HMSException {
  String description;
  String message;
  int code;
  String action;
  String name;

  HMSException(
      this.description, this.message, this.code, this.action, this.name);

  factory HMSException.fromMap(Map map) {
    print(1);
    return HMSException(
      map['description'],
      map['message'],
      map['code'],
      map['action'],
      map['name'],
    );
  }

  @override
  String toString() {
    return 'HMSExceptionPeer{description: $description, name: $name, message: $message, code: $code, action: $action, name: $name}';
  }
}
