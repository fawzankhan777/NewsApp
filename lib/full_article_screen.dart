import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class FullArticleScreen extends StatefulWidget {
  final String articleUrl;

  const FullArticleScreen({Key? key, required this.articleUrl}) : super(key: key);

  @override
  _FullArticleScreenState createState() => _FullArticleScreenState();
}

class _FullArticleScreenState extends State<FullArticleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Article'),
      ),
      body: WebView(
        initialUrl: widget.articleUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
