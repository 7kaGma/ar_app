import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_howtouse.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Home"),
          actions: const [HowtouseBtn()],
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                context.push('/qrreader');
              },
              child: const Text("列に並ぶ")),
          ElevatedButton(
              onPressed: () {
                context.push('/webpage');
              },
              child: const Text("公式サイト")),
          ElevatedButton(
              onPressed: () {
                context.push('/waitingtime');
              },
              child: const Text("AR"))
        ])));
  }
}
