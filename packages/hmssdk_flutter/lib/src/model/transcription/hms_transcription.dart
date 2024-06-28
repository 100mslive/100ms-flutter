///[HMSTranscription] is a class which is used to represent a transcription.
class HMSTranscription {
  final int start;
  final int end;

  ///[transcript] is the text of the transcription.
  final String transcript;

  ///[peerId] is the id of the speaker.
  final String peerId;

  ///[peerName] is the name of the speaker.
  final String? peerName;

  ///[isFinal] is a boolean which tells if the transcription is final or not.
  final bool isFinal;

  HMSTranscription(
      {required this.start,
      required this.end,
      required this.transcript,
      required this.peerId,
      required this.peerName,
      required this.isFinal});

  factory HMSTranscription.fromMap(Map map) {
    return HMSTranscription(
        start: map['start'],
        end: map['end'],
        transcript: map['transcript'],
        peerId: map['peer_id'],
        peerName: map['peer_name'],
        isFinal: map['is_final']);
  }
}
