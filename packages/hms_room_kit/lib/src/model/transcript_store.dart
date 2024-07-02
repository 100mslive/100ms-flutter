library;

///Package imports
import 'package:flutter/material.dart';

///[TranscriptStore] is a model that is used to store the transcript data
class TranscriptStore extends ChangeNotifier {
  String transcript;
  final String peerId;
  final int start;
  final String? peerName;

  TranscriptStore(
      {required this.transcript,
      required this.peerId,
      required this.start,
      required this.peerName});

  void notify() {
    notifyListeners();
  }

  void setTranscript(String transcript) {
    this.transcript = transcript;
    notifyListeners();
  }
}
