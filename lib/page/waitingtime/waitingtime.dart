import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/shadow_for_btn.dart';
import 'package:ar_app/constant/images_path.dart';
import 'package:ar_app/utils/show_dialog_backhome.dart';
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
  late String sceneNumber;
  // タイマー
  Timer? timer;
  // 管理する時間
  late Duration time;
  // Duration
  late DateTime backgroundStartTime;
  late Duration backgroundDurationTime;
  String stage = 'STAGE1';
  int stageNumber = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    time =  Duration.zero;
    countTime();

    DataArray dataArray = DataArray();
    bgImage = dataArray.getBgPath(widget.value);
    sceneNumber = dataArray.getScene(widget.value);
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
      setState(() {
        time += backgroundDurationTime;
        getStaging(time);
      });
      backgroundDurationTime = Duration.zero; 
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
        stage = 'STAGE${(stageNumber + 1).toString()}';
      });
    } else if (120 <= waitingTime) {
      setState(() {
        stage = 'STAGE MAX';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          showDialogBackhome(context);
        },
        child: Scaffold(
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
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.2),
                    child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: SafeArea(
                            child: Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  child: Text(widget.value,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          color: ColorConstants
                                                              .fontColor,
                                                          shadows: [
                                                            Shadow(
                                                                offset: Offset(
                                                                    0, 0),
                                                                blurRadius: 8,
                                                                color: ColorConstants
                                                                    .backgroundColorSub)
                                                          ]))),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: ColorConstants
                                                      .backgroundColorSub
                                                      .withOpacity(0.7),
                                                  shape: BoxShape.circle),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text('待ち時間',
                                                        style: TextStyle(
                                                            color: ColorConstants
                                                                .fontColor)),
                                                    Text(
                                                        '${time.inMinutes.toString()}分',
                                                        style: const TextStyle(
                                                            fontSize: 48,
                                                            color: ColorConstants
                                                                .fontColor)),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(stage,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            color: ColorConstants
                                                                .fontColor)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: ShadowForBtn(
                                      child: BtnPrimary(
                                    onPressed: () {
                                      context.push(
                                          '/qrreader/waitingtime/arcamera',
                                          extra: {
                                            'stageNumber': stageNumber,
                                            'sceneNumber':sceneNumber, 
                                          });
                                    },
                                    text: "ARと写真を撮る",
                                  )),
                                ))
                          ],
                        )))))));
  }
}
