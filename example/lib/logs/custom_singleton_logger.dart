// Flutter imports
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

// SDK imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// package imports
import 'package:hmssdk_flutter_example/logs/static_logger.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class CustomLogger {
  static File? file;
  late FileOutput fileOutPut;

  void getCustomLogger() {
    getDirectoryForLogRecord().whenComplete(
      () {
        fileOutPut = FileOutput(file: file);
        // ConsoleOutput consoleOutput = ConsoleOutput();
        // List<LogOutput> multiOutput = [fileOutPut,consoleOutput];
        // StaticLogger.logger = Logger(
        //     filter: DevelopmentFilter(),
        //     // Use the default LogFilter (-> only log in debug mode)
        //     printer: PrettyPrinter(
        //         noBoxingByDefault: true,
        //         methodCount: 0,
        //         errorMethodCount: 0,
        //         lineLength: 100,
        //         colors: false,
        //         printEmojis: false,
        //         printTime: false
        //         ),
        //     output: MultiOutput(
        //         multiOutput)
        //     );
      },
    );
  }

  Future<void> getDirectoryForLogRecord() async {
    final Directory? directory = await getExternalStorageDirectory();
    print(directory?.path);
    file = File('${directory?.path}/test.txt');
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
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    print("-------------------------Logs Start Here------------------------------------------------------");
    _sink?.writeAll(event.lines, '\n');
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
