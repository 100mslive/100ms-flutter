///[UserDataModel] is a model class that holds the user data.
class UserDataModel {
  final String email;
  final String userName;
  final String fcmToken;
  final String? imgUrl;

  UserDataModel(
      {required this.email,
      required this.userName,
      required this.fcmToken,
      this.imgUrl});

  factory UserDataModel.fromMap(Map map) {
    return UserDataModel(
        email: map["email"],
        userName: map["user_name"],
        fcmToken: map["fcm_token"],
        imgUrl: map["img_url"]);
  }

  Map<String, String?> toMap() {
    return {
      "email": email,
      "user_name": userName,
      "fcm_token": fcmToken,
      "img_url": imgUrl
    };
  }
}
