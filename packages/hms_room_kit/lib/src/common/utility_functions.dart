library;

///Dart imports
import 'dart:io';
import 'dart:math' as math;

///Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:tuple/tuple.dart';

///This class contains the utility functions used in the app
class Utilities {
  static RegExp regexEmoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  ///This function is used to get the avatar title
  static String getAvatarTitle(String name) {
    if (name.isEmpty) {
      return "👤";
    }
    if (name.contains(regexEmoji)) {
      name = name.replaceAll(regexEmoji, '');
      if (name.trim().isEmpty) {
        return '😄';
      }
    }
    List<String>? parts = name.trim().split(" ");
    if (parts.length == 1) {
      name = parts[0].substring(0, math.min(2, parts[0].length));
    } else if (parts.length >= 2) {
      name = parts[0][0];
      if (parts[1] == "" || parts[1] == " ") {
        name += parts[0][1];
      } else {
        name += parts[1][0];
      }
    }
    return name.toUpperCase();
  }

  ///This function is used to get the avatar background colour
  static Color getBackgroundColour(String name) {
    if (name.isEmpty) {
      return avatarColors[0];
    }
    if (name.contains(regexEmoji)) {
      name = name.replaceAll(regexEmoji, '');
      if (name.trim().isEmpty) {
        return avatarColors[0];
      }
    }
    return avatarColors[name.toUpperCase().codeUnitAt(0) % avatarColors.length];
  }

  /// List of alignments for timed metadata toasts
  static List<Alignment> timedMetadataAlignment = [
    const Alignment(-0.9, 0.4),
    const Alignment(-0.4, 0.2),
    const Alignment(0, 0.8),
    const Alignment(0.4, 0.9),
    const Alignment(0.8, 0.5)
  ];

  ///This function is used to get Aspect Ratio of the screen
  static double getRatio(Size size, BuildContext context) {
    EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;
    return (size.height -
            viewPadding.top -
            viewPadding.bottom -
            kToolbarHeight -
            kBottomNavigationBarHeight -
            4) /
        (size.width);
  }

  ///This function is used to get HLS Player's Aspect Ratio for the screen
  static double getHLSRatio(Size size, BuildContext context) {
    return (size.height - 1) / (size.width);
  }

  ///This function is used to get HLS Player's Default Aspect Ratio for the screen
  static double getHLSPlayerDefaultRatio(Size size) {
    if (Platform.isAndroid) {
      return size.width / (size.height - 100);
    } else {
      return 9 / 16;
    }
  }

  ///This function is used to get the RTMP URL from the room link
  static void setRTMPUrl(String roomUrl) {
    if (roomUrl.contains("flutterhms.page.link") &&
        roomUrl.contains("meetingUrl")) {
      roomUrl = roomUrl.split("meetingUrl=")[1];
    }
    List<String> urlSplit = roomUrl.split('/');
    int index = urlSplit.lastIndexOf("meeting");
    if (index != -1) {
      urlSplit[index] = "preview";
    }
    Constant.streamingUrl = "${urlSplit.join('/')}?skip_preview=true";
  }

  ///This function formats the number of peers
  ///If the number of peers is greater than 1 million, we render the number in millions
  ///If the number of peers is greater than 1 thousand, we render the number in thousands
  ///else we render the number as it is
  static String formatNumber(int number) {
    if (number >= 1000000) {
      double num = number / 1000000;
      return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}M';
    } else if (number >= 1000) {
      double num = number / 1000;
      return '${num.toStringAsFixed(num.truncateToDouble() == num ? 0 : 1)}K';
    } else {
      return number.toString();
    }
  }

  ///This function returns the question type for poll/quiz
  static List<Tuple2<String, HMSPollQuestionType>>
      getQuestionTypeForPollQuiz() {
    return const [
      Tuple2("Single Choice", HMSPollQuestionType.singleChoice),
      Tuple2("Multiple Choice", HMSPollQuestionType.multiChoice)
    ];
  }

  ///This method returns the scale of the toast according to the index and the total number of toasts
  static double getToastScale(int index, int toastsCount) {
    if (toastsCount == 1) {
      return 1;
    } else if (toastsCount == 2) {
      if (index == 0) {
        return 0.95;
      }
      return 1;
    } else {
      if (index == 0) {
        return 0.90;
      } else if (index == 1) {
        return 0.95;
      }
      return 1;
    }
  }

  ///This contains the list of toasts possible colors
  static final List<Color> _toastColors = [
    HMSThemeColors.surfaceDim,
    HMSThemeColors.surfaceDim.withOpacity(0.8),
    HMSThemeColors.surfaceDim.withOpacity(0.6),
  ];

  ///This method returns the toast color based on the index and the number of toasts
  static Color getToastColor(int index, int toastsCount) {
    if (toastsCount == 1) return _toastColors[0];
    if (toastsCount == 2) return _toastColors[1 - index];
    return _toastColors[2 - index];
  }

  ///This function gets permissions for the camera,microphone and bluetooth headphones
  static Future<bool> getPermissions() async {
    ///We request the permissions for the camera,microphone and bluetooth
    await Permission.camera.request();
    await Permission.microphone.request();
    if (Platform.isIOS) {
      await Permission.bluetooth.request();
    }
    await Permission.phone.request();

    ///We check if the permissions are granted
    ///If they are granted we return true
    ///Else we return false
    if (Platform.isIOS) {
      if (await Permission.camera.isGranted &&
          await Permission.microphone.isGranted &&
          await Permission.bluetooth.isGranted) {
        return true;
      }
    } else if (Platform.isAndroid) {
      if (await Permission.camera.isGranted &&
          await Permission.microphone.isGranted &&
          await Permission.phone.isGranted) {
        return true;
      }
    }

    ///We open the app settings if the user has permanently denied the permissions
    ///This is done because the user can't grant the permissions from the app now
    bool isCameraPermissionsDenied = (await Permission.camera.isDenied &&
        !await Permission.camera.shouldShowRequestRationale);
    bool isMicrophonePermissionsDenied =
        (await Permission.microphone.isDenied &&
            !await Permission.microphone.shouldShowRequestRationale);
    bool isBluetoothPermissionsDenied = false;
    bool isPhonePermissionDenied = Platform.isAndroid
        ? (await Permission.phone.isDenied &&
            !await Permission.phone.shouldShowRequestRationale)
        : false;
    if (Platform.isIOS) {
      isBluetoothPermissionsDenied =
          await Permission.bluetooth.isPermanentlyDenied;
    }

    ///We open the app settings if the user has permanently denied the permissions
    ///based on the platform
    if (isCameraPermissionsDenied ||
        isMicrophonePermissionsDenied ||
        isBluetoothPermissionsDenied ||
        isPhonePermissionDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  ///This method checks for the permissions for the camera,microphone and bluetooth
  ///Based on this we route the screens.
  static Future<bool> checkPermissions() async {
    if (await Permission.camera.isGranted &&
        await Permission.microphone.isGranted &&
        (await Permission.bluetoothConnect.isGranted ||
            await Permission.bluetooth.isGranted)) {
      return true;
    }
    return false;
  }

  ///This method is used to get names for the audio devices
  ///It is used to set the icon based on the audio device
  static String getAudioDeviceIconName(HMSAudioDevice? hmsAudioDevice) {
    switch (hmsAudioDevice) {
      case HMSAudioDevice.SPEAKER_PHONE:
        return "speaker_state_on";
      case HMSAudioDevice.WIRED_HEADSET:
        return "wired_headset";
      case HMSAudioDevice.EARPIECE:
        return "earpiece";
      case HMSAudioDevice.BLUETOOTH:
        return "bluetooth";
      default:
        return "speaker_state_on";
    }
  }

  ///This method is used to get names for the audio devices
  static String getAudioDeviceName(HMSAudioDevice? hmsAudioDevice) {
    switch (hmsAudioDevice) {
      case HMSAudioDevice.SPEAKER_PHONE:
        return "Speaker";
      case HMSAudioDevice.WIRED_HEADSET:
        return "Earphone";
      case HMSAudioDevice.EARPIECE:
        return "Phone";
      case HMSAudioDevice.BLUETOOTH:
        return "Bluetooth Device";
      default:
        return "Auto";
    }
  }

  ///This method is used to get camera permissions
  static Future<bool> getCameraPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }

    return true;
  }

  static void showToast(String message, {int time = 1}) {
    // BotToast.showText(
    //     textStyle: HMSTextStyle.setTextStyle(fontSize: 14),
    //     text: message,
    //     contentColor: Colors.black87,
    //     duration: Duration(seconds: time));
  }

  static void showTimedMetadata(String message,
      {int time = 1, Alignment align = const Alignment(0, 0.8)}) {
    // BotToast.showText(
    //     align: align,
    //     wrapToastAnimation: (controller, cancelFunc, widget) =>
    //         AnimatedTextWidget(
    //             text: message, duration: Duration(seconds: time)),
    //     onlyOne: false,
    //     textStyle: HMSTextStyle.setTextStyle(fontSize: 14),
    //     text: message,
    //     contentColor: Colors.black87,
    //     duration: Duration(seconds: time));
  }

  static String getQuestionType(HMSPollQuestionType questionType) {
    switch (questionType) {
      case HMSPollQuestionType.singleChoice:
        return "SINGLE CHOICE";
      case HMSPollQuestionType.multiChoice:
        return "MULTI CHOICE";
      default:
        return "SINGLE CHOICE";
    }
  }

  static Future<String> getStringData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? "";
  }

  static void saveStringData(
      {required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, value);
  }

  static Future<int> getIntData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key) ?? 0;
  }

  static void saveIntData({required String key, required int value}) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt(key, value);
  }

  static Future<bool?> getBoolData({required String key}) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  static Future<bool> saveBoolData(
      {required String key, required bool value}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static String fetchMeetingLinkFromFirebase(String url) {
    url = url.split("deep_link_id=")[1];
    url = url.split("&")[0];
    url = url.replaceAll("%3A", ":").replaceAll("%2F", "/");
    return url;
  }

  static void showNotification(String message, String type) async {
    bool toShowNotif = false;
    switch (type) {
      case "peer-joined":
        toShowNotif =
            await Utilities.getBoolData(key: "peer-join-notif") ?? true;
        if (toShowNotif) showToast(message);
        break;

      case "peer-left":
        toShowNotif =
            await Utilities.getBoolData(key: "peer-leave-notif") ?? true;
        if (toShowNotif) showToast(message);
        break;

      case "message":
        toShowNotif =
            await Utilities.getBoolData(key: "new-message-notif") ?? true;
        if (toShowNotif) showToast(message);
        break;

      case "hand-raise":
        toShowNotif =
            await Utilities.getBoolData(key: "hand-raise-notif") ?? true;
        if (toShowNotif) showToast(message);
        break;

      case "error":
        toShowNotif = await Utilities.getBoolData(key: "error-notif") ?? true;
        if (toShowNotif) showToast(message);
        break;
    }
  }

  static HMSTrackSetting getTrackSetting({
    required bool isAudioMixerDisabled,
    required bool joinWithMutedVideo,
    required bool joinWithMutedAudio,
    required bool isSoftwareDecoderDisabled,
    required bool isNoiseCancellationEnabled,
    HMSAudioMode? audioMode,
  }) {
    return HMSTrackSetting(
        audioTrackSetting: HMSAudioTrackSetting(

            ///If audio mixer is disabled we set the audio source as null
            ///Note that this is only required for iOS
            audioSource: isAudioMixerDisabled
                ? null
                : HMSAudioMixerSource(node: [
                    HMSAudioFilePlayerNode("audioFilePlayerNode"),
                    HMSMicNode(),
                    HMSScreenBroadcastAudioReceiverNode(),
                  ]),
            trackInitialState: joinWithMutedAudio
                ? HMSTrackInitState.MUTED
                : HMSTrackInitState.UNMUTED,
            audioMode: audioMode,
            enableNoiseCancellation: isNoiseCancellationEnabled),
        videoTrackSetting: HMSVideoTrackSetting(
            trackInitialState: joinWithMutedVideo
                ? HMSTrackInitState.MUTED
                : HMSTrackInitState.UNMUTED,
            forceSoftwareDecoder: isSoftwareDecoderDisabled,
            isVirtualBackgroundEnabled:
                AppDebugConfig.isVirtualBackgroundEnabled));
  }

  static String getTimedMetadataEmojiFromId(String emojiId) {
    switch (emojiId) {
      case "+1":
        return "👍";
      case "-1":
        return "👎";
      case "wave":
        return "👋";
      case "clap":
        return "👏";
      case "fire":
        return "🔥";
      case "tada":
        return "🎉";
      case "heart_eyes":
        return "😍";
      case "joy":
        return "😂";
      case "open_mouth":
        return "😮";
      case "sob":
        return "😭";
      default:
        return "";
    }
  }
}
