import 'package:bloc/bloc.dart';
import 'package:demo_app_with_100ms_and_bloc/observers/preview_observer.dart';
import 'package:equatable/equatable.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

part 'preview_state.dart';

class PreviewCubit extends Cubit<PreviewState> {


  HMSSDK hmsSdk = HMSSDK();
  String name;
  String url;

  PreviewCubit(this.name,this.url) : super(const PreviewState(isMicOff: false, isVideoOff: false)){
    PreviewObserver(this);
  }

  void toggleVideo() {

    hmsSdk.switchVideo(isOn: !state.isVideoOff);

    emit(
        state.copyWith(
            isVideoOff: !state.isVideoOff));
  }


  void toggleAudio() {

    hmsSdk.switchAudio(isOn: !state.isMicOff);
    emit(
        state.copyWith(
            isMicOff: !state.isMicOff));
  }


  void updateTracks(List<HMSVideoTrack> localTracks) {
    emit(state.copyWith(tracks: localTracks));
  }

}
