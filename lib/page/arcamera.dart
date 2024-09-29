import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ar_app/component/btn_howtouse.dart';
import 'package:screenshot/screenshot.dart';

class Arcamera extends StatefulWidget {
  const Arcamera({super.key});
  @override
  State<Arcamera> createState() => _ArcameraState();
}

class _ArcameraState extends State<Arcamera> {

    String count = '0';

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
      await Permission.camera.request();
    }
  }

  //写真を撮影する
  ScreenshotController screenshotController = ScreenshotController();
  Future<void> takePhoto() async {
    Uint8List? capturedImage = await screenshotController.capture();
    if(capturedImage !=null){
      context.push('/preview',extra:capturedImage);
    }else{
      print("error");
    }
  }

  // Unity処理
  late UnityWidgetController? _unityWidgetController;
  void onUnityCreated(UnityWidgetController controller){
    _unityWidgetController = controller;
  }

  void onUnityMessage(dynamic message){
    setState(() {
      count = message.toString();
    });
  }

  void sendNumber(int number){
    _unityWidgetController?.postMessage(
      '3dmodel', 
      'SwitchObject', 
      number.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(count),
          actions: const [HowtouseBtn()],
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Screenshot(
                controller: screenshotController,
                child: UnityWidget(
                  onUnityCreated: onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  fullscreen: true,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => {print("switch")},
                      icon: const Icon(Icons.cameraswitch),
                    ),
                    ElevatedButton(
                        onPressed: () => takePhoto(),
                        child: const Text("仮")),
                    IconButton(
                      onPressed: () => {
                        sendNumber(1),
                      },
                      icon: const Icon(
                        Icons.palette,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
