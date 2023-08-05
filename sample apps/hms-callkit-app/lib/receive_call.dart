//Package imports
import 'package:flutter/material.dart';
import 'package:hms_callkit/utility_functions.dart';
import 'package:hms_callkit/app_navigation/app_router.dart';
import 'package:hms_callkit/app_navigation/navigation_service.dart';

class ReceiveCall extends StatefulWidget {
  final Map<String, dynamic>? callKitParams;
  const ReceiveCall({super.key, required this.callKitParams});

  @override
  State<ReceiveCall> createState() => _ReceiveCallState();
}

class _ReceiveCallState extends State<ReceiveCall> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: NetworkImage(widget.callKitParams?["avatar"]),
                    fit: BoxFit.fill,
                    height: 100,
                    width: 100,
                  )),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(hmsdefaultColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ))),
                onPressed: () async {
                  NavigationService.instance.pushNamedIfNotCurrent(
                      AppRoute.callingPage,
                      args: widget.callKitParams!["extra"]["authToken"]);
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Join Call',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
