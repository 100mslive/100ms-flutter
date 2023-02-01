import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HMSVideoPlayer extends StatelessWidget {
  final String url;
  const HMSVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'HMSVideoPlayer',
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {'url': url},
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'HMSVideoPlayer',
        creationParamsCodec: StandardMessageCodec(),
        creationParams: {'url': url},
      );
    } else {
      throw UnimplementedError(
          'Video Player is not implemented for this platform ${Platform.localHostname}');
    }
  }
}
