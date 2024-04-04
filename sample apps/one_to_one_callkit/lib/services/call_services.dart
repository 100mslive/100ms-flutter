///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

///Project imports
import 'package:one_to_one_callkit/call_type.dart';
import 'package:one_to_one_callkit/services/app_router.dart';
import 'package:one_to_one_callkit/services/navigation_service.dart';
import 'package:one_to_one_callkit/services/user_data_model.dart';

///[CallServices] class is used to handle the call services
class CallServices {
  static Uuid uuid = const Uuid();
  static String? _currentUuid;

  ///[parseStringToMap] method is used to parse the string to map
  static Map<String, dynamic> parseStringToMap(String data) {
    // Remove unnecessary characters and split into key-value pairs
    List<String> keyValuePairs =
        data.replaceAll('{', '').replaceAll('}', '').split(', ');

    // Create a map to store key-value pairs
    Map<String, dynamic> jsonMap = {};

    // Iterate through each key-value pair and add them to the map
    for (var pair in keyValuePairs) {
      List<String> keyValue = pair.split(': ');
      String key = keyValue[0].trim();
      String value = keyValue[1].trim();

      // Removing quotes if present around the value
      if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }

      // Adding key-value pair to the map
      jsonMap[key] = value == "null" ? null : value;
    }

    return jsonMap;
  }

  ///[getCallkitParams] method is used to get the callkit params
  static CallKitParams getCallkitParams(
      UserDataModel user, String roomCode, CallType type) {
    var callId = uuid.v4();
    _currentUuid = callId;
    return CallKitParams(
      id: callId,
      nameCaller: user.userName,
      appName: 'Blitz',
      avatar: user.imgUrl,
      handle: user.email,
      type: type == CallType.audio ? 0 : 1,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      duration: 30000,
      extra: {'room_code': roomCode},
      // headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#0955fa',
          backgroundUrl: user.imgUrl,
          actionColor: '#4CAF50',
          textColor: '#ffffff',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call",
          isShowCallID: false),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
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

  ///[receiveCall] method is used to handle the receive call functionality
  static receiveCall(UserDataModel user, String roomCode, CallType type) async {
    CallKitParams callKitParams = getCallkitParams(user, roomCode, type);
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }

  ///[startCall] method is used to handle the start call functionality
  ///This method is called when the user initiates the call
  ///i.e. from the caller side
  static startCall(
      UserDataModel user, CallType callType, String roomCode) async {
    var currentCalls = await getCurrentCall();
    if (currentCalls != null) {
      await FlutterCallkitIncoming.endAllCalls();
    }

    ///This section is used to configure the audio session
    ///Not in use as of now
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration(
    //   avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    //   avAudioSessionCategoryOptions:
    //       AVAudioSessionCategoryOptions.duckOthers,
    //   avAudioSessionMode: AVAudioSessionMode.voiceChat,
    //   avAudioSessionRouteSharingPolicy:
    //       AVAudioSessionRouteSharingPolicy.defaultPolicy,
    //   avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
    // ));

    ///[startCall] method is used to start the call
    await FlutterCallkitIncoming.startCall(
        getCallkitParams(user, roomCode, callType));
    NavigationService.instance.popUntil('/');
    log("Callkit: Joining Room $roomCode");

    ///[pushNamedIfNotCurrent] method is used to navigate to the preview page
    NavigationService.instance
        .pushNamedIfNotCurrent(AppRoute.previewPage, args: {
      "is_video_call": callType == CallType.video ? true : false,
      "user_img_url": user.imgUrl,
      "user_name": user.userName,
      "room_code": roomCode,
      "on_leave": endCall
    });
  }

  ///[endCall] method is used to end the call
  static void endCall() async {
    ///if the current call is not null then end the call
    if (_currentUuid != null && _currentUuid != "") {
      await FlutterCallkitIncoming.endCall(_currentUuid!);
    }
  }

  ///[getCurrentCall] method is used to get the current call
  static Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  ///[addCallkitUpdates] method is used to add the callkit updates
  ///This method is used to listen to the callkit events
  ///and perform the actions accordingly
  static Future<void> addCallkitUpdates() async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        switch (event!.event) {
          case Event.actionCallIncoming:
            break;
          case Event.actionCallStart:
            break;
          case Event.actionCallAccept:

            ///As the user accepts the call, the user is navigated to the preview page
            ///[event.body] is used to get the event body
            ///[data] is used to get the data from the event body
            ///[roomCode] is used to get the room code from the data
            log("Callkit: $event");
            var data = event.body;
            String roomCode = data["extra"]["room_code"];
            NavigationService.instance
                .pushNamedIfNotCurrent(AppRoute.previewPage, args: {
              "is_video_call": data["type"] == 1,
              "user_img_url": data["avatar"],
              "user_name": data["nameCaller"],
              "room_code": roomCode,
              "on_leave": endCall
            });

            ///[FlutterCallkitIncoming.setCallConnected] is used to set the call connected
            if (_currentUuid != null) {
              await FlutterCallkitIncoming.setCallConnected(_currentUuid!);
            }
            break;
          case Event.actionCallDecline:
            break;
          case Event.actionCallEnded:
            break;
          case Event.actionCallTimeout:
            break;
          case Event.actionCallCallback:
            break;
          case Event.actionCallToggleHold:
            break;
          case Event.actionCallToggleMute:
            break;
          case Event.actionCallToggleDmtf:
            break;
          case Event.actionCallToggleGroup:
            break;
          case Event.actionCallToggleAudioSession:
            break;
          case Event.actionDidUpdateDevicePushTokenVoip:
            break;
          case Event.actionCallCustom:
            break;
        }
      });
    } on Exception {
      log("Callkit: Error occured");
    }
  }
}
