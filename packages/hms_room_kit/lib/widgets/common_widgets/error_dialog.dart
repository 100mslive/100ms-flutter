import 'package:flutter/cupertino.dart';
import 'package:hms_room_kit/common/utility_components.dart';
import 'package:hms_room_kit/common/utility_functions.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class ErrorDialog {
  ///This method is used to show error dialog
  ///for all the terminal errors i.e. the errors from which
  ///the SDK cannot recover and the uesr needs to leave the room
  static void showTerminalErrorDialog(
      {required BuildContext context, required HMSException error}) {
    if ((error.code?.errorCode == 1003) ||
        (error.code?.errorCode == 2000) ||
        (error.code?.errorCode == 4005)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        UtilityComponents.showErrorDialog(
            context: context,
            errorMessage:
                "Error Code: ${error.code?.errorCode ?? ""} ${error.description}",
            errorTitle: error.message ?? "",
            actionMessage: "Leave Room",
            action: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
      });
    } else {
      Utilities.showToast(
          "Error : ${error.code?.errorCode ?? ""} ${error.description} ${error.message}",
          time: 5);
    }
  }
}
