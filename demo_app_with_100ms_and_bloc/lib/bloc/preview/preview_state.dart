part of 'preview_cubit.dart';

class PreviewState extends Equatable {
  const PreviewState({
    this.isMicOff = true,
    this.isVideoOff = true,
    this.tracks = const <HMSVideoTrack>[],
  });

  final bool isMicOff;
  final bool isVideoOff;
  final List<HMSVideoTrack> tracks;

  PreviewState copyWith(
      {bool? isMicOff, bool? isVideoOff, List<HMSVideoTrack>? tracks}) {
    return PreviewState(
        isMicOff: isMicOff ?? this.isMicOff,
        isVideoOff: isVideoOff ?? this.isVideoOff,
        tracks: tracks ?? this.tracks);
  }

  @override
  String toString() {
    return '''PreviewState { isMicOff: $isMicOff, isVideoOff: $isVideoOff}''';
  }

  @override
  List<Object> get props => [isMicOff, isVideoOff, tracks];
}
