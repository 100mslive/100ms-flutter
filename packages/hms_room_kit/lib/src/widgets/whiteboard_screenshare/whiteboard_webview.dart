library;

///Dart imports
import 'dart:developer';

///Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

///Project imports
import 'package:hms_room_kit/src/meeting/meeting_store.dart';

///[WhiteboardWebView] is a widget that renders the whiteboard webview
class WhiteboardWebView extends StatefulWidget {
  const WhiteboardWebView({Key? key}) : super(key: key);

  @override
  State<WhiteboardWebView> createState() => _WhiteboardWebViewState();
}

class _WhiteboardWebViewState extends State<WhiteboardWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (_) {
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            log("Error occured in whiteboard tile: ${error.description}");
          },
        ),
      );
  }

  @override
  void dispose() {
    _controller.loadHtmlString("https://www.100ms.live/");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
        selector: (_, meetingStore) => meetingStore.whiteboardModel?.url,
        builder: (_, url, __) {
          ///If the url is not null we render the webview
          return url != null
              ? WebViewWidget(
                  controller: _controller..loadRequest(Uri.parse(url)))
              : const SizedBox();
        });
  }
}
