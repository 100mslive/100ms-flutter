



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hms_room_kit/hms_room_kit.dart';
import 'package:sample_application/presentation/features/dashbaord/dashbaord_main_view.dart';

class HomeMainView extends StatefulWidget {
  const HomeMainView({super.key});

  @override
  State<HomeMainView> createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
final TextEditingController _usernameTextController = TextEditingController();
final TextEditingController _roomCodeTextController = TextEditingController();
  GlobalKey<FormState> _formKey =  GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

var width = MediaQuery.of(context).size.width;


    return WillPopScope(
      onWillPop: ()async{
        print('object');
        return true;
      },
      child: SafeArea(
        child: Scaffold(
            body: Center(
          child: SingleChildScrollView(
            child: Form(
key: _formKey,
              child: Column(
                children: [
            
            
                  SvgPicture.asset(
                    'assets/welcome.svg',
                    width: width * 0.95,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text('Experience the power of 100ms',
                        textAlign: TextAlign.center,
                        style: HMSTextStyle.setTextStyle(
                            letterSpacing: 0.25,
                            color: themeDefaultColor,
                            height: 1.17,
                            fontSize: 34,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Text(
                        'Jump right in by pasting a room code',
                        textAlign: TextAlign.center,
                        style: HMSTextStyle.setTextStyle(
                            letterSpacing: 0.5,
                            color: themeSubHeadingColor,
                            height: 1.5,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Room Code",
                            key: Key('room_code_text'),
                            style: HMSTextStyle.setTextStyle(
                                color: themeDefaultColor,
                                height: 1.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.95,
                    child: TextFormField(
                      
                      validator: (value){
                        if( value == null || value.isEmpty  ) return 'Room code is required';
                      return null;
                      
                      }  ,
                      key: Key('room_code_field'),
                      textInputAction: TextInputAction.done,
                      cursorColor: HMSThemeColors.primaryDefault,
                 
                      style: HMSTextStyle.setTextStyle(),
                      controller: _roomCodeTextController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          focusColor: hmsdefaultColor,
                          contentPadding: EdgeInsets.only(left: 16),
                          fillColor: themeSurfaceColor,
                          filled: true,
                          hintText: 'Paste the room code or link here',
                          hintStyle: HMSTextStyle.setTextStyle(
                              color: hmsHintColor,
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          suffixIcon: _roomCodeTextController.text == ''
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _roomCodeTextController.text = "";
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: HMSThemeColors.primaryDefault, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                    SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Username",
                            key: Key('username_text'),
                            style: HMSTextStyle.setTextStyle(
                                color: themeDefaultColor,
                                height: 1.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.95,
                    child: TextFormField(
                      
                    
                      key: Key('username_field'),
                      textInputAction: TextInputAction.done,
                      cursorColor: HMSThemeColors.primaryDefault,
                 
                      style: HMSTextStyle.setTextStyle(),
                      controller: _usernameTextController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          focusColor: hmsdefaultColor,
                          contentPadding: EdgeInsets.only(left: 16),
                          fillColor: themeSurfaceColor,
                          filled: true,
                          hintText: 'Please enter username',
                          hintStyle: HMSTextStyle.setTextStyle(
                              color: hmsHintColor,
                              height: 1.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          suffixIcon: _usernameTextController.text == ''
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _usernameTextController.text = "";
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: HMSThemeColors.primaryDefault, width: 2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                 const SizedBox(
                    height: 16,
                  ),
                       
                 const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: width * 0.95,
                      child: Divider(
                        height: 5,
                        color: dividerColor,
                      )),
            
               
                    SizedBox(
                    width: width * 0.95,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(hmsdefaultColor),
                          backgroundColor:
                              MaterialStateProperty.all(hmsdefaultColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ))),
                      onPressed: () async {

                        if( _formKey.currentState!.validate()){
                             bool res = await Utilities.getCameraPermissions();
                        if (res) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => DashboardMainView(
                                roomCode: _roomCodeTextController.text,
                                userName: _usernameTextController.text,
                              )));
                        }
                        }
                     
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          
                          
                            HMSTitleText(
                                key: Key("Start the party"),
                                text: 'Start the party',
                                textColor: enabledTextColor),
                                  SizedBox(
                              width: 5,
                            ),
                              Icon(
                              Icons.keyboard_arrow_right,
                              size: 18,
                              color: enabledTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );;
  }
}