import 'dart:async';
import 'dart:io';
import 'package:connie/src/abstract/cms_query_impl.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatelessWidget {
  var blocNativeBrdige = CMSQueryImpl();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool pubcafe = false;
  String queryPubCafe;
  final String query;

  WebScreen({
    Key key,
    this.query,
  }) : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (query.trim().contains("pub")) {
      pubcafe = true;
      queryPubCafe = "_where%5B_or%5D%5B0%5D%5Bname_contains%5D=varsity";
    } else if ((query.trim().contains("cafe"))) {
      pubcafe = true;
      queryPubCafe = "_where%5B_or%5D%5B0%5D%5Bname_contains%5D=varsity";
    } else {
      pubcafe = false;

      queryPubCafe = query;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: pubcafe
            ? "https://customer.dev.conigitalcloud.io/products?" + queryPubCafe
            : "https://ecommerce.dev.conigitalcloud.io/product/" + query,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print("WebView is loading (progress : $progress%)");
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
