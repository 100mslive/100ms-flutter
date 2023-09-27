import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:hmssdk_flutter_example/room_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  QRCodeScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
    this.controller = qrController;
    controller!.resumeCamera();
    controller!.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        controller!.pauseCamera();
        FocusManager.instance.primaryFocus?.unfocus();

        Map<String, String>? endPoints;
        if (scanData.code!.trim().contains("app.100ms.live")) {
          List<String?>? roomData = RoomService.getCode(scanData.code!.trim());

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
          Constant.roomCode = scanData.code!.trim();
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => HMSPrebuilt(
                roomCode: Constant.roomCode,
                options: HMSPrebuiltOptions(
                    endPoints: endPoints,
                    iOSScreenshareConfig: HMSIOSScreenshareConfig(
                        appGroup: "group.flutterhms",
                        preferredExtension:
                            "live.100ms.flutter.FlutterBroadcastUploadExtension")))));
      }
    });
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
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderWidth: 5,
                    borderColor: Colors.white,
                  ),
                ),
              ),
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
