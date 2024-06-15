class HMSTranscription {
  final int start;
  final int end;
  final String transcript;
  final String peerId;
  final bool isFinal;

  HMSTranscription(
      {required this.start,
      required this.end,
      required this.transcript,
      required this.peerId,
      required this.isFinal});

  factory HMSTranscription.fromMap(Map map) {
    return HMSTranscription(
        start: map['start'],
        end: map['end'],
        transcript: map['transcript'],
        peerId: map['peer_id'],
        isFinal: map['is_final']);
  }
}
