import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webpage extends StatefulWidget {
  const Webpage({super.key});

  @override
  State<Webpage> createState() => _WebpageState();
}

class _WebpageState extends State<Webpage> {
  //WebViewのContlloer
  late WebViewController contlloer;

  @override
  void initState() {
    super.initState();
    contlloer = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.usj.co.jp/web/ja/jp"))
      ..enableZoom(true)
      ..clearCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Webpage"),
        ),
        body: WebViewWidget(controller: contlloer));
  }
}
