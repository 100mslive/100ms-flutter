import 'package:logging/logging.dart';

class HMSLogger {
  static final HMSLogger _instance = HMSLogger._internal();

  late final Logger _logger;
  String? _roomId;
  String? _sessionId;

  // Track audio flow state to avoid duplicate logs
  final Map<String, bool> _localAudioFlowState = {'local': false};
  final Map<String, bool> _remoteAudioFlowState = {};

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
      _trackLocalAudioFlow(outgoingBitrate);
    } else if (peerId != null && peerId != 'local' && quality == 'audio') {
      _trackRemoteAudioFlow(peerId, outgoingBitrate);
    }
  }

  void _trackLocalAudioFlow(double bitrate) {
    final isAudioFlowing = bitrate > 0;
    final wasFlowing = _localAudioFlowState['local'] ?? false;

    if (isAudioFlowing != wasFlowing) {
      _localAudioFlowState['local'] = isAudioFlowing;
      final message = isAudioFlowing
          ? 'Local Audio Flow Started'
          : 'Local Audio Flow Stopped';
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
      final message = isAudioFlowing
          ? 'Remote Audio Flow Started from $peerId'
          : 'Remote Audio Flow Stopped from $peerId';
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
  }

  void logAudioState(bool isAudioEnabled, {String? peerId, required String direction}) {
    final peer = peerId ?? 'local';
    final message = '$direction Audio is ${isAudioEnabled ? 'Enabled' : 'Disabled'} for $peer';
    final logData = {
      'action': 'audio_state',
      'direction': direction,
      'peer_id': peer,
      'is_enabled': isAudioEnabled,
    };
    _logger.info('$message - Data: $logData');
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
