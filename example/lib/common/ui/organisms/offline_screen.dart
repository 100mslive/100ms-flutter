//Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter_example/common/util/app_color.dart';

class OfflineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.2),
                child: Image.asset(
                  'assets/icons/no_network.png',
                  width: MediaQuery.of(context).size.width * 0.22,
                  height: MediaQuery.of(context).size.width * 0.22,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.05, bottom: screenHeight * 0.1),
                child: Center(
                  child: Text(
                    'Oops, No internet Connection.\nReconnecting...',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        color: borderColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
