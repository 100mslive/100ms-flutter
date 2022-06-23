import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';

class HLSPreviewScreen extends StatefulWidget {
  String name;
  String roomId;
  HLSPreviewScreen({required this.name, required this.roomId});
  @override
  State<HLSPreviewScreen> createState() => _HLSPreviewScreenState();
}

class _HLSPreviewScreenState extends State<HLSPreviewScreen> {
  @override
  void initState(){
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PreviewStore())],
    );
    super.initState();
    initPreview();
  }

  void initPreview() async {
    bool ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.name, roomId: "https://yogi.app.100ms.live/preview/ssz-eqr-eaa");
    if (ans == false) {
      Navigator.of(context).pop();
      UtilityComponents.showErrorDialog(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height;
    final double itemWidth = size.width;
    final _previewStore = context.watch<PreviewStore>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            (_previewStore.localTracks.isEmpty)?CircularProgressIndicator(strokeWidth: 2,):Container(
              height: itemHeight,
              width: itemWidth,
              child:
                  // (_previewStore.isVideoOn)
                  //     ? HMSVideoView(
                  //         scaleType: ScaleType.SCALE_ASPECT_FILL,
                  //         track: _previewStore.localTracks[0],
                  //         setMirror: true,
                  //         matchParent: false,
                  //       )
                  //     :
                  Container(
                height: itemHeight,
                width: itemWidth,
                child: Center(
                    child: CircleAvatar(
                        backgroundColor: Utilities.getBackgroundColour(
                            _previewStore.peer!.name),
                        radius: 36,
                        child: Text(
                          Utilities.getAvatarTitle(_previewStore.peer!.name),
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ))),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text("Let's get you started, ${widget.name}!",
                      style: GoogleFonts.inter(
                          color: defaultColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                  Text("Set your studio setup in less than 5 minutes",
                      style: GoogleFonts.inter(
                          color: disabledTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
