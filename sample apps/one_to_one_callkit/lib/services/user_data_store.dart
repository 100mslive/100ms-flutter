///Dart imports
import 'dart:developer';

///Package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

///Project imports
import 'package:one_to_one_callkit/call_type.dart';
import 'package:one_to_one_callkit/services/call_services.dart';
import 'package:one_to_one_callkit/services/user_data_model.dart';

///[UserDataStore] store all the information about a user
class UserDataStore extends ChangeNotifier {
  UserDataModel? currentUser;
  CollectionReference? userRef;
  UserDataStore({this.userRef}) {
    startNotifications();
  }

  List<UserDataModel> users = [];

  ///[getUsers] gets all the users.
  ///It adds the user to [users] list except
  ///the current user
  void getUsers() {
    userRef?.get().then((value) => value.docs.forEach((doc) {
          var element = doc.data() as Map?;
          if (element != null) {
            if (element["email"] != null &&
                element["user_name"] != null &&
                element["fcm_token"] != null) {
              if (element["email"] != currentUser?.email) {
                int index =
                    users.indexWhere((user) => user.email == element["email"]);
                if (index == -1) {
                  users.add(UserDataModel.fromMap(element));
                }
                notifyListeners();
              }
            }
          }
        }));
  }

  ///[setCurrentUser] sets the current user
  ///this is used later in the application
  void setCurrentUser(UserDataModel user) {
    currentUser = user;
  }

  ///[startNotifications] receives all the notifications when application is in foreground
  void startNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.data["body"] != null) {
        var body = CallServices.parseStringToMap(message.data["body"]);
        var roomCode = message.data["roomInfo"];
        CallType callType =
            message.data["callType"] == "1" ? CallType.video : CallType.audio;
        log("Callkit $body");
        log("Callkit: Received Foreground Notification $roomCode");
        CallServices.receiveCall(
          UserDataModel(
            email: body["email"],
            userName: body["user_name"],
            fcmToken: body["fcm_token"],
            imgUrl: body["img_url"],
          ),
          roomCode,
          callType,
        );
      }
    });
  }
}
