import 'dart:io';

import 'package:hms_room_kit/src/service/app_debug_config.dart';

String qaTokenEndPoint =
    "https://auth-nonprod.100ms.live${Platform.isIOS ? "/" : ""}";
String qaInitEndPoint = "https://qa-init.100ms.live/init";

String? getLayoutAPIEndpoint() {
  return AppDebugConfig.isProdRoom ? null : "https://api-nonprod.100ms.live";
}
