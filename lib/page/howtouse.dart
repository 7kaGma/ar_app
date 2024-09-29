import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Howtouse extends StatefulWidget {
  const Howtouse({super.key});

  @override
  State<Howtouse> createState() => _HowtouseState();
}

class _HowtouseState extends State<Howtouse> {
  //WebViewのContlloer
  late WebViewController contlloer;

  @override
  void initState() {
    super.initState();
    contlloer = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://2matr7.sakura.ne.jp/test_site"))
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
