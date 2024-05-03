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
class WhiteboardWebView extends StatelessWidget {
  const WhiteboardWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MeetingStore, String?>(
        selector: (_, meetingStore) => meetingStore.whiteboardModel?.url,
        builder: (_, url, __) {
          ///If the url is not null we render the webview
          return url != null
              ? WebViewWidget(
                  controller: WebViewController()
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
                    )
                    ..loadRequest(Uri.parse(url)))
              : const SizedBox();
        });
  }
}
