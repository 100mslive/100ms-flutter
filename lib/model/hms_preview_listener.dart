///[HMSPreviewListener] listens to updates when you preview.
///
///Just implement it and get the preview updates.
///
/// Check out the [Sample App] how we are using it.
import 'package:hmssdk_flutter/model/hms_error.dart';
import 'package:hmssdk_flutter/model/hms_room.dart';
import 'package:hmssdk_flutter/model/hms_track.dart';
abstract class HMSPreviewListener {
  ///when an error is caught [onError] will be called
  ///
  /// - Parameters:
  ///   - error: error which you get.
  void onError({required HMSError error});

  ///when you want to preview listen to this callback
  ///
  /// - Parameters:
  ///   - room: the room which was joined
  ///   - localTracks: local audio/video tracks list
  void onPreview({required HMSRoom room, required List<HMSTrack> localTracks});
}
