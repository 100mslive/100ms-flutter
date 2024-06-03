import 'package:example_riverpod/meeting/meeting_page.dart';
import 'package:example_riverpod/preview/preview_store.dart';
import 'package:example_riverpod/service/utility_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  final String roomLink;
  final String name;
  final PreviewStore previewStore;

  const PreviewScreen(
      {Key? key,
      required this.name,
      required this.roomLink,
      required this.previewStore})
      : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  late final ChangeNotifierProvider<PreviewStore> previewStoreProvider;

  @override
  void initState() {
    super.initState();
    previewStoreProvider = ChangeNotifierProvider<PreviewStore>((ref) {
      return widget.previewStore;
    });
    initPreview();
  }

  Future<void> initPreview() async {
    await widget.previewStore
        .startPreview(user: widget.name, roomId: widget.roomLink);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final _previewStore = ref.watch(previewStoreProvider);

    return WillPopScope(
      onWillPop: () async {
        _previewStore.removePreviewListener();
        _previewStore.leave();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            (_previewStore.localTracks.isEmpty)
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ))
                : SizedBox(
                    height: itemHeight,
                    width: itemWidth,
                    child: (_previewStore.isVideoOn)
                        ? HMSVideoView(
                            scaleType: ScaleType.SCALE_ASPECT_FILL,
                            track: _previewStore.localTracks[0],
                            matchParent: false,
                          )
                        : SizedBox(
                            height: itemHeight,
                            width: itemWidth,
                            child: Center(
                                child: CircleAvatar(
                                    backgroundColor:
                                        Utilities.getBackgroundColour(
                                            _previewStore.peer!.name),
                                    radius: 36,
                                    child: Text(
                                      Utilities.getAvatarTitle(
                                          _previewStore.peer!.name),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        color: Colors.white,
                                      ),
                                    ))),
                          ),
                  ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (_previewStore.peer != null &&
                            _previewStore.peer!.role.publishSettings!.allowed
                                .contains("video"))
                        ? GestureDetector(
                            onTap: _previewStore.localTracks.isEmpty
                                ? null
                                : () async {
                                    _previewStore.toggleCameraMuteState();
                                  },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Colors.transparent.withOpacity(0.2),
                              child: (_previewStore.isVideoOn)
                                  ? const Icon(
                                      Icons.videocam,
                                      color: Colors.blue,
                                    )
                                  : const Icon(
                                      Icons.videocam_off,
                                      color: Colors.blue,
                                    ),
                            ),
                          )
                        : Container(),
                    _previewStore.peer != null
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              _previewStore.removePreviewListener();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (_) => MeetingPage(
                                  roomLink: widget.roomLink,
                                  name: widget.name,
                                  isAudioOn: _previewStore.isAudioOn,
                                  hmsSDKInteractor:
                                      _previewStore.hmsSDKInteractor,
                                ),
                              ));
                            },
                            child: const Text(
                              'Join Now',
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : const SizedBox(),
                    (_previewStore.peer != null &&
                            _previewStore.peer!.role.publishSettings!.allowed
                                .contains("audio"))
                        ? GestureDetector(
                            onTap: () async {
                              _previewStore.toggleMicMuteState();
                            },
                            child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Colors.transparent.withOpacity(0.2),
                                child: (_previewStore.isAudioOn)
                                    ? const Icon(
                                        Icons.mic,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.mic_off,
                                        color: Colors.blue,
                                      )),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
