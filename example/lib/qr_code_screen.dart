import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_components.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/hls-streaming/util/hls_title_text.dart';
import 'package:hmssdk_flutter_example/preview/preview_details.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  final MeetingFlow meetingFlow;

  QRCodeScreen({required this.meetingFlow});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (scanData.code != null) {
        MeetingFlow flow = Utilities.deriveFlow(scanData.code!);
        if (flow == MeetingFlow.meeting) {
          Utilities.setRTMPUrl(scanData.code!);
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ListenableProvider.value(
                    value: PreviewStore(),
                    child: PreviewDetails(
                      meetingLink: scanData.code!.trim(),
                      meetingFlow: widget.meetingFlow,
                    ),
                  )));
        } else {
          bool res = await UtilityComponents.showErrorDialog(
              context: context,
              errorMessage: "Please scan a valid meeting URL",
              errorTitle: "Invalid Meeting Url");
          if (res) controller.resumeCamera();
        }
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
                        color: defaultColor,
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
                          HLSTitleText(
                            text: "Scan QR Code",
                            textColor: subHeadingColor,
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
                        shadowColor: MaterialStateProperty.all(surfaceColor),
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
                          HLSTitleText(
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
