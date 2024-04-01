///Dart imports
import 'dart:io';
import 'dart:developer';

///Package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

///Project imports
import 'package:one_to_one_callkit/call_type.dart';
import 'package:one_to_one_callkit/services/app_router.dart';
import 'package:one_to_one_callkit/services/call_services.dart';
import 'package:one_to_one_callkit/services/navigation_service.dart';
import 'package:one_to_one_callkit/services/user_data_model.dart';
import 'package:one_to_one_callkit/services/user_data_store.dart';
import 'package:one_to_one_callkit/user_role.dart';

///[AppUtilities] class is used to define the utility functions of the application
class AppUtilities {
  FirebaseFirestore? _dbConnection;
  CollectionReference? _users;
  FirebaseMessaging? _firebaseMessaging;
  String? _fcmToken;
  UserDataStore? _userDataStore;
  HttpsCallable? firebaseFunctions;
  bool isUserLoggedIn = false;
  UserDataModel? currentUser;
  Map<String, dynamic> roomCodesMap = {};

  AppUtilities() {
    _dbConnection = FirebaseFirestore.instance;
    _firebaseMessaging = FirebaseMessaging.instance;
    setFcmToken();
    _users = _dbConnection?.collection('users');
    _userDataStore = UserDataStore(userRef: _users);
    firebaseFunctions =
        FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    getPermissions();
  }

  UserDataStore? get userDataStore => _userDataStore;

  ///Function to get notification permission
  void getPermissions() async {
    NotificationSettings? settings =
        await _firebaseMessaging?.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FlutterCallkitIncoming.requestNotificationPermission({
      "rationaleMessagePermission":
          "Notification permission is required, to show notification.",
      "postNotificationMessageRequired":
          "Notification permission is required, Please allow notification permission from setting."
    });

    log('Callkit: User granted permission: ${settings?.authorizationStatus}');
  }

  ///[loginUser] function handles the login functionality
  Future<UserCredential> loginUser() async {
    ///Here we set the scopes for the google sign in
    ///We set the scopes to email and user profile
    ///Scopes handles what all details can be accessed after google signIn
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ];

    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          Platform.isAndroid ? null : "Enter authentication client id here",
      scopes: scopes,
    );
    GoogleSignInAccount? result = await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await result!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  ///[signUpUser] handles the signup functionality
  Future<bool> signUpUser(
      {required String userName,
      required String email,
      required String imgUrl}) async {
    bool isUserPresent = await doesUserExist(email: email);

    ///Here if the user is not present we add the user to the database
    if (!isUserPresent && _fcmToken != null) {
      UserDataModel user = UserDataModel(
          email: email,
          userName: userName,
          fcmToken: _fcmToken!,
          imgUrl: imgUrl);
      _users?.add({
        "email": email,
        "user_name": userName,
        "fcm_token": _fcmToken,
        "img_url": imgUrl,
        "is_busy": false
      }).then((DocumentReference doc) {
        ///Setting the current user
        ///and getting the users list
        setCurrentUser(user: user);
        log('DocumentSnapshot added with ID: ${doc.id}');
        if (_users != null) {
          userDataStore?.getUsers();
        }
        return true;
      }).onError((error, stackTrace) {
        log(error.toString());
        return false;
      });
    } else {
      ///Here if the user is already present we update the FCM token
      setLoggedInUserFCM(userName: userName, email: email, imgUrl: imgUrl);
    }
    return false;
  }

  ///[setLoggedInUserFCM] function sets the FCM token for the logged in user
  void setLoggedInUserFCM(
      {required String? userName,
      required String? email,
      required String? imgUrl}) async {
    log("Callkit: Setting logged in user FCM, Name: $userName, email: $email, imgUrl: $imgUrl");
    if (userName == null || email == null || imgUrl == null) {
      return;
    }

    ///Here we check if the FCM token is null
    if (_fcmToken == null) {
      await setFcmToken();
    }

    ///Here we set the FCM token for the user
    if (_fcmToken != null) {
      setCurrentUser(
          user: UserDataModel(
              email: email,
              userName: userName,
              fcmToken: _fcmToken!,
              imgUrl: imgUrl));

      ///Here we check if the user is already present in the database
      ///If the user is present we update the FCM token
      ///If the user is not present we add the user to the database
      ///and get the users list
      ///This is done to ensure that the user is present in the database
      QuerySnapshot? data =
          await _users?.where("email", isEqualTo: email).get();
      if (data?.docs.isEmpty ?? true) {
        signUpUser(userName: userName, email: email, imgUrl: imgUrl);
      }
      data?.docs.forEach((doc) {
        _users?.doc(doc.id).update({"fcm_token": _fcmToken});
      });
      userDataStore?.getUsers();
    }
  }

  ///[getUsers] function gets the users list from the database
  void getUsers() {
    if (_users != null) {
      _userDataStore?.getUsers();
    }
  }

  ///[setCurrentUser] function sets the current user
  void setCurrentUser({required UserDataModel user}) {
    currentUser = user;
    userDataStore?.setCurrentUser(user);
  }

  ///[checkIfUserIsBusy] function checks if the user is busy in another call
  ///If the user is busy we return true
  ///If the user is not busy we return false
  ///This is done to ensure that the user is not busy in another call
  ///before making a new call
  ///This is not implemented in the current version
  Future<bool> checkIfUserIsBusy(UserDataModel user) async {
    bool isBusy = false;
    var data = await _users?.where("email", isEqualTo: user.email).get();
    data?.docs.forEach((doc) {
      var element = doc.data() as Map?;
      if (element != null) {
        if (element["is_busy"] ?? false) {
          isBusy = true;
          return;
        }
      }
    });
    return isBusy;
  }

  ///[setUserState] function sets the user state
  ///If the user is busy we set the user state to true
  ///If the user is not busy we set the user state to false
  void setUserState(UserDataModel user, {required bool isBusy}) async {
    QuerySnapshot? data =
        await _users?.where("email", isEqualTo: user.email).get();
    if (data?.docs.isNotEmpty ?? false) {
      data?.docs.forEach((doc) {
        _users?.doc(doc.id).update({"is_busy": isBusy});
      });
    }
  }

  ///[sendMessage] function sends the message to the user
  void sendMessage(UserDataModel user, CallType type) async {
    ///Currently not implementing the user is busy indicator
    // var isUserBusy = await checkIfUserIsBusy(user);
    // if (!isUserBusy) {
    // setUserState(currentUser!, isBusy: true);
    createRoom(user, type);
    NavigationService.instance.pushNamedIfNotCurrent(AppRoute.loadingPage);
    // } else {
    //   log("Callkit: User is busy");
    // }
  }

  ///[createRoom] function creates the room for the call
  ///We use the Firebase functions to create the room
  ///We pass the room name and the template id to the Firebase function
  ///The Firebase function returns the room codes for the speaker and the listener
  ///We then send the notification to the listener with the room code
  ///We then start the call
  void createRoom(UserDataModel user, CallType type) {
    log("Callkit: Creating Room");
    try {
      FirebaseFunctions.instance
          .httpsCallable("createRoom")
          .call(<String, dynamic>{
        'roomName': 'callkit_${const Uuid().v4()}',
        'templateId': type == CallType.audio
            ? 'Enter audio room template id here'
            : 'Enter video conferencing room template id here'
      }).then((value) {
        getRoomCodes(value.data, user, type);
      });
    } on FirebaseFunctionsException catch (e) {
      log("Firebase Error $e");
    } catch (e) {
      log("Error $e");
    }
  }

  ///[getRoomCodes] function gets the room codes for the speaker and the listener
  void getRoomCodes(
      Map<String, dynamic> jsonData, UserDataModel user, CallType type) {
    for (var item in jsonData['data']) {
      String role = item['role'];
      String code = item['code'];
      roomCodesMap[role] = code;
    }

    ///Here we send the notification to the listener
    ///We pass the room code, the message title and the message body
    ///We also pass the call type i.e. audio or video
    ///We then start the call
    firebaseFunctions?.call(<String, dynamic>{
      "targetDevices": user.fcmToken,
      "messageTitle": "${currentUser?.userName} is calling",
      "messageBody": currentUser?.toMap().toString(),
      "roomCode": roomCodesMap[UserRole.listener],
      "callType": type == CallType.video ? "1" : "0"
    });
    log("Callkit: Fetched RoomCodes $roomCodesMap");

    CallServices.startCall(user, type, roomCodesMap[UserRole.speaker]);
  }

  ///[doesUserExist] function checks if the user already exists in the database
  Future<bool> doesUserExist({required String email}) async {
    QuerySnapshot? data = await _users?.where("email", isEqualTo: email).get();
    if (data?.docs.isNotEmpty ?? false) {
      log("Callkit: User already exist");
      return true;
    } else {
      return false;
    }
  }

  ///[setFcmToken] function sets the FCM token
  Future<void> setFcmToken() async {
    if (Platform.isIOS) {
      String? isAPNSToken = await _firebaseMessaging?.getAPNSToken();
      if (isAPNSToken == null) {
        return;
      } else {
        _fcmToken = isAPNSToken;
      }
    }
    _fcmToken = await _firebaseMessaging?.getToken();
  }

  ///[getfcmToken] function gets the FCM token
  String? get getfcmToken => _fcmToken;
}
