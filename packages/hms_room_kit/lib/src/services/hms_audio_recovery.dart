import 'dart:io';

import 'package:hms_room_kit/src/services/hms_logger.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

///[HMSAudioRecovery] keeps the local mic working on iOS (DEM-3564): the iOS
///audio session and WebRTC's audio controller are process-wide and survive
///`HMSSDK.destroy()`, so once broken the mic stayed silent until the app was
///killed. Normal calls are not changed; iOS-only.
///
///Logs are kept rare: one line per preview, and per silent-mic incident one
///line for attempts 1, 2 and every 10th, with native audio events attached.
class HMSAudioRecovery {
  HMSAudioRecovery._();

  ///Set once a silent mic is seen; the next preview then resets the session.
  static bool _resetBeforeNextPreview = false;

  ///Awaited before a new preview captures the mic. Logs the audio events since
  ///the last call and the current state; after a silent mic earlier in this
  ///process it fully resets the audio session first. Never throws.
  static Future<void> beforePreview() async {
    if (!Platform.isIOS) {
      return;
    }
    try {
      final events = await HMSAudioSessionHealth.drainEvents();
      if (!_resetBeforeNextPreview) {
        final state = await HMSAudioSessionHealth.getState();
        HMSLogger().logAudioHealth('Audio state before preview',
            data: {'state': state, 'events': events});
        return;
      }
      _resetBeforeNextPreview = false;
      final result = await HMSAudioSessionHealth.resetForCall();
      HMSLogger().logAudioHealth(
          'Audio session reset before preview (silent mic earlier)',
          warning: true,
          data: {'result': result, 'events': events});
    } catch (e) {
      HMSLogger().logAudioHealth('beforePreview failed',
          warning: true, data: {'error': e.toString()});
    }
  }

  ///Called by the meeting watchdog each time the unmuted mic sends nothing
  ///([attempt] counts attempts of the current incident). Attempt 1 restarts
  ///WebRTC's audio unit; 2+ also resets the `AVAudioSession`. Never throws.
  static Future<void> onSilentMic(int attempt,
      {Map<String, dynamic>? details}) async {
    if (!Platform.isIOS) {
      return;
    }
    _resetBeforeNextPreview = true;
    final fullReset = attempt >= 2;
    final shouldLog = attempt <= 2 || attempt % 10 == 0;
    try {
      final result = await HMSAudioSessionHealth.recover(fullReset: fullReset);
      if (!shouldLog) {
        return;
      }
      // Drained only when logging, so skipped attempts' events stay buffered.
      final events = await HMSAudioSessionHealth.drainEvents();
      HMSLogger().logAudioHealth('Silent mic: audio engine restarted',
          warning: true,
          data: {
            'attempt': attempt,
            'fullReset': fullReset,
            ...?details,
            'result': result,
            'events': events,
          });
    } catch (e) {
      if (shouldLog) {
        HMSLogger().logAudioHealth('Silent mic recovery failed',
            warning: true, data: {'attempt': attempt, 'error': e.toString()});
      }
    }
  }
}
