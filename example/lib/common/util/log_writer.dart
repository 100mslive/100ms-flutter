import 'dart:io';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:path_provider/path_provider.dart';

File? _logFile;
Future<String?> get _localPath async {
  final directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  return directory?.path;
}

Future<File?> get getLogFile async {
  if (_logFile == null) {
    final path = await _localPath;
    if (path == null) {
      return null;
    }
    _logFile = File('$path/hms_log.txt');
  }
  return _logFile;
}

Future<void> deleteFile() async {
  if (await _logFile?.exists() ?? false) {
    _logFile?.delete();
  }
}

Future<void> writeLogs(HMSLogList? logsList) async {
  final file = await getLogFile;
  // Write the file
  if(file != null){
      logsList?.hmsLog.forEach((element) {
      file.writeAsString(element + "\n", mode: FileMode.append);
  });
  }
}
