import 'package:ar_app/component/btn_shutter.dart';
import 'package:ar_app/utils/show_modal_bottom%20_sheet_ar.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:ar_app/utils/camera_permission.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/btn_backward.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'package:audioplayers/audioplayers.dart';

class Arcamera extends StatefulWidget {
  const Arcamera(
      {super.key, required this.stageNumber, required this.sceneNumber});
  final int stageNumber;
  final String sceneNumber;
  @override
  State<Arcamera> createState() => _ArcameraState();
}

class _ArcameraState extends State<Arcamera> {
  bool _isUnityLoaded = false;
  late String sceneName;

  //init関数
  @override
  void initState() {
    super.initState();
    sceneName = "Scene${widget.sceneNumber}";
    print(sceneName);
    cameraPermission(context, this);
  }

  //dispose関数
  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
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
  bool _isVisible = false;
  void _handleShutter() async {
    setState(() {
      _isBtnEnabled = false;
      _isVisible = true;
      _unityWidgetController?.pause();
    });

    // 1秒後に非表示にする
    await Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = false;
      });
    });

    // 写真を撮る
    await _takePhoto();

    // ボタンを再度有効にしてUnityを再開
    setState(() {
      _isBtnEnabled = true;
      _unityWidgetController?.resume();
    });
  }

  // Unity処理
  UnityWidgetController? _unityWidgetController;

  void onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    print("UnityCeatedが起動したよ");
    print(sceneName);
    _unityWidgetController?.postMessage("Scripts", "setScene", sceneName);
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
  int selectedButtonIndex = 0;
  Future<void> clickFunction(int index) async {
    Navigator.pop(context);
    setState(() {
      selectedButtonIndex = index;
    });

    // 非同期処理を適切に処理
    await sendNumber(index);
    await updateAr();
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
                      unloadOnDispose: true,
                      fullscreen: false,
                    ),
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: _isVisible
                          ? ColorConstants.backgroundColorSub
                          : ColorConstants.backgroundColorSub.withOpacity(0),
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
                                style:
                                    TextStyle(color: ColorConstants.fontColor),
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
                      onPressed: _isBtnEnabled ? () {} : null,
                    ),
                    BtnShutter(
                        size: 80,
                        onPressed: _isBtnEnabled ? _handleShutter : null),
                    IconButton(
                        icon: const Icon(Icons.view_in_ar_outlined),
                        iconSize: 40,
                        onPressed: _isBtnEnabled
                            ? () {
                                showModalBottomSheetAr(
                                    context,
                                    "ARの切り替え",
                                    8,
                                    widget.stageNumber,
                                    clickFunction,
                                    selectedButtonIndex);
                              }
                            : null)
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
