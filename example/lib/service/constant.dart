//Class contains the constants used throughout the application
import 'package:hmssdk_flutter_example/common/util/utility_function.dart';

class Constant {
  static String prodTokenEndpoint =
      "https://prod-in.100ms.live/hmsapi/get-token";

  static String qaTokenEndPoint = "https://qa-in.100ms.live/hmsapi/get-token";

  static String tokenQuery = "api/token";

  static String defaultMeetingLink =
      "https://yogi.app.100ms.live/meeting/ssz-eqr-eaa";

  static String tokenKey = "token";

  static String idKey = "id";

  static String roomIDKey = "roomID";

  static String hostKey = "host";
  static String defaultRole = 'host';
  static String meetingUrl = defaultMeetingLink;
  static String meetingCode = "";
  static String streamingUrl = "";
  static AppFlavors appFlavor = AppFlavors.prod;
}
