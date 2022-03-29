
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

abstract class HMSNetworkListener{

  void onNetworkQuality({required int quality,HMSPeer? peer});

}