import 'dart:async';

import 'package:logging/logging.dart';

class HMSLogger {
  static final HMSLogger _instance = HMSLogger._internal();

  late final Logger _logger;

  /// Low-volume audio-health events (mic toggles, silent-mic detection and
  /// recovery). Kept on a separate logger name from the chatty `100ms` logger
  /// (10s bitrate polls) so host apps can drop `100ms` while still forwarding
  /// these to their remote logging.
  final Logger _audioHealthLogger = Logger('HMSAudioHealth');
  String? _roomId;
  String? _sessionId;

  // Track audio flow state to avoid duplicate logs
  final Map<String, bool> _localAudioFlowState = {'local': false};
  final Map<String, bool> _remoteAudioFlowState = {};

  // Track latest bitrate values for periodic logging
  double? _lastLocalAudioBitrate;
  final Map<String, double> _lastRemoteAudioBitrate = {};
  Timer? _bitratePollTimer;

  factory HMSLogger() {
    return _instance;
  }

  HMSLogger._internal() {
    _logger = Logger('100ms');
    _setupLogging();
  }

  void setSessionContext({String? roomId, String? sessionId}) {
    _roomId = roomId;
    _sessionId = sessionId;
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;

    Logger.root.onRecord.listen((record) {
      final timestamp = DateTime.now().toString();
      final contextInfo = _buildContextInfo();
      final logMessage = '[$timestamp]$contextInfo ${record.loggerName} - ${record.level.name}: ${record.message}';

      print(logMessage);

      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }

  String _buildContextInfo() {
    final parts = <String>[];
    if (_roomId != null) parts.add('roomId: $_roomId');
    if (_sessionId != null) parts.add('sessionId: $_sessionId');

    if (parts.isEmpty) return '';
    return ' [${parts.join(', ')}]';
  }

  void logButtonTap(String buttonName, {Map<String, dynamic>? additionalData}) {
    final message = 'Button Tapped: $buttonName';
    final logData = {
      'action': 'button_tap',
      'button': buttonName,
      if (additionalData != null) ...additionalData,
    };
    _logger.info('$message - Data: $logData');
  }

  void logBitrate(double outgoingBitrate, {String? peerId, String? quality}) {
    if (peerId == 'local' && quality == 'audio') {
      _lastLocalAudioBitrate = outgoingBitrate;
      _trackLocalAudioFlow(outgoingBitrate);
      _ensureBitratePollingStarted();
    } else if (peerId != null && peerId != 'local' && quality == 'audio') {
      _lastRemoteAudioBitrate[peerId] = outgoingBitrate;
      _trackRemoteAudioFlow(peerId, outgoingBitrate);
      _ensureBitratePollingStarted();
    }
  }

  void _ensureBitratePollingStarted() {
    if (_bitratePollTimer == null || !_bitratePollTimer!.isActive) {
      _startBitratePolling();
    }
  }

  void _startBitratePolling() {
    _bitratePollTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_lastLocalAudioBitrate != null) {
        final logData = {
          'action': 'bitrate_poll',
          'direction': 'outgoing',
          'bitrate': _lastLocalAudioBitrate,
        };
        _logger.info('Local Audio Bitrate - Data: $logData');
      }

      for (final entry in _lastRemoteAudioBitrate.entries) {
        final logData = {
          'action': 'bitrate_poll',
          'direction': 'incoming',
          'peer_id': entry.key,
          'bitrate': entry.value,
        };
        _logger.info('Remote Audio Bitrate - Data: $logData');
      }
    });
  }

  void stopBitratePolling() {
    _bitratePollTimer?.cancel();
    _bitratePollTimer = null;
    _lastLocalAudioBitrate = null;
    _lastRemoteAudioBitrate.clear();
  }

  void startAudioBitrateLogging({required Function addStatsListener}) {
    _lastLocalAudioBitrate = 0;
    addStatsListener();
    _ensureBitratePollingStarted();
  }

  void _trackLocalAudioFlow(double bitrate) {
    final isAudioFlowing = bitrate > 0;
    final wasFlowing = _localAudioFlowState['local'] ?? false;

    if (isAudioFlowing != wasFlowing) {
      _localAudioFlowState['local'] = isAudioFlowing;
      final message = isAudioFlowing ? 'Local Audio Flow Started' : 'Local Audio Flow Stopped';
      final logData = {
        'action': 'audio_flow_change',
        'direction': 'outgoing',
        'is_flowing': isAudioFlowing,
        'bitrate': bitrate,
      };
      _logger.info('$message - Data: $logData');
    }
  }

  void _trackRemoteAudioFlow(String peerId, double bitrate) {
    final isAudioFlowing = bitrate > 0;
    final wasFlowing = _remoteAudioFlowState[peerId] ?? false;

    if (isAudioFlowing != wasFlowing) {
      _remoteAudioFlowState[peerId] = isAudioFlowing;
      final message = isAudioFlowing ? 'Remote Audio Flow Started from $peerId' : 'Remote Audio Flow Stopped from $peerId';
      final logData = {
        'action': 'audio_flow_change',
        'direction': 'incoming',
        'peer_id': peerId,
        'is_flowing': isAudioFlowing,
        'bitrate': bitrate,
      };
      _logger.info('$message - Data: $logData');
    }
  }

  void logMicrophoneToggle(bool isMuted, {String? reason}) {
    final message = 'Microphone ${isMuted ? 'Muted' : 'Unmuted'}';
    final logData = {
      'action': 'microphone_toggle',
      'is_muted': isMuted,
      if (reason != null) 'reason': reason,
    };
    _logger.info('$message - Data: $logData');
    logAudioHealth(message, data: logData);
    _trackLocalAudioState(isMuted);
  }

  /// Logs an audio-health event on the `HMSAudioHealth` logger, with the
  /// current room/session context attached.
  void logAudioHealth(String message, {Map<String, dynamic>? data, bool warning = false}) {
    final logData = {
      if (_roomId != null) 'room_id': _roomId,
      if (_sessionId != null) 'session_id': _sessionId,
      if (data != null) ...data,
    };
    final line = logData.isEmpty ? message : '$message - Data: $logData';
    if (warning) {
      _audioHealthLogger.warning(line);
    } else {
      _audioHealthLogger.info(line);
    }
  }

  void _trackLocalAudioState(bool isMuted) {
    final isAudioEnabled = !isMuted;
    final wasAudioEnabled = _localAudioFlowState['local_enabled'] ?? false;

    if (isAudioEnabled != wasAudioEnabled) {
      _localAudioFlowState['local_enabled'] = isAudioEnabled;
      final message = isAudioEnabled ? 'Local Audio Enabled' : 'Local Audio Disabled';
      final logData = {
        'action': 'audio_state_change',
        'direction': 'outgoing',
        'is_enabled': isAudioEnabled,
      };
      _logger.info('$message - Data: $logData');
    }
  }

  void logCameraToggle(bool isOn, {String? reason}) {
    final message = 'Camera ${isOn ? 'On' : 'Off'}';
    final logData = {
      'action': 'camera_toggle',
      'is_on': isOn,
      if (reason != null) 'reason': reason,
    };
    _logger.info('$message - Data: $logData');
  }

  void logScreenShare(bool isSharing, {String? reason}) {
    final message = 'Screen Share ${isSharing ? 'Started' : 'Stopped'}';
    final logData = {
      'action': 'screen_share_toggle',
      'is_sharing': isSharing,
      if (reason != null) 'reason': reason,
    };
    _logger.info('$message - Data: $logData');
  }

  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    final logData = {
      'action': 'error',
      'message': message,
    };
    _logger.severe('$message - Data: $logData', error, stackTrace);
  }

  void logInfo(String message, {Map<String, dynamic>? data}) {
    final logData = {
      if (data != null) ...data,
    };
    if (logData.isEmpty) {
      _logger.info(message);
    } else {
      _logger.info('$message - Data: $logData');
    }
  }

  void logDebug(String message, {Map<String, dynamic>? data}) {
    final logData = {
      if (data != null) ...data,
    };
    if (logData.isEmpty) {
      _logger.fine(message);
    } else {
      _logger.fine('$message - Data: $logData');
    }
  }

  Logger getLogger(String name) {
    return Logger(name);
  }
}
