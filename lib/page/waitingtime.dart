import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_backhome.dart';
import 'package:ar_app/component/btn_howtouse.dart';

class Waitingtime extends StatefulWidget {
  const Waitingtime({super.key});

  @override
  State<Waitingtime> createState() => _WaitingtimeState();
}

class _WaitingtimeState extends State<Waitingtime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        leading: const BackHomeBtn(),
        title: const Text("WaitingTime"),
        actions: const [HowtouseBtn()],
      ) ,
      body: Column(
        children: [
          ElevatedButton(
            onPressed:(){
              context.push('/arcamera');
            }, 
            child: const Text('写真を撮る')
          )
        ],
      ),
    );
  }
}