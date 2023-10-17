

import 'package:flutter/material.dart';
import 'package:hms_room_kit/hms_room_kit.dart';

class DashboardMainView extends StatefulWidget {
  final String roomCode;
  final String? userName;
  const DashboardMainView({super.key , required this.roomCode , this.userName });
  

  @override
  State<DashboardMainView> createState() => _DashboardMainViewState();
}

class _DashboardMainViewState extends State<DashboardMainView> {

late String userName;
late  HMSPrebuiltOptions _options;



@override
  void initState() {
    userName = widget.userName ?? '';

    _options = HMSPrebuiltOptions(

  ////for prefill the name of the user in previewBuilt
  userName: userName,

); 
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HMSPrebuilt(
  options: _options,
    roomCode: widget.roomCode ,
    onLeave: (){
      
  /////onLeave do cleanup
    },
  
  );
  }
}