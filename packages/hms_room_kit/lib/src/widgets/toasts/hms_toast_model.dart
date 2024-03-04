///Package imports
library;

import 'package:flutter/cupertino.dart';

///Project imports
import 'package:hms_room_kit/src/widgets/toasts/hms_toasts_type.dart';

///[HMSToastModel] is a model that is used to store the toasts data
///It takes the following parameters:
///[toastData] is the data that is to be shown in the toast
///[hmsToastType] is the type of toast to be shown
class HMSToastModel extends ChangeNotifier {
  final HMSToastsType hmsToastType;
  dynamic toastData;

  HMSToastModel(this.toastData, {required this.hmsToastType});

  void updateToast(dynamic toastData) {
    this.toastData = toastData;
    notifyListeners();
  }
}
