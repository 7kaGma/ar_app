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

class Arcamera extends StatefulWidget {
  const Arcamera({super.key, required this.stageNumber});
  final int stageNumber;
  @override
  State<Arcamera> createState() => _ArcameraState();
}

class _ArcameraState extends State<Arcamera> {
  String count = '0'; //Unityからの通信用＿現状不要
  bool _isUnityLoaded = false;

  //init関数
  @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // initStateでカメラ権限をリクエスト
  }

  // カメラの権限リクエスト処理
  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      // すでにカメラの権限が許可されている場合
    } else {
      // カメラの権限が許可されていない場合、リクエストする
      PermissionStatus status = await Permission.camera.request();
    }
  }

  //写真を撮影する
  ScreenshotController screenshotController = ScreenshotController();
  Future<void> takePhoto() async {
    Uint8List? capturedImage = await screenshotController.capture();
    if (capturedImage != null) {
      context.push('/qrreader/waitingtime/arcamera/preview',
          extra: capturedImage);
    } else {
      print("error");
    }
  }

  // Unity処理
  UnityWidgetController? _unityWidgetController;
  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    setState(() {
      _isUnityLoaded = true;
    });
  }

  void onUnityMessage(dynamic message) {
    setState(() {
      count = message.toString();
    });
  }

  void sendNumber(int number) {
    if (_unityWidgetController != null) {
      _unityWidgetController?.postMessage(
        'ArModel',
        'SwitchObject',
        number.toString(),
      );
    }
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
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      if (!_isUnityLoaded)
                        Container(
                          color: ColorConstants.backgroundColorSub,
                          child: const Center(
                            child: Text(
                              "カメラ起動中",
                              style: TextStyle(color: ColorConstants.fontColor),
                            ),
                          ),
                        ),
                      Expanded(
                        child: UnityWidget(
                          onUnityCreated: onUnityCreated,
                          onUnityMessage: onUnityMessage,
                          fullscreen: false,
                        ),
                      )
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
                        onPressed: () => {print("switch")},
                        icon: const Icon(Icons.cameraswitch),
                      ),
                      BtnShutter(
                          size: 80,
                          onPressed: () {
                            takePhoto();
                          }),
                      IconButton(
                        onPressed: () => {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        (2 / 3),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 10.0,
                                                  mainAxisSpacing: 10.0),
                                          itemCount: 8,
                                          itemBuilder: (context, index) {
                                            return ElevatedButton(
                                              onPressed: widget.stageNumber >=
                                                      index
                                                  ? () {
                                                      setState(() {
                                                        sendNumber(index);
                                                      });
                                                    }
                                                  : null, // stageNumber が index より小さい場合ボタンは無効化
                                              child: Text(
                                                  'ボタン${index.toString()}'),
                                            );
                                          },
                                        )),
                                  ))
                        },
                        icon: const Icon(
                          Icons.palette,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )));
  }
}
