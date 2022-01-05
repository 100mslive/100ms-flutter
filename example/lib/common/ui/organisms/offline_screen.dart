import 'package:flutter/material.dart';

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
                    'Oops, No internet connection.\n\nReconnecting...',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
