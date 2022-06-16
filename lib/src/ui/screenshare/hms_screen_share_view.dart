import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show StandardMessageCodec;

class HMSScreenShareView extends StatelessWidget {
  
  const HMSScreenShareView();

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'HMSFlutterScreenShareView';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );  
    } else {
      // TODO: handle Android case
      return Container();
    }
    
  }
}
