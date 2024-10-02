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

class _WaitingtimeState extends State<Waitingtime> with WidgetsBindingObserver {
  // タイマー
  Timer? timer;
  // 管理する時間
  late Duration time;
  // Duration
  late DateTime backgroundStartTime;
  late Duration backgroundDurationTime;
  String stage = 'ステージ1';
  int stageNumber = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    time = Duration.zero;
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
      backgroundDurationTime = calcBackgroundDurationTime(backgroundStartTime);
      time = time + backgroundDurationTime;
      countTime();
    }
  }

  DateTime onPaused() {
    return DateTime.now();
  }

  Duration calcBackgroundDurationTime(DateTime startTime) {
    return DateTime.now().difference(startTime);
  }

  void countTime() {
    timer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      setState(() {
        time = time + const Duration(seconds: 60);
        getStaging(time);
      });
    });
  }

  void getStaging(Duration time) {
    int waitingTime = time.inMinutes;
    if (waitingTime < 120) {
      int divide = 15;
      stageNumber = (waitingTime ~/ divide);
      setState(() {
        stage = 'ステージ${(stageNumber + 1).toString()}';
      });
    } else if (120 <= waitingTime) {
      setState(() {
        stage = 'ステージMAX';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
          leading: const BackHomeBtn(),
          title: const Text("WaitingTime"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.value),
              const Text('待ち時間'),
              Text('${time.inMinutes.toString()}分'),
              Text(stage),
              ElevatedButton(
                  onPressed: () {
                    context.push('/qrreader/waitingtime/arcamera',
                        extra: stageNumber);
                  },
                  child: const Text('写真を撮る'))
            ],
          ),
        ));
  }
}
