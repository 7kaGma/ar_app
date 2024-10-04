import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/shadow_for_btn.dart';
import 'package:ar_app/constant/images_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_backhome.dart';
import 'package:ar_app/component/btn_howtouse.dart';
import 'package:ar_app/component/btn_primary.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'dart:async';

class Waitingtime extends StatefulWidget {
  const Waitingtime({super.key, required this.value});
  final String value;

  @override
  State<Waitingtime> createState() => _WaitingtimeState();
}

class _WaitingtimeState extends State<Waitingtime> with WidgetsBindingObserver {
  //BGのパス
  late String bgImage;
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

    ImagesPath imagesPath = ImagesPath();
    bgImage = imagesPath.getBgPath(widget.value);
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
        extendBodyBehindAppBar: true, // AppBarの背後にbodyを拡張
        appBar: const AppBarCustom(
          leading: BtnBackhome(),
          actions: [BtnHowtouse()],
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/$bgImage'),
              fit: BoxFit.cover,
            )),
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstants.backgroundColorSub
                                  .withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.value),
                                  const Text('待ち時間'),
                                  Text('${time.inMinutes.toString()}分'),
                                  Text(stage),
                                ],
                              ),
                            ),
                          )),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShadowForBtn(
                                  child: BtnPrimary(
                                onPressed: () {
                                  context.push('/qrreader/waitingtime/arcamera',
                                      extra: stageNumber);
                                },
                                text: "写真を撮る",
                              )),
                              const SizedBox(
                                height: 140,
                              ),
                            ],
                          ))
                    ],
                  ),
                ))));
  }
}
