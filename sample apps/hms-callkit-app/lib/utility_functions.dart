//Dart imports
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

//Package imports
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:hms_callkit/app_navigation/app_router.dart';
import 'package:hms_callkit/app_navigation/navigation_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

Uuid? _uniqueCallId;
String? _currentCallId;
String onEventLogs = "";
late final FirebaseMessaging _firebaseMessaging;
String deviceFCMToken = "";
Color hmsdefaultColor = const Color.fromRGBO(36, 113, 237, 1);

//Handles when app is in background or terminated
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  var response = jsonDecode(message.data["params"]);
  CallKitParams data = CallKitParams.fromJson(response);
  if (data.extra?.containsKey("authToken") ?? false) {
    placeCall(data.extra!["authToken"]);
  } else {
    log("No Valid authToken found");
  }
}

//This initializes the firebase
void initFirebase() async {
  print("Firebase init");
  _uniqueCallId = const Uuid();
  _firebaseMessaging = FirebaseMessaging.instance;
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    return;
  }
  deviceFCMToken = await _firebaseMessaging.getToken() ?? "";
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("HMSSDK Value is ${message.data["params"]}");
    var response = jsonDecode(message.data["params"]);
    CallKitParams data = CallKitParams.fromJson(response);
    if (data.extra?.containsKey("authToken") ?? false) {
      print("HMSSDK Received Notification");
      placeCall(data.extra!["authToken"]);
    } else {
      log("No Valid authToken found");
    }
  });
  _firebaseMessaging.getToken().then((token) {
    log('Device Token FCM: $token');
  });
  initCurrentCall();
}

//This function returns the currently running call if any
_getCurrentCall() async {
  var calls = await FlutterCallkitIncoming.activeCalls();
  if (calls is List) {
    if (calls.isNotEmpty) {
      log('DATA: $calls');
      _currentCallId = calls[0]['id'];
      return calls[0];
    } else {
      _currentCallId = "";
      return null;
    }
  }
}

//Method to place the call
Future<void> placeCall(String authToken) async {
  await FlutterCallkitIncoming.showCallkitIncoming(getCallInfo(authToken));
}

//This function navigates to the call screen if a call is currently running
void checkAndNavigationCallingPage(String message) async {
  var currentCall = await _getCurrentCall();
  bool res = await getPermissions();
  if (currentCall != null) {
    Map<String, dynamic> callData = {};
    currentCall.forEach((key, value) {
      callData[key] = value;
    });
    if (res == true && currentCall != null && currentCall["extra"] != null) {
      NavigationService.instance.pushNamedIfNotCurrent(AppRoute.callingPage,
          args: currentCall["extra"]["authToken"]);
    }
  }
}

//To make a fake call on same device
Future<void> makeFakeCallInComing() async {
  await Future.delayed(const Duration(seconds: 5), () async {
    _currentCallId = _uniqueCallId?.v4();

    final params = CallKitParams(
      id: _currentCallId,
      nameCaller: 'Test User',
      appName: 'Callkit',
      avatar: 'https://i.pravatar.cc/100',
      handle: '0123456789',
      type: 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: <String, dynamic>{
        'userId': '1a2b3c4d',
        'authToken': "Enter your authToken here",
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: 'Incoming Call',
        missedCallNotificationChannelName: 'Missed Call',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  });
}

//To start a call but we are directly logging into the meeting
Future<void> startOutGoingCall() async {
  _currentCallId = _uniqueCallId?.v4();
  final params = CallKitParams(
    id: _currentCallId,
    nameCaller: 'Test user',
    handle: '0123456789',
    type: 1,
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    ios: const IOSParams(handleType: 'number'),
  );
  await FlutterCallkitIncoming.startCall(params);
}

//This method returns all the calls running currently
Future<void> activeCalls() async {
  var calls = await FlutterCallkitIncoming.activeCalls();
  log(calls);
}

//This method ends all the calls that are running currently
Future<void> endAllCalls() async {
  await FlutterCallkitIncoming.endAllCalls();
}

//This function fetches the calls that are currently active and set the _currentCallId to that call
initCurrentCall() async {
  var calls = await FlutterCallkitIncoming.activeCalls();
  if (calls is List) {
    if (calls.isNotEmpty) {
      log('DATA: $calls');
      _currentCallId = calls[0]['id'];
      return calls[0];
    } else {
      _currentCallId = "";
      return null;
    }
  }
}

//This method ends the currently running call
Future<void> endCurrentCall() async {
  initCurrentCall();
  await FlutterCallkitIncoming.endCall(_currentCallId!);
}

//To get microphone and camera permissions
Future<bool> getPermissions() async {
  if (Platform.isIOS) return true;
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.bluetoothConnect.request();

  while ((await Permission.camera.isDenied)) {
    await Permission.camera.request();
  }
  while ((await Permission.microphone.isDenied)) {
    await Permission.microphone.request();
  }
  while ((await Permission.bluetoothConnect.isDenied)) {
    await Permission.bluetoothConnect.request();
  }
  return true;
}

//This is used to get the deviceFCM token just for printing in logs
Future<void> getDevicePushTokenVoIP() async {
  var devicePushTokenVoIP =
      await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  log("Device token is $devicePushTokenVoIP");
  return devicePushTokenVoIP;
}

//This method sends the notification to the receiver's device
Future<void> call(
    {required String receiverFCMToken, required String authToken}) async {
  var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
  startOutGoingCall();
  await func.call(<String, dynamic>{
    "targetDevices": [receiverFCMToken], //Enter the device fcmToken here
    "messageTitle": "Incoming Call",
    "messageBody": "Someone is calling you...",
    "callkitParams": json.encode(getCallInfo(authToken).toJson())
  });
}

//This method is used to set the info which needs to be sent to the receiver for joining the room and showing the caller UI
CallKitParams getCallInfo(String authToken) {
  if (_uniqueCallId == null) {
    _uniqueCallId = const Uuid();
    _currentCallId = _uniqueCallId?.v4();
  }
  return CallKitParams(
    id: _uniqueCallId?.v4(),
    nameCaller: 'Test User',
    appName: 'HMS Call',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 1,
    duration: 60000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    extra: <String, dynamic>{'authToken': authToken},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
    ),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
}
