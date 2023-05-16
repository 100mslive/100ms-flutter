import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/widgets/title_text.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/home_screen/user_detail_screen.dart';

class QRCodeScreen extends StatefulWidget {
  QRCodeScreen();

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    // if (Platform.isAndroid) {
    //   controller!.pauseCamera();
    // } else if (Platform.isIOS) {
    //   controller!.resumeCamera();
    // }
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  // void _onQRViewCreated(QRViewController qrController) {
  //   this.controller = qrController;
  //   controller!.resumeCamera();
  //   controller!.scannedDataStream.listen((scanData) async {
  //     if (scanData.code != null) {
  //       MeetingFlow flow = Utilities.deriveFlow(scanData.code!);
  //       if (flow == MeetingFlow.meeting || flow == MeetingFlow.hlsStreaming) {
  //         controller!.pauseCamera();
  //         Utilities.setRTMPUrl(scanData.code!);
  //         FocusManager.instance.primaryFocus?.unfocus();
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (_) => UserDetailScreen(
  //             meetingLink: scanData.code!.trim(),
  //             meetingFlow: flow,
  //           ),
  //         ));
  //       } else {
  //         Utilities.showToast("Invalid meeting url");
  //         controller!.resumeCamera();
  //       }
  //     }
  //   });
  // }

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
                          TitleText(
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
                          TitleText(
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
