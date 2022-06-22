import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/ui/organisms/user_name_dialog_organism.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';
import 'package:hmssdk_flutter_example/enum/meeting_flow.dart';
import 'package:hmssdk_flutter_example/preview/preview_page.dart';
import 'package:hmssdk_flutter_example/preview/preview_store.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
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
        if (flow == MeetingFlow.join) {
          Utilities.setRTMPUrl(scanData.code!);
          String user = await showDialog(
              context: context, builder: (_) => UserNameDialogOrganism());
          if (user.isNotEmpty) {
            bool res = await Utilities.getPermissions();
            if (res) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => ListenableProvider.value(
                        value: PreviewStore(),
                        child: PreviewPage(
                          roomId: scanData.code!.trim(),
                          user: user,
                          flow: MeetingFlow.join,
                          mirror: true,
                          showStats: false,
                        ),
                      )));
            }
          } else {
            controller.resumeCamera();
          }
        } else {
          Utilities.showToast("Invalid QR Code");
          controller.resumeCamera();
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
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Scan QR Code",
                    style: GoogleFonts.inter(
                        color: defaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
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
                          Text('Join with Link Instead',
                              style: GoogleFonts.inter(
                                  height: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: enabledTextColor)),
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
