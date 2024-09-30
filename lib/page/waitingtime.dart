import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_backhome.dart';
import 'package:ar_app/component/btn_howtouse.dart';
import 'dart:async';

class Waitingtime extends StatefulWidget {
  const Waitingtime({super.key, required this.value});
  final String value;

  @override
  State<Waitingtime> createState() => _WaitingtimeState();
}

class _WaitingtimeState extends State<Waitingtime> with WidgetsBindingObserver{

  // タイマー
  Timer? timer;
  // 管理する時間
  late DateTime time;
  // Duration
  late DateTime backgroundStartTime;
  late Duration durationTime;

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    time = DateTime.utc(0,0,0);
    countTime();
  }

  @override
  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  

  // バックグラウンドでの処理
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // バックグランドに遷移したとき
      timer?.cancel();
      backgroundStartTime = onPaused();
    } else if (state == AppLifecycleState.resumed) {
      //フォアグラウンドに遷移したとき
      durationTime = calcDurationTime(backgroundStartTime);
      time = time.add(Duration(seconds: durationTime.inSeconds));
      countTime();
    }
  }

  DateTime onPaused() {
    DateTime startTime = DateTime.now();
    return startTime;
  }

  Duration calcDurationTime(DateTime startTime) {
    Duration backgroundDuration = DateTime.now().difference(startTime);
    return backgroundDuration;
  }

  void countTime (){
    timer = Timer.periodic(
      const Duration(seconds: 1), 
      (Timer timer){
        setState(() {
          time = time.add((const Duration(seconds: 1)));
        });
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          leading: const BackHomeBtn(),
          title: const Text("WaitingTime"),
          actions: const [HowtouseBtn()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.value),
              const Text('待ち時間'),
              Text('${time.minute.toString()}分'),
              ElevatedButton(
                  onPressed: () {
                    context.push('/qrreader/waitingtime/arcamera');
                  },
                  child: const Text('写真を撮る'))
            ],
          ),
        ));
  }
}
