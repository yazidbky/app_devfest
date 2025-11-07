import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter/webview_flutter.dart';

void initializeWebView(WebViewController controller) {
  if (controller.platform is AndroidWebViewController) {
    (controller.platform as AndroidWebViewController)
      ..setMediaPlaybackRequiresUserGesture(false)
      ..setOnPlatformPermissionRequest((request) {
        request.grant();
      });
  }
}
