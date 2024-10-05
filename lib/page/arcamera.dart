import 'package:ar_app/component/btn_shutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/btn_backward.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'package:audioplayers/audioplayers.dart';

class Arcamera extends StatefulWidget {
  const Arcamera({super.key, required this.stageNumber});
  final int stageNumber;
  @override
  State<Arcamera> createState() => _ArcameraState();
}

class _ArcameraState extends State<Arcamera> {
  bool _isUnityLoaded = false;

  //init関数
  @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // initStateでカメラ権限をリクエスト
  }

  @override
  void dispose() {
    // UnityControllerを破棄する
    _unityWidgetController?.dispose();
    super.dispose();
  }

  // カメラの権限リクエスト処理
  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      // すでにカメラの権限が許可されている場合
    } else {
      // カメラの権限が許可されていない場合、リクエストする
      await Permission.camera.request();
    }
  }

  //写真を撮影する
  final ScreenshotController _screenshotController = ScreenshotController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _takePhoto() async {
    await _audioPlayer.play(AssetSource('sounds/shutter.mp3'));
    Uint8List? capturedImage = await _screenshotController.capture();
    if (capturedImage != null) {
      context.push('/qrreader/waitingtime/arcamera/preview',
          extra: capturedImage);
    } else {
      print("error");
    }
  }

  // シャッターの制御
  bool _isBtnEnabled = false;
  void _handleShutter() async {
    setState(() {
      _isBtnEnabled = false;
      _unityWidgetController?.pause();
    });

    await _takePhoto();

    setState(() {
      _isBtnEnabled = true;
      _unityWidgetController?.resume();
    });
  }

  // Unity処理
  UnityWidgetController? _unityWidgetController;
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    setState(() {
      _isUnityLoaded = true;
      _isBtnEnabled = true;
    });
  }

  Future<void> sendNumber(int number) async {
    if (_unityWidgetController != null) {
      _unityWidgetController?.postMessage(
        'Scripts',
        'UpdateDisplayObjectNumber',
        number.toString(),
      );
    }
  }

  Future<void> updateAr() async {
    if (_unityWidgetController != null) {
      _unityWidgetController?.postMessage('ArModel', 'SwitchObject', '');
    }
  }

  // モーダルウィンドウの表示
  int? selectedButtonIndex = 0;
  void showCustomModalBottomSheet(
    BuildContext context,
    int stageNumber,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // モーダルシートのサイズ制御を有効にする
      enableDrag: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * (2 / 5),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "ARを切り替える",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: stageNumber >= index
                              ? () async {
                                  Navigator.pop(context);
                                  setState(() {
                                    selectedButtonIndex = index;
                                  });

                                  // 非同期処理を適切に処理
                                  await sendNumber(index);
                                  await updateAr();
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 300), // アニメーションの時間を指定
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: selectedButtonIndex == index
                                  ? Colors.black
                                      .withOpacity(0.4) // 選択されたボタンの色を変更
                                  : Colors.grey.shade300, // デフォルトの色
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20), // ボタンの高さを調整
                              child: Text(
                                'STAGE${index + 1}',
                                style: TextStyle(
                                  color: stageNumber >= index
                                      ? ColorConstants.backgroundColor
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, // AppBarの背後にbodyを拡張
        appBar: const AppBarCustom(
          leading: BtnBackward(),
        ),
        body: Expanded(
            child: Column(
          children: [
            Expanded(
              child: Container(color: ColorConstants.backgroundColorSub),
            ),
            Center(
                child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Screenshot(
                  controller: _screenshotController,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      UnityWidget(
                        onUnityCreated: onUnityCreated,
                        fullscreen: false,
                      ),
                      if (!_isUnityLoaded)
                        Container(
                          color: ColorConstants.backgroundColorSub,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  "カメラ起動中",
                                  style: TextStyle(
                                      color: ColorConstants.fontColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )),
            )),
            Expanded(
              child: Container(
                color: ColorConstants.backgroundColorSub,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cameraswitch),
                        iconSize: 40,
                        onPressed: _isBtnEnabled
                            ? () {
                                print("click");
                              }
                            : null,
                      ),
                      BtnShutter(
                          size: 80,
                          onPressed: _isBtnEnabled ? _handleShutter : null),
                      IconButton(
                          icon: const Icon(Icons.view_in_ar_outlined),
                          iconSize: 40,
                          onPressed: _isBtnEnabled
                              ? () {
                                  showCustomModalBottomSheet(
                                      context, widget.stageNumber);
                                }
                              : null)
                    ],
                  ),
                ),
              ),
            )
          ],
        )));
  }
}
