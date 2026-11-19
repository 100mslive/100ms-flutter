import 'dart:io';

import 'package:flutter/services.dart';

///[HMSAudioSessionHealth] repairs and diagnoses the iOS audio session used by
///the SDK (DEM-3564: mic shown unmuted but 0 bytes sent until the app was
///killed).
///
///`AVAudioSession` and WebRTC's audio controller are process-wide on iOS and
///survive `HMSSDK.destroy()`, so a broken state lasts for every later call in
///the same app process. These calls restart WebRTC's audio unit and reset the
///session in place. All methods are iOS-only: elsewhere they return `null` /
///an empty list. They never throw; failures are returned in the result map
///under `error`.
class HMSAudioSessionHealth {
  HMSAudioSessionHealth._();

  static const MethodChannel _channel =
      MethodChannel('hmssdk_flutter/audio_session_health');

  static const Duration _timeout = Duration(seconds: 3);

  ///Current `AVAudioSession` / WebRTC audio state, for logging.
  static Future<Map<String, dynamic>?> getState() =>
      _invokeMap('getState');

  ///Restarts WebRTC's audio unit in place. With [fullReset] the
  ///`AVAudioSession` is also deactivated and reactivated while the unit is
  ///stopped. Returns the state before/after.
  static Future<Map<String, dynamic>?> recover({bool fullReset = false}) =>
      _invokeMap('recover', {'fullReset': fullReset});

  ///Full `AVAudioSession` reset before a new preview captures the mic.
  static Future<Map<String, dynamic>?> resetForCall() =>
      _invokeMap('resetForCall');

  ///Audio-session events (interruptions, route changes, media-services
  ///resets) recorded natively since app launch or the previous drain, oldest
  ///first. At most the latest 50 are kept.
  static Future<List<Map<String, dynamic>>> drainEvents() async {
    if (!Platform.isIOS) {
      return const [];
    }
    try {
      final result =
          await _channel.invokeMethod<List<Object?>>('drainEvents').timeout(_timeout);
      return (result ?? const [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<Map<String, dynamic>?> _invokeMap(String method,
      [Map<String, dynamic>? args]) async {
    if (!Platform.isIOS) {
      return null;
    }
    try {
      final result =
          await _channel.invokeMethod<Map<Object?, Object?>>(method, args).timeout(_timeout);
      return result == null ? null : Map<String, dynamic>.from(result);
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
