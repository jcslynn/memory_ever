import 'package:flutter/material.dart';
import 'package:memory_ever/classes/history/history.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final History history = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(history.getName()),
      ),
      body: WebView(
        initialUrl: history.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
