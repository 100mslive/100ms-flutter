///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter_example/foreground_task_handler.dart';
import 'package:hmssdk_flutter_example/room_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

///[QRCodeScreen] is a StatefulWidget that is used to handle the scan the QR code functionality
class QRCodeScreen extends StatefulWidget {
  final String uuidString;
  QRCodeScreen({Key? key, required this.uuidString}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onQRViewCreated(BarcodeCapture barcodeCapture) async {
    try {
      final List<Barcode> barcodes = barcodeCapture.barcodes;
      if (barcodes.isNotEmpty) {
        log(barcodes[0].rawValue ?? "");
        String? rawValue = barcodes[0].rawValue;
        if (rawValue != null) {
          FocusManager.instance.primaryFocus?.unfocus();

          Map<String, String>? endPoints;
          if (rawValue.trim().contains("app.100ms.live")) {
            List<String?>? roomData = RoomService.getCode(rawValue.trim());

            //If the link is not valid then we might not get the code and whether the link is a
            //PROD or QA so we return the error in this case
            if (roomData == null || roomData.isEmpty) {
              return;
            }

            ///************************************************************************************************** */

            ///This section can be safely commented out as it's only required for 100ms internal usage

            //qaTokenEndPoint is only required for 100ms internal testing
            //It can be removed and should not affect the join method call
            //For _endPoint just pass it as null
            //the endPoint parameter in getAuthTokenByRoomCode can be passed as null
            //Pass the layoutAPIEndPoint as null the qa endPoint is only for 100ms internal testing

            ///If you wish to set your own token end point then you can pass it in the endPoints map
            ///The key for the token end point is "tokenEndPointKey"
            ///The key for the init end point is "initEndPointKey"
            ///The key for the layout api end point is "layoutAPIEndPointKey"
            if (roomData[1] == "false") {
              endPoints = RoomService.setEndPoints();
            }

            ///************************************************************************************************** */

            Constant.roomCode = roomData[0] ?? '';
          } else {
            Constant.roomCode = rawValue.trim();
          }
          Utilities.saveStringData(key: "meetingLink", value: rawValue.trim());
          await initForegroundTask();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => WithForegroundTask(
                    child: HMSPrebuilt(
                        roomCode: Constant.roomCode,
                        onLeave: stopForegroundTask,
                        options: HMSPrebuiltOptions(
                            userName: AppDebugConfig.nameChangeOnPreview
                                ? null
                                : "Flutter User",
                            userId: widget.uuidString,
                            endPoints: endPoints,
                            iOSScreenshareConfig: HMSIOSScreenshareConfig(
                                appGroup: "group.flutterhms",
                                preferredExtension:
                                    "live.100ms.flutter.FlutterBroadcastUploadExtension"),
                            enableNoiseCancellation: true)),
                  )));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: borderColor,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: themeDefaultColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HMSTitleText(
                            text: "Scan QR Code",
                            textColor: themeSubHeadingColor,
                            letterSpacing: 0.15,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  height:
                      orientation == Orientation.portrait ? height * 0.75 : 500,
                  width: MediaQuery.of(context).size.width - 40,
                  child: MobileScanner(
                      controller: MobileScannerController(
                          detectionSpeed: DetectionSpeed.noDuplicates,
                          facing: CameraFacing.back),
                      onDetect: (capture) => _onQRViewCreated(capture))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: width * 0.95,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(themeSurfaceColor),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        side: MaterialStateProperty.all(
                            BorderSide(color: borderColor)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.link,
                            size: 22,
                            color: enabledTextColor,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          HMSTitleText(
                              text: 'Join with Link Instead',
                              textColor: enabledTextColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
