import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mishi/mishi/presentation/utils/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewCustom extends StatefulWidget {
  final String url;
  const WebViewCustom({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewCustom> createState() => _WebViewCustomState();
}

class _WebViewCustomState extends State<WebViewCustom> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : Stack(),
        ],
      ),
    );
  }
}
