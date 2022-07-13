//Dart imports
import 'dart:io';
import 'dart:convert';

//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/logs/static_logger.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class CustomLogger {
  static File? file;
  late FileOutput fileOutPut;

  void getCustomLogger() {
    getDirectoryForLogRecord().whenComplete(
      () {
        // ConsoleOutput consoleOutput = ConsoleOutput();
        fileOutPut = FileOutput(file: file);
        List<LogOutput> multiOutput = [fileOutPut];
        StaticLogger.logger = Logger(
            filter: MyFilter(),
            // Use the default LogFilter (-> only log in debug mode)
            printer: PrettyPrinter(
                noBoxingByDefault: true,
                methodCount: 0,
                errorMethodCount: 0,
                lineLength: 100,
                colors: false,
                printEmojis: false,
                printTime: false),
            output: MultiOutput(multiOutput));
      },
    );
  }

  Future<void> getDirectoryForLogRecord() async {
    final Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    file = File('${directory?.path}/logs.txt');
  }
}

class FileOutput extends LogOutput {
  final File? file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({
    @required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  void init() {
    _sink = file?.openWrite(
      mode: FileMode.writeOnly,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
